class Flashcard {
  String term;
  String definition;
  bool isFavorite;

  Flashcard({
    required this.term,
    required this.definition,
    this.isFavorite = false,
  });
}

class StudySet {
  String title;
  List<Flashcard> cards;
  int lastCardIndex;
  List<int> cardStatuses;

  StudySet({
    required this.title,
    required this.cards,
    this.lastCardIndex = 0,
    List<int>? cardStatuses,
  }) : cardStatuses = cardStatuses ?? List<int>.filled(cards.length, 0);
}
