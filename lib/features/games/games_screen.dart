import 'dart:async';
import 'dart:math' as math;

import 'package:classipod/core/extensions/build_context_extensions.dart';
import 'package:classipod/core/navigation/routes.dart';
import 'package:classipod/core/theme/ipod_typography.dart';
import 'package:classipod/core/widgets/display_list_tile.dart';
import 'package:classipod/features/custom_screen_elements/custom_screen.dart';
import 'package:classipod/features/games/game_logic.dart';
import 'package:classipod/features/games/solitaire_logic.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

String gameTitle(GameKind kind) => switch (kind) {
  GameKind.brick => 'Brick',
  GameKind.snake => 'Snake',
  GameKind.merge => '2048',
  GameKind.solitaire => 'Solitaire',
};

class GamesScreen extends ConsumerStatefulWidget {
  const GamesScreen({super.key});
  @override
  ConsumerState<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends ConsumerState<GamesScreen> with CustomScreen {
  @override
  String get routeName => Routes.games.name;
  @override
  List<GameKind> get displayItems => GameKind.values;
  @override
  void onSelectPressed() => _open(selectedDisplayItem);
  void _open(int index) {
    setState(() => selectedDisplayItem = index);
    unawaited(context.pushNamed(displayItems[index].name));
  }

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
    child: ListView.builder(
      controller: scrollController,
      itemCount: displayItems.length,
      itemBuilder: (context, index) => DisplayListTile(
        text: gameTitle(displayItems[index]),
        isSelected: index == selectedDisplayItem,
        onTap: () => _open(index),
      ),
    ),
  );
}

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key, required this.kind});
  final GameKind kind;
  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen>
    with CustomScreen, WidgetsBindingObserver {
  BrickGame _brick = BrickGame();
  SnakeGame _snake = SnakeGame();
  MergeGame _merge = MergeGame();
  SolitaireGame _solitaire = SolitaireGame();
  GameDirection _direction = GameDirection.up;
  Timer? _timer;
  bool _paused = true;
  int _ticks = 0;

  @override
  String get routeName => widget.kind.name;
  @override
  List<Object> get displayItems => const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.kind == GameKind.brick || widget.kind == GameKind.snake) {
      _timer = Timer.periodic(const Duration(milliseconds: 40), (_) {
        if (!mounted || _paused || ModalRoute.of(context)?.isCurrent != true) {
          return;
        }
        setState(() {
          if (widget.kind == GameKind.brick) {
            _brick.tick(.04);
            if (_brick.over) _paused = true;
          } else if (++_ticks % 5 == 0) {
            _snake.tick();
            if (_snake.over) _paused = true;
          }
        });
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed && mounted) {
      setState(() => _paused = true);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onSelectPressed() {
    setState(() {
      switch (widget.kind) {
        case GameKind.brick:
          if (_brick.over) _brick = BrickGame();
          _paused = !_paused;
        case GameKind.snake:
          if (_snake.over) _snake = SnakeGame();
          _paused = !_paused;
        case GameKind.merge:
          if (_merge.over) {
            _merge = MergeGame();
          } else {
            _merge.move(_direction);
          }
        case GameKind.solitaire:
          if (_solitaire.won) {
            _solitaire = SolitaireGame();
          } else {
            _solitaire.choose();
          }
      }
    });
  }

  @override
  void onSelectLongPress() {
    setState(() {
      _brick = BrickGame();
      _snake = SnakeGame();
      _merge = MergeGame();
      _solitaire = SolitaireGame();
      _direction = GameDirection.up;
      _ticks = 0;
      _paused = true;
    });
  }

  void _turn(int delta) {
    setState(() {
      switch (widget.kind) {
        case GameKind.brick:
          _brick.move(delta * .045);
        case GameKind.snake:
          _snake.turnRelative(delta);
        case GameKind.merge:
          _direction = GameDirection.values[(_direction.index + delta + 4) % 4];
        case GameKind.solitaire:
          _solitaire.moveCursor(delta);
      }
    });
  }

  @override
  void scrollForward() => _turn(1);
  @override
  void scrollBackward() => _turn(-1);
  @override
  Future<void> seekForward() async {
    if (widget.kind == GameKind.solitaire) {
      setState(() => _solitaire.adjustDepth(1));
    } else {
      _turn(1);
    }
  }

  @override
  Future<void> seekBackward() async {
    if (widget.kind == GameKind.solitaire) {
      setState(() => _solitaire.adjustDepth(-1));
    } else {
      _turn(-1);
    }
  }

  void _swipe(DragEndDetails details) {
    final velocity = details.primaryVelocity;
    if (velocity == null || velocity.abs() < 40) return;
    final dir = velocity < 0 ? GameDirection.left : GameDirection.right;
    setState(() {
      if (widget.kind == GameKind.merge) _merge.move(dir);
      if (widget.kind == GameKind.snake) _snake.turn(dir);
    });
  }

  void _verticalSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity;
    if (velocity == null || velocity.abs() < 40) return;
    final dir = velocity < 0 ? GameDirection.up : GameDirection.down;
    setState(() {
      if (widget.kind == GameKind.merge) _merge.move(dir);
      if (widget.kind == GameKind.snake) _snake.turn(dir);
    });
  }

  void _tapBoard(Offset point, Size size) {
    if (widget.kind != GameKind.solitaire) {
      onSelectPressed();
      return;
    }
    final geometry = SolitaireGeometry(size);
    final hit = geometry.hit(point, _solitaire);
    if (hit == null) return;
    setState(() {
      _solitaire.cursor = hit.$1;
      _solitaire.choose(stackIndex: hit.$2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final ink = context.appPrimaryTextColor;
    final label = switch (widget.kind) {
      GameKind.brick =>
        _brick.over
            ? (_brick.won
                  ? 'You won! · Center to restart'
                  : 'Game over · Center to restart')
            : 'Score ${_brick.score}   Lives ${_brick.lives}${_paused ? '   Paused' : ''}',
      GameKind.snake =>
        _snake.over
            ? (_snake.won
                  ? 'You won! · Center to restart'
                  : 'Game over · Center to restart')
            : 'Score ${_snake.score}${_paused ? '   Paused' : ''}',
      GameKind.merge =>
        _merge.over
            ? 'Game over · Center to restart'
            : '${_merge.cells.any((tile) => tile >= 2048) ? '2048!   ' : ''}Score ${_merge.score}   ${_direction.name.toUpperCase()}',
      GameKind.solitaire =>
        'Foundations ${_solitaire.score}/52 · ${_solitaire.message}',
    };
    final hint = switch (widget.kind) {
      GameKind.brick => 'Wheel / drag: paddle   •   Center: play / pause',
      GameKind.snake =>
        'Wheel: turn   •   Swipe: direction   •   Center: play / pause',
      GameKind.merge => 'Wheel: direction   •   Center: move   •   Swipe: move',
      GameKind.solitaire =>
        'Wheel: pile • Center: select • Prev/Next: stack • Hold: new game',
    };
    return CupertinoPageScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
        child: Column(
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: IpodTypography.forContext(
                context,
                IpodTypography.caption,
              ).copyWith(color: ink),
            ),
            const SizedBox(height: 3),
            Expanded(
              child: LayoutBuilder(
                builder: (context, box) {
                  final size = Size(box.maxWidth, box.maxHeight);
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: (details) =>
                        _tapBoard(details.localPosition, size),
                    onHorizontalDragUpdate: widget.kind == GameKind.brick
                        ? (details) => setState(
                            () => _brick.paddle =
                                (details.localPosition.dx / size.width).clamp(
                                  .1,
                                  .9,
                                ),
                          )
                        : null,
                    onHorizontalDragEnd:
                        widget.kind == GameKind.merge ||
                            widget.kind == GameKind.snake
                        ? _swipe
                        : null,
                    onVerticalDragEnd:
                        widget.kind == GameKind.merge ||
                            widget.kind == GameKind.snake
                        ? _verticalSwipe
                        : null,
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: GamePainter(
                        kind: widget.kind,
                        brick: _brick,
                        snake: _snake,
                        merge: _merge,
                        solitaire: _solitaire,
                        ink: ink,
                        dark: isDark,
                        retro: context.isFirstGenerationTheme,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 3),
            Text(
              hint,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(fontSize: 10, color: ink),
            ),
          ],
        ),
      ),
    );
  }
}

class SolitaireGeometry {
  SolitaireGeometry(this.size);
  final Size size;
  double get cardWidth => math.min(size.width / 8.3, 42);
  double get cardHeight => math.min(cardWidth * 1.35, size.height * .29);
  double get tableTop => cardHeight + 8;
  double get colWidth => size.width / 7;
  double cardX(int pile) => pile == 0
      ? 0
      : pile == 1
      ? colWidth
      : (pile - 2 + 3) * colWidth;
  double gap(int count) => count <= 1
      ? 0
      : math.min(
          16,
          math.max(1, (size.height - tableTop - cardHeight) / (count - 1)),
        );
  (int, int?)? hit(Offset point, SolitaireGame game) {
    if (point.dy < cardHeight + 4) {
      final col = (point.dx / colWidth).floor();
      if (col == 0) return (0, null);
      if (col == 1) return (1, null);
      if (col >= 3 && col <= 6) return (col - 1, null);
      return null;
    }
    final col = (point.dx / colWidth).floor();
    if (col < 0 || col > 6) return null;
    final cards = game.tableau[col];
    if (cards.isEmpty) return (col + 6, null);
    final cardGap = gap(cards.length);
    final index = cardGap == 0
        ? 0
        : ((point.dy - tableTop) / cardGap).floor().clamp(0, cards.length - 1);
    return (col + 6, index);
  }
}

class GamePainter extends CustomPainter {
  GamePainter({
    required this.kind,
    required this.brick,
    required this.snake,
    required this.merge,
    required this.solitaire,
    required this.ink,
    required this.dark,
    required this.retro,
  });
  final GameKind kind;
  final BrickGame brick;
  final SnakeGame snake;
  final MergeGame merge;
  final SolitaireGame solitaire;
  final Color ink;
  final bool dark, retro;
  Color get surface => dark ? const Color(0xff252830) : const Color(0xffdbe6ef);
  Color get accent => retro ? const Color(0xff435464) : const Color(0xffc52c3d);
  void label(
    Canvas canvas,
    String text,
    Offset point,
    double size,
    Color color, {
    bool center = false,
  }) {
    final p = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.w700,
          color: color,
          fontFamily: retro ? 'PixelifySans' : 'Helvetica',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    p.paint(canvas, center ? point - Offset(p.width / 2, p.height / 2) : point);
  }

  void rect(Canvas canvas, Rect r, Color color, {double radius = 3}) =>
      canvas.drawRRect(
        RRect.fromRectAndRadius(r, Radius.circular(radius)),
        Paint()..color = color,
      );
  @override
  void paint(Canvas canvas, Size size) {
    rect(canvas, Offset.zero & size, surface, radius: 4);
    switch (kind) {
      case GameKind.brick:
        for (var i = 0; i < brick.bricks.length; i++) {
          if (!brick.bricks[i]) continue;
          final col = i % 8, row = i ~/ 8;
          rect(
            canvas,
            Rect.fromLTWH(
              size.width * (.04 + col * .115),
              size.height * (.08 + row * .065),
              size.width * .105,
              size.height * .047,
            ),
            row.isEven ? accent : ink.withValues(alpha: .65),
            radius: 2,
          );
        }
        rect(
          canvas,
          Rect.fromCenter(
            center: Offset(size.width * brick.paddle, size.height * .92),
            width: size.width * .2,
            height: 6,
          ),
          ink,
        );
        canvas.drawCircle(
          Offset(size.width * brick.x, size.height * brick.y),
          4,
          Paint()..color = accent,
        );
      case GameKind.snake:
        final cell = math.min(
          size.width / SnakeGame.width,
          size.height / SnakeGame.height,
        );
        final origin = Offset(
          (size.width - cell * SnakeGame.width) / 2,
          (size.height - cell * SnakeGame.height) / 2,
        );
        for (final part in snake.body) {
          rect(
            canvas,
            Rect.fromLTWH(
              origin.dx + part % SnakeGame.width * cell + 1,
              origin.dy + part ~/ SnakeGame.width * cell + 1,
              cell - 2,
              cell - 2,
            ),
            ink,
            radius: 2,
          );
        }
        canvas.drawCircle(
          Offset(
            origin.dx + (snake.food % SnakeGame.width + .5) * cell,
            origin.dy + (snake.food ~/ SnakeGame.width + .5) * cell,
          ),
          cell * .32,
          Paint()..color = accent,
        );
      case GameKind.merge:
        final unit = math.min(size.width / 4, size.height / 4);
        final ox = (size.width - unit * 4) / 2,
            oy = (size.height - unit * 4) / 2;
        for (var i = 0; i < 16; i++) {
          final r = Rect.fromLTWH(
            ox + (i % 4) * unit + 2,
            oy + (i ~/ 4) * unit + 2,
            unit - 4,
            unit - 4,
          );
          final value = merge.cells[i];
          rect(
            canvas,
            r,
            value == 0
                ? ink.withValues(alpha: .12)
                : (value >= 32 ? accent : ink.withValues(alpha: .72)),
          );
          if (value > 0) {
            label(
              canvas,
              '$value',
              r.center,
              math.min(unit * .38, 22),
              const Color(0xffffffff),
              center: true,
            );
          }
        }
      case GameKind.solitaire:
        _paintSolitaire(canvas, size);
    }
  }

  void _paintSolitaire(Canvas canvas, Size size) {
    final g = SolitaireGeometry(size);
    void pile(
      int index,
      SolitaireCard? card,
      Offset offset, {
      bool back = false,
      bool selected = false,
    }) {
      final area = Rect.fromLTWH(
        offset.dx,
        offset.dy,
        g.cardWidth,
        g.cardHeight,
      );
      rect(
        canvas,
        area,
        card == null
            ? ink.withValues(alpha: .12)
            : back
            ? accent
            : const Color(0xfff8f8f6),
        radius: 2,
      );
      if (selected) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(area.deflate(.6), const Radius.circular(2)),
          Paint()
            ..color = const Color(0xffffca4a)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
      if (card != null && !back) {
        final rank = switch (card.rank) {
          1 => 'A',
          11 => 'J',
          12 => 'Q',
          13 => 'K',
          _ => '${card.rank}',
        };
        final suit = ['♠', '♥', '♦', '♣'][card.suit];
        label(
          canvas,
          '$rank$suit',
          offset + const Offset(2, 1),
          math.max(9, g.cardWidth * .32),
          card.red ? const Color(0xffb32132) : const Color(0xff202632),
        );
      }
      if (card == null) {
        label(
          canvas,
          index == 0
              ? '↻'
              : index >= 2 && index <= 5
              ? ['♠', '♥', '♦', '♣'][index - 2]
              : '',
          area.center,
          14,
          (index == 3 || index == 4)
              ? const Color(0xffd45a68)
              : ink.withValues(alpha: .6),
          center: true,
        );
      }
    }

    for (var i = 0; i < 6; i++) {
      final cards = i == 0
          ? solitaire.stock
          : i == 1
          ? solitaire.waste
          : solitaire.foundations[i - 2];
      pile(
        i,
        cards.isEmpty ? null : cards.last,
        Offset(g.cardX(i), 1),
        back: i == 0 && cards.isNotEmpty,
        selected: solitaire.cursor == i || solitaire.source == i,
      );
    }
    for (var col = 0; col < 7; col++) {
      final cards = solitaire.tableau[col];
      final x = col * g.colWidth;
      if (cards.isEmpty) {
        pile(
          col + 6,
          null,
          Offset(x, g.tableTop),
          selected: solitaire.cursor == col + 6,
        );
        continue;
      }
      final step = g.gap(cards.length);
      for (var i = 0; i < cards.length; i++) {
        final selected =
            (solitaire.source == col + 6 && solitaire.sourceIndex == i) ||
            (solitaire.cursor == col + 6 &&
                i ==
                    cards.length -
                        (solitaire.source == null ? solitaire.depth : 1));
        pile(
          col + 6,
          cards[i],
          Offset(x, g.tableTop + i * step),
          back: !cards[i].faceUp,
          selected: selected,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) => true;
}
