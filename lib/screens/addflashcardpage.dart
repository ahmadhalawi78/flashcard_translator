import 'package:flutter/material.dart';
import '../models/flashcard.dart';

class AddFlashcardPage extends StatefulWidget {
  final List<String> categories;
  final Function(Flashcard flashcard, String category) onSave;

  const AddFlashcardPage({
    required this.categories,
    required this.onSave,
  });

  @override
  _AddFlashcardPageState createState() => _AddFlashcardPageState();
}

class _AddFlashcardPageState extends State<AddFlashcardPage> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  String? selectedCategory;
  String selectedDifficulty = 'Easy';

  bool wordError = false;
  bool meaningError = false;
  bool categoryError = false;

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
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  'Add Flashcard',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                centerTitle: true,
              ),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Word Field
                      Text(
                        'Word',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _wordController,
                          decoration: InputDecoration(
                            hintText: 'Enter Word',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                            errorText: wordError ? 'Word is required' : null,
                          ),
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Meaning Field
                      Text(
                        'Meaning',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _meaningController,
                          decoration: InputDecoration(
                            hintText: 'Enter Meaning',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                            errorText: meaningError ? 'Meaning is required' : null,
                          ),
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Category Dropdown
                      Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButton<String>(
                          value: selectedCategory,
                          isExpanded: true,
                          hint: Text('Select Category'),
                          underline: SizedBox(),
                          icon: Icon(Icons.arrow_drop_down, color: Colors.black54),
                          items: widget.categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(
                                category,
                                style: TextStyle(color: Colors.black87),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                              categoryError = false;
                            });
                          },
                        ),
                      ),
                      if (categoryError)
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            'Category is required',
                            style: TextStyle(
                              color: Colors.red[200],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      SizedBox(height: 20),

                      // Difficulty Dropdown
                      Text(
                        'Difficulty',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButton<String>(
                          value: selectedDifficulty,
                          isExpanded: true,
                          underline: SizedBox(),
                          icon: Icon(Icons.arrow_drop_down, color: Colors.black54),
                          items: ['Easy', 'Medium', 'Hard'].map((difficulty) {
                            return DropdownMenuItem(
                              value: difficulty,
                              child: Text(
                                difficulty,
                                style: TextStyle(color: Colors.black87),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedDifficulty = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 40),

                      // Save Button
                      Center(
                        child: ElevatedButton(
                          onPressed: _saveFlashcard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            'Save Flashcard',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
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

  void _saveFlashcard() {
    setState(() {
      wordError = _wordController.text.trim().isEmpty;
      meaningError = _meaningController.text.trim().isEmpty;
      categoryError = selectedCategory == null;
    });

    if (wordError || meaningError || categoryError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    final flashcard = Flashcard(
      word: _wordController.text.trim(),
      meaning: _meaningController.text.trim(),
      difficulty: selectedDifficulty,
    );

    widget.onSave(flashcard, selectedCategory!);
    Navigator.pop(context);
  }
}