import 'package:flutter/material.dart';
import 'FlasgcardDetailPage.dart';
import '../models/flashcard.dart';

class FlashcardListPage extends StatefulWidget {
  final List<Flashcard> flashcards;
  final String categoryName;

  const FlashcardListPage({
    required this.flashcards,
    required this.categoryName,
  });

  @override
  _FlashcardListPageState createState() => _FlashcardListPageState();
}

class _FlashcardListPageState extends State<FlashcardListPage> {
  late List<Flashcard> flashcardsList;

  @override
  void initState() {
    super.initState();
    flashcardsList = List<Flashcard>.from(widget.flashcards);
    flashcardsList.shuffle();
  }

  double _calculateProgress() {
    if (flashcardsList.isEmpty) return 0;
    int learned = flashcardsList.where((f) => f.isLearned).length;
    return learned / flashcardsList.length;
  }

  @override
  Widget build(BuildContext context) {
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
                title: Text(
                  '${widget.categoryName} Flashcards',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.white),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _calculateProgress(),
                      backgroundColor: Colors.white.withOpacity(0.3),
                      color: Colors.orange,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              Expanded(
                child: flashcardsList.isEmpty
                    ? Center(
                  child: Text(
                    'No flashcards yet.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: flashcardsList.length,
                  itemBuilder: (context, index) {
                    final flashcard = flashcardsList[index];
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FlashcardDetailPage(
                              flashcard: flashcard,
                              categoryName: widget.categoryName,
                              onDelete: () {
                                setState(() {
                                  flashcardsList.removeAt(index);
                                });
                              },
                              onEdit: (updatedCard) {
                                setState(() {
                                  flashcardsList[index] = updatedCard;
                                });
                              },
                              onMarkHarder: () {
                                setState(() {
                                  flashcardsList[index].difficulty = 'Hard';
                                  flashcardsList[index].save(); // save to Hive
                                });
                              },
                              onMarkLearned: () {
                                setState(() {
                                  flashcardsList[index].isLearned = !flashcardsList[index].isLearned;
                                  flashcardsList[index].save(); // save to Hive
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            flashcard.word,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}