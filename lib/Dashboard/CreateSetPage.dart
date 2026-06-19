import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:codingminds_bootstrap/models.dart';
import 'package:firebase_database/firebase_database.dart';

class CreateSetPage extends StatefulWidget {
  const CreateSetPage({super.key});

  @override
  State<CreateSetPage> createState() => _CreateSetPageState();
}

class _CreateSetPageState extends State<CreateSetPage> {
  final TextEditingController _titleController = TextEditingController();

  final List<Map<String, TextEditingController>> _cardControllers = [
    {'term': TextEditingController(), 'definition': TextEditingController()},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    for (var controllers in _cardControllers) {
      controllers['term']?.dispose();
      controllers['definition']?.dispose();
    }
    super.dispose();
  }

  void _addCard() {
    setState(() {
      _cardControllers.add({
        'term': TextEditingController(),
        'definition': TextEditingController(),
      });
    });
  }

  void _removeCard(int index) {
    if (_cardControllers.length > 1) {
      setState(() {
        _cardControllers[index]['term']?.dispose();
        _cardControllers[index]['definition']?.dispose();
        _cardControllers.removeAt(index);
      });
    }
  }

  void _saveSet() async {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title for your study set.'),
        ),
      );
      return;
    }

    List<Flashcard> newCards = [];
    for (var controllers in _cardControllers) {
      final term = controllers['term']!.text.trim();
      final def = controllers['definition']!.text.trim();

      if (term.isNotEmpty || def.isNotEmpty) {
        newCards.add(Flashcard(term: term, definition: def));
      }
    }

    if (newCards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one flashcard.')),
      );
      return;
    }

    final newStudySet = StudySet(title: title, cards: newCards);

    DatabaseReference ref = FirebaseDatabase.instance.ref(
      "users/flashcards/$title",
    );

    // for card in newCards:
    await ref.set(convertCardsToJson(newCards));

    // await ref.set({
    //   "name": "John",
    //   "age": 18,
    //   "address": {"line1": "100 Mountain View"},
    // });

    Navigator.pop(context, newStudySet);
  }

  dynamic convertCardsToJson(List<Flashcard>? newCards) {
    /// MODIFY CODE ONLY BELOW THIS LINE

    if (newCards == null) {
      return null;
    }

    Map<String, String> map = new Map<String, String>();
    var temp = {};
    for (var card in newCards) {
      map[card.term] = card.definition;
    }
    temp.addAll(map);
    // print("------------------------------------");
    // print(jsonEncode(map));
    // print("------------------------------------");
    // var temp = {"name": "John", "age": "18", "address": "blah blah blah"};
    // print(temp);
    // print("------------------------------------");
    return temp;

    // List<Map<String, dynamic>> mappedList = newCards.map((obj) {
    //   return {obj.term: obj.definition};
    // }).toList();

    // String jsonList = jsonEncode(mappedList);
    // return jsonList;

    /// MODIFY CODE ONLY ABOVE THIS LINE
    ///
    ///
    /// I/flutter (  931): {"name":"John","age":"18","address":"here"}
    //      I/flutter (  931): ------------------------------------
    //    I/flutter (  931): {name: John, age: 18, address: blah blah blah}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Study Set'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          TextButton(
            onPressed: _saveSet,
            child: const Text(
              'Done',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Study Set Title',
                border: OutlineInputBorder(),
                hintText: 'e.g., Biology Chapter 1',
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _cardControllers.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Card ${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (_cardControllers.length > 1)
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () => _removeCard(index),
                              ),
                          ],
                        ),
                        TextField(
                          controller: _cardControllers[index]['term'],
                          decoration: const InputDecoration(labelText: 'Term'),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _cardControllers[index]['definition'],
                          decoration: const InputDecoration(
                            labelText: 'Definition',
                          ),
                          maxLines: null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCard,
        icon: const Icon(Icons.add),
        label: const Text('Add Card'),
      ),
    );
  }
}
