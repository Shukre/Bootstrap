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
              backgroundColor: Colors.teal,
              child: Icon(Icons.style, color: Colors.white),
            ),
            title: Text(
              studySet.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${studySet.cards.length} terms'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _studySets.removeAt(index);
                    });
                  },
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlashcardPlayerPage(studySet: studySet),
                ),
              ).then((_) {
                setState(() {});
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildProfileView() {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
    );
    return Center(
      child: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 80,
            child: Text('SA'),
          ),
          SizedBox(height: 10),
          ProfileButton("My Account", Icons.account_box),
          ProfileButton("Notifications", Icons.edit_notifications),
          ProfileButton("Settings", Icons.settings),
          ProfileButton("Help Center", Icons.shield),
          ProfileButton("Log Out", Icons.logout),
          Spacer(),
        ],
      ),
    );
  }

  Widget _buildFavoritesView() {
    final favoriteSets = _studySets.where((set) {
      return set.cards.any((card) => card.isFavorite);
    }).toList();

    if (favoriteSets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No favorites yet.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tap the heart icon on a flashcard to save it here.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: favoriteSets.length,
      itemBuilder: (context, index) {
        final originalSet = favoriteSets[index];

        final favoriteCards = originalSet.cards
            .where((c) => c.isFavorite)
            .toList();

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: const CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.favorite, color: Colors.white),
            ),
            title: Text(
              originalSet.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${favoriteCards.length} favorite terms'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              final tempFavoriteSet = StudySet(
                title: '${originalSet.title} (Favorites)',
                cards: favoriteCards,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FlashcardPlayerPage(studySet: tempFavoriteSet),
                ),
              ).then((_) {
                setState(() {});
              });
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
      _buildFavoritesView(),
      _buildProfileView(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize:
              MainAxisSize.min, // Keeps the row centered in the AppBar
          children: [
            const Text(
              'Boot',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(width: 4), // Tiny gap
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white, // Inverts the color for the badge
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'strap',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal, // Text matches your app bar
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
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
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton(this.text, this.icon);
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFFF7643),
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: () {},
        child: Row(
          children: [
            Icon(icon, color: Colors.teal, size: 34.0),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Color(0xFF757575)),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF757575)),
          ],
        ),
      ),
    );
  }
}
