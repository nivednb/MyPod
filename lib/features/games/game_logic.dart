import 'dart:math' as math;

enum GameKind { brick, snake, merge, solitaire }

enum GameDirection { up, right, down, left }

class MergeGame {
  MergeGame({math.Random? random}) : _random = random ?? math.Random() {
    _addTile();
    _addTile();
  }
  final math.Random _random;
  final List<int> cells = List.filled(16, 0);
  int score = 0;
  bool get over {
    if (cells.contains(0)) return false;
    for (var y = 0; y < 4; y++) {
      for (var x = 0; x < 4; x++) {
        final i = y * 4 + x;
        if (x < 3 && cells[i] == cells[i + 1]) return false;
        if (y < 3 && cells[i] == cells[i + 4]) return false;
      }
    }
    return true;
  }

  void _addTile() {
    final empty = [
      for (var i = 0; i < 16; i++)
        if (cells[i] == 0) i,
    ];
    if (empty.isNotEmpty) {
      cells[empty[_random.nextInt(empty.length)]] = _random.nextInt(10) == 0
          ? 4
          : 2;
    }
  }

  bool move(GameDirection direction) {
    var changed = false;
    for (var line = 0; line < 4; line++) {
      final indices = List.generate(
        4,
        (i) => switch (direction) {
          GameDirection.left => line * 4 + i,
          GameDirection.right => line * 4 + 3 - i,
          GameDirection.up => i * 4 + line,
          GameDirection.down => (3 - i) * 4 + line,
        },
      );
      final original = indices.map((i) => cells[i]).toList();
      final values = original.where((v) => v != 0).toList();
      final merged = <int>[];
      for (var i = 0; i < values.length; i++) {
        if (i + 1 < values.length && values[i] == values[i + 1]) {
          final value = values[i] * 2;
          score += value;
          merged.add(value);
          i++;
        } else {
          merged.add(values[i]);
        }
      }
      while (merged.length < 4) {
        merged.add(0);
      }
      for (var i = 0; i < 4; i++) {
        if (original[i] != merged[i]) changed = true;
        cells[indices[i]] = merged[i];
      }
    }
    if (changed) _addTile();
    return changed;
  }
}

class SnakeGame {
  SnakeGame({math.Random? random}) : _random = random ?? math.Random() {
    _placeFood();
  }
  static const width = 14, height = 10;
  final math.Random _random;
  final List<int> body = [5 * width + 6, 5 * width + 5, 5 * width + 4];
  GameDirection direction = GameDirection.right;
  GameDirection _lastDirection = GameDirection.right;
  int food = 0;
  int score = 0;
  bool over = false;
  bool won = false;
  void turn(GameDirection next) {
    if ((_lastDirection.index - next.index).abs() == 2) return;
    direction = next;
  }

  void turnRelative(int delta) =>
      turn(GameDirection.values[(direction.index + delta + 4) % 4]);
  void _placeFood() {
    final free = [
      for (var i = 0; i < width * height; i++)
        if (!body.contains(i)) i,
    ];
    if (free.isEmpty) {
      won = true;
      over = true;
      return;
    }
    food = free[_random.nextInt(free.length)];
  }

  void tick() {
    if (over) return;
    _lastDirection = direction;
    final head = body.first;
    var x = head % width, y = head ~/ width;
    switch (direction) {
      case GameDirection.up:
        y--;
      case GameDirection.right:
        x++;
      case GameDirection.down:
        y++;
      case GameDirection.left:
        x--;
    }
    if (x < 0 || x >= width || y < 0 || y >= height) {
      over = true;
      return;
    }
    final next = y * width + x;
    final growing = next == food;
    if (body.take(growing ? body.length : body.length - 1).contains(next)) {
      over = true;
      return;
    }
    body.insert(0, next);
    if (growing) {
      score++;
      _placeFood();
    } else {
      body.removeLast();
    }
  }
}

class BrickGame {
  final List<bool> bricks = List.filled(32, true);
  double paddle = .5, x = .5, y = .72, dx = .38, dy = -.48;
  int lives = 3, score = 0;
  bool get won => !bricks.contains(true);
  bool get over => lives <= 0 || won;
  void move(double delta) => paddle = (paddle + delta).clamp(.1, .9);
  void tick(double dt) {
    if (over) return;
    x += dx * dt;
    y += dy * dt;
    if (x < .02) {
      x = .02;
      dx = dx.abs();
    }
    if (x > .98) {
      x = .98;
      dx = -dx.abs();
    }
    if (y < .03) {
      y = .03;
      dy = dy.abs();
    }
    if (dy > 0 && y >= .9 && y < .96 && (x - paddle).abs() <= .12) {
      y = .9;
      dy = -dy.abs();
      dx = ((x - paddle) * 3).clamp(-.6, .6);
      if (dx.abs() < .08) dx = .12;
    }
    if (y > 1) {
      lives--;
      x = paddle;
      y = .72;
      dx = .38;
      dy = -.48;
      return;
    }
    if (y >= .08 && y < .34 && x >= .04 && x < .96) {
      final col = ((x - .04) / .115).floor().clamp(0, 7);
      final row = ((y - .08) / .065).floor().clamp(0, 3);
      final index = row * 8 + col;
      if (bricks[index]) {
        bricks[index] = false;
        score += 10;
        dy = -dy;
      }
    }
  }
}
