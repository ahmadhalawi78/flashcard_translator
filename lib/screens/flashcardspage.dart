import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'addflashcardpage.dart';
import 'flashcardlistpage.dart';
import '../models/flashcard.dart';

class FlashcardsPage extends StatefulWidget {
  @override
  _FlashcardsPageState createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  late Box<List<Flashcard>> categoryBox;

  @override
  void initState() {
    super.initState();
    categoryBox = Hive.box<List<Flashcard>>('categories');
  }

  @override
  Widget build(BuildContext context) {
    final categories = categoryBox.keys.cast<String>().toList();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5C89EB),  // Blue
              Color(0xFFFECA9A),  // Peach
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  'Flashcards',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.white),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Expanded(
                        child: categoryBox.isEmpty
                            ? Center(
                          child: Text(
                            'No categories yet.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        )
                            : ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final categoryName = categories[index];
                            final flashcards =
                                categoryBox.get(categoryName)?.cast<Flashcard>() ?? [];

                            return CategoryCard(
                              title: categoryName,
                              count: flashcards.length,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FlashcardListPage(
                                      flashcards: flashcards,
                                      categoryName: categoryName,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Buttons
                      FlashcardButton(
                        text: '+ Add Flashcard',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddFlashcardPage(
                                categories: categories,
                                onSave: (flashcard, selectedCategory) {
                                  final currentList = categoryBox
                                      .get(selectedCategory)
                                      ?.cast<Flashcard>() ?? [];
                                  currentList.add(flashcard);
                                  categoryBox.put(selectedCategory, currentList);
                                  setState(() {});
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      FlashcardButton(
                        text: '+ Create Category',
                        onPressed: () {
                          _showCreateCategoryDialog(context);
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateCategoryDialog(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF5C89EB).withOpacity(0.9),
                Color(0xFFFECA9A).withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Create New Category',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Category Name',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      final name = _controller.text.trim();
                      if (name.isNotEmpty && !categoryBox.containsKey(name)) {
                        categoryBox.put(name, <Flashcard>[]);
                        setState(() {});
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    child: Text(
                      'Create',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CategoryCard extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback onTap;

  const CategoryCard({
    required this.title,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '$count flashcards',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            Icon(Icons.chevron_right, size: 30, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}


class FlashcardButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const FlashcardButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        shadowColor: Colors.deepOrange.withOpacity(0.4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}