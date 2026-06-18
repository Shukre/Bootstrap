import 'package:flutter/material.dart';
import 'package:codingminds_bootstrap/models.dart';
import 'package:codingminds_bootstrap/Dashboard/FlashcardPlayerPage.dart';
import 'CreateSetPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<StudySet> _studySets = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _navigateToCreateSet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateSetPage()),
    );

    if (result != null && result is StudySet) {
      setState(() {
        _studySets.add(result);
      });
    }
  }

  Widget _buildHomeView() {
    if (_studySets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.style_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'You have no study sets yet.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _navigateToCreateSet,
              icon: const Icon(Icons.add),
              label: const Text(
                'Create a study set',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _studySets.length,
      itemBuilder: (context, index) {
        final studySet = _studySets[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: const CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.style, color: Colors.white),
            ),
            title: Text(
              studySet.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${studySet.cards.length} terms'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlashcardPlayerPage(studySet: studySet),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeView(),
      const Center(
        child: Text('Favorites Page', style: TextStyle(fontSize: 24)),
      ),
      const Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Flashcards'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0 && _studySets.isNotEmpty
          ? FloatingActionButton(
              onPressed: _navigateToCreateSet,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}
