import 'package:flutter/material.dart';
import 'package:codingminds_bootstrap/models.dart';

class FlashcardPlayerPage extends StatefulWidget {
  final StudySet studySet;

  const FlashcardPlayerPage({super.key, required this.studySet});

  @override
  State<FlashcardPlayerPage> createState() => _FlashcardPlayerPageState();
}

class _FlashcardPlayerPageState extends State<FlashcardPlayerPage> {
  late int _currentIndex;
  bool _isFlipped = false;

  int get _understoodCount =>
      widget.studySet.cardStatuses.where((status) => status == 1).length;
  int get _reviewCount =>
      widget.studySet.cardStatuses.where((status) => status == 2).length;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.studySet.lastCardIndex;
  }

  void _handleSwipe(DismissDirection direction) {
    if (direction == DismissDirection.endToStart) {
      widget.studySet.cardStatuses[_currentIndex] = 2;
    } else if (direction == DismissDirection.startToEnd) {
      widget.studySet.cardStatuses[_currentIndex] = 1;
    }

    setState(() {
      _currentIndex++;
      _isFlipped = false;
      widget.studySet.lastCardIndex = _currentIndex;
    });
  }

  void _goBack() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _isFlipped = false;
        widget.studySet.cardStatuses[_currentIndex] = 0;
        widget.studySet.lastCardIndex = _currentIndex;
      });
    }
  }

  void _toggleFavorite() {
    setState(() {
      final card = widget.studySet.cards[_currentIndex];
      card.isFavorite = !card.isFavorite;
    });
  }

  void _resetStudySession() {
    setState(() {
      _currentIndex = 0;
      _isFlipped = false;
      widget.studySet.lastCardIndex = 0;
      for (int i = 0; i < widget.studySet.cardStatuses.length; i++) {
        widget.studySet.cardStatuses[i] = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalCards = widget.studySet.cards.length;
    final isFinished = _currentIndex >= totalCards;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.studySet.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: isFinished ? _buildCompletionScreen() : _buildFlashcardPlayer(),
    );
  }

  Widget _buildCompletionScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, size: 80, color: Colors.orange),
          const SizedBox(height: 16),
          const Text(
            'You finished this set!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Understood: $_understoodCount',
            style: const TextStyle(color: Colors.green, fontSize: 18),
          ),
          Text(
            'Need Review: $_reviewCount',
            style: const TextStyle(color: Colors.red, fontSize: 18),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _resetStudySession,
            icon: const Icon(Icons.refresh),
            label: const Text('Study Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcardPlayer() {
    final currentCard = widget.studySet.cards[_currentIndex];
    final totalCards = widget.studySet.cards.length;
    final progress = _currentIndex / totalCards;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Card ${_currentIndex + 1} of $totalCards',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        '$_understoodCount ',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$_reviewCount ',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.cancel, color: Colors.red, size: 16),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Center(
              child: Dismissible(
                key: ValueKey<int>(_currentIndex),
                direction: DismissDirection.horizontal,
                onDismissed: _handleSwipe,
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 32.0),
                  child: const Icon(Icons.check, color: Colors.white, size: 48),
                ),
                secondaryBackground: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 32.0),
                  child: const Icon(Icons.close, color: Colors.white, size: 48),
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isFlipped = !_isFlipped;
                    });
                  },
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 400,
                      padding: const EdgeInsets.all(24.0),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(
                                currentCard.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: currentCard.isFavorite
                                    ? Colors.red
                                    : Colors.grey,
                                size: 32,
                              ),
                              onPressed: _toggleFavorite,
                            ),
                          ),
                          Center(
                            child: Text(
                              _isFlipped
                                  ? currentCard.definition
                                  : currentCard.term,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: _isFlipped ? 20 : 28,
                                fontWeight: _isFlipped
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Tap to flip',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 32),
                color: Colors.deepPurple,
                onPressed: _currentIndex > 0 ? _goBack : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
