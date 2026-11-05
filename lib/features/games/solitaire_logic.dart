import 'dart:math' as math;

class SolitaireCard {
  SolitaireCard(this.id, {this.faceUp = false});
  final int id;
  bool faceUp;
  int get suit => id ~/ 13;
  int get rank => id % 13 + 1;
  bool get red => suit == 1 || suit == 2;
}

/// Draw-one Klondike. Piles: stock 0, waste 1, foundations 2–5, tableau 6–12.
class SolitaireGame {
  SolitaireGame({math.Random? random}) {
    final deck = List.generate(52, SolitaireCard.new)
      ..shuffle(random ?? math.Random());
    for (var col = 0; col < 7; col++) {
      for (var row = 0; row <= col; row++) {
        tableau[col].add(deck.removeLast()..faceUp = row == col);
      }
    }
    stock.addAll(deck);
  }
  final stock = <SolitaireCard>[];
  final waste = <SolitaireCard>[];
  final foundations = List.generate(4, (_) => <SolitaireCard>[]);
  final tableau = List.generate(7, (_) => <SolitaireCard>[]);
  int cursor = 0;
  int depth = 1;
  int? source;
  int sourceIndex = 0;
  String message = 'Draw or choose a pile';
  bool get won => foundations.every((pile) => pile.length == 13);
  int get score => foundations.fold(0, (sum, pile) => sum + pile.length);
  int faceUpCount(int col) => tableau[col].where((card) => card.faceUp).length;
  void moveCursor(int delta) {
    cursor = (cursor + delta + 13) % 13;
    depth = 1;
  }

  void adjustDepth(int delta) {
    if (source != null || cursor < 6) return;
    final count = faceUpCount(cursor - 6);
    if (count > 0) depth = (depth + delta).clamp(1, count);
  }

  List<SolitaireCard> _pile(int position) {
    if (position == 0) return stock;
    if (position == 1) return waste;
    if (position < 6) return foundations[position - 2];
    return tableau[position - 6];
  }

  void choose({int? stackIndex}) {
    if (won) return;
    if (source == null && cursor == 0) {
      if (stock.isNotEmpty) {
        waste.add(stock.removeLast()..faceUp = true);
        message = 'Card drawn';
      } else if (waste.isNotEmpty) {
        stock.addAll(waste.reversed.map((card) => card..faceUp = false));
        waste.clear();
        message = 'Stock reset';
      } else {
        message = 'Stock is empty';
      }
      return;
    }
    if (source == null) {
      final pile = _pile(cursor);
      if (pile.isEmpty || !pile.last.faceUp) {
        message = 'Choose a face-up card';
        return;
      }
      final chosen = cursor >= 6
          ? (stackIndex ?? pile.length - depth)
          : pile.length - 1;
      if (chosen < 0 || chosen >= pile.length || !pile[chosen].faceUp) {
        message = 'Choose a face-up card';
        return;
      }
      source = cursor;
      sourceIndex = chosen;
      message = 'Choose destination';
      return;
    }
    if (source == cursor) {
      source = null;
      message = 'Selection cancelled';
      return;
    }
    final from = _pile(source!);
    final moving = from.sublist(sourceIndex);
    if (cursor < 2 || moving.isEmpty) {
      message = 'Choose a destination';
      return;
    }
    final first = moving.first;
    final dest = _pile(cursor);
    final valid = cursor < 6
        ? moving.length == 1 &&
              first.suit == cursor - 2 &&
              first.rank == dest.length + 1
        : dest.isEmpty
        ? first.rank == 13
        : dest.last.faceUp &&
              dest.last.red != first.red &&
              dest.last.rank == first.rank + 1;
    if (!valid) {
      message = 'Cannot move there';
      return;
    }
    dest.addAll(moving);
    from.removeRange(sourceIndex, from.length);
    if (source! >= 6 && from.isNotEmpty) from.last.faceUp = true;
    source = null;
    depth = 1;
    message = won ? 'You won!' : 'Card moved';
  }
}
