import 'dart:math' as math;

import 'package:classipod/features/games/game_logic.dart';
import 'package:classipod/features/games/solitaire_logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('2048 merges pairs once and scores correctly', () {
    final game = MergeGame(random: math.Random(1));
    game.cells.fillRange(0, 16, 0);
    game.cells.setRange(0, 4, [2, 2, 2, 2]);
    expect(game.move(GameDirection.left), isTrue);
    expect(game.cells[0], 4);
    expect(game.cells[1], 4);
    expect(game.score, 8);
    expect(game.cells.where((value) => value > 0).length, 3);
  });
  test('2048 does not spawn a tile when no move changes the board', () {
    final game = MergeGame(random: math.Random(1));
    game.cells.fillRange(0, 16, 0);
    game.cells[0] = 2;
    expect(game.move(GameDirection.left), isFalse);
    expect(game.cells.where((value) => value > 0).length, 1);
  });
  test('snake grows on food, avoids reversal and ends at the wall', () {
    final game = SnakeGame(random: math.Random(1));
    game.food = game.body.first + 1;
    game.turn(GameDirection.left);
    expect(game.direction, GameDirection.right);
    game.tick();
    expect(game.score, 1);
    expect(game.body.length, 4);
    game.body
      ..clear()
      ..add(13);
    game.tick();
    expect(game.over, isTrue);
  });
  test('brick hits increase score and a missed ball loses one life', () {
    final game = BrickGame()
      ..x = .05
      ..y = .1
      ..dx = 0
      ..dy = 0;
    game.tick(0);
    expect(game.score, 10);
    game.y = 1.01;
    game.tick(0);
    expect(game.lives, 2);
    expect(game.over, isFalse);
  });
  test('solitaire deals 28 tableau cards and recycles draw-one stock', () {
    final game = SolitaireGame(random: math.Random(1));
    expect(game.stock.length, 24);
    expect(game.tableau.fold<int>(0, (sum, pile) => sum + pile.length), 28);
    expect(game.tableau.every((pile) => pile.last.faceUp), isTrue);
    game.choose();
    expect(game.stock.length, 23);
    expect(game.waste.length, 1);
    for (var i = 0; i < 23; i++) {
      game.choose();
    }
    game.choose();
    expect(game.stock.length, 24);
    expect(game.waste, isEmpty);
    expect(game.stock.every((card) => !card.faceUp), isTrue);
  });
  test('solitaire moves a face-up stack and rejects invalid moves', () {
    final game = SolitaireGame(random: math.Random(1));
    for (final pile in game.tableau) {
      pile.clear();
    }
    game.tableau[0].addAll([
      SolitaireCard(6, faceUp: true), // black 7
      SolitaireCard(18, faceUp: true), // red 6
    ]);
    game.tableau[1].add(SolitaireCard(20, faceUp: true)); // red 8
    game.cursor = 6;
    game.choose(stackIndex: 0);
    game.cursor = 7;
    game.choose();
    expect(game.tableau[0], isEmpty);
    expect(game.tableau[1].map((c) => c.rank), [8, 7, 6]);
    game.cursor = 7;
    game.choose();
    game.cursor = 8;
    game.choose();
    expect(game.tableau[1].length, 3);
    expect(game.tableau[2], isEmpty);
    expect(game.message, 'Cannot move there');
  });
  test('solitaire moves matching ace to its foundation', () {
    final game = SolitaireGame(random: math.Random(1));
    game.waste.add(SolitaireCard(0, faceUp: true));
    game.cursor = 1;
    game.choose();
    game.cursor = 2;
    game.choose();
    expect(game.foundations[0].single.rank, 1);
    expect(game.waste, isEmpty);
  });
}
