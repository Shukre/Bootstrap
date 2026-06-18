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

  StudySet({required this.title, required this.cards});
}
