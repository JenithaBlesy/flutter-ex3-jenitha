import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 📚 Model class for a comic item
class ComicItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const ComicItem(this.title, this.description, this.icon, this.color);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comics Reader App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const ComicsScreen(),
    );
  }
}

class ComicsScreen extends StatefulWidget {
  const ComicsScreen({super.key});

  @override
  State<ComicsScreen> createState() => _ComicsScreenState();
}

class _ComicsScreenState extends State<ComicsScreen> {
  final List<ComicItem> _allComics = [
    const ComicItem("Superhero Saga", "An epic adventure with heroes saving the world.", Icons.flash_on, Colors.blue),
    const ComicItem("Mystery Tales", "Whodunits and secrets unravel in dark corners.", Icons.book, Colors.green),
    const ComicItem("Fantasy World", "Dragons, elves, and magic in enchanted lands.", Icons.auto_stories, Colors.orange),
    const ComicItem("Sci-Fi Adventures", "Space exploration and alien encounters.", Icons.science, Colors.redAccent),
    const ComicItem("Classic Comics", "Timeless stories loved by generations.", Icons.menu_book, Colors.teal),
    const ComicItem("Funny Fables", "Humorous tales that tickle your imagination.", Icons.sentiment_satisfied, Colors.pink),
  ];

  List<ComicItem> _filteredComics = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredComics = List.from(_allComics);

    // Add listener for search field
    _searchController.addListener(() {
      _filterComics(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addComic() {
    final newComic = ComicItem(
      "New Comic ${_allComics.length + 1}",
      "This is a new exciting comic added just now!",
      Icons.bookmark,
      Colors.purple,
    );
    setState(() {
      _allComics.add(newComic);
      _filteredComics.add(newComic);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("New comic added!")),
    );
  }

  void _filterComics(String query) {
    final search = query.toLowerCase();
    setState(() {
      if (search.isEmpty) {
        _filteredComics = List.from(_allComics);
      } else {
        _filteredComics = _allComics
            .where((comic) => comic.title.toLowerCase().contains(search))
            .toList();
      }
    });
  }

  void _readComic(ComicItem comic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComicDetailScreen(comic: comic),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comics Reader"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "📚 Explore Comics!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search Comics",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredComics.isEmpty
                  ? const Center(child: Text("No comics found"))
                  : ListView.builder(
                      itemCount: _filteredComics.length,
                      itemBuilder: (context, index) {
                        final comic = _filteredComics[index];
                        return comicCard(comic);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addComic,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget comicCard(ComicItem comic) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: comic.color,
          child: Icon(comic.icon, color: Colors.white),
        ),
        title: Text(comic.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(comic.description),
        trailing: ElevatedButton(
          onPressed: () => _readComic(comic),
          style: ElevatedButton.styleFrom(
            backgroundColor: comic.color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Read"),
        ),
      ),
    );
  }
}

// 📖 Comic Detail Screen
class ComicDetailScreen extends StatelessWidget {
  final ComicItem comic;

  const ComicDetailScreen({super.key, required this.comic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(comic.title),
        backgroundColor: comic.color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: comic.color,
              child: Icon(comic.icon, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              comic.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              comic.description,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}