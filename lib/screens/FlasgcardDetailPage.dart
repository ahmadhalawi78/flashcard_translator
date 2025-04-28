import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class FlashcardDetailPage extends StatefulWidget {
  final Map<String, String> flashcard;
  final String categoryName;
  final VoidCallback onDelete;
  final Function(Map<String, String>) onEdit;
  final VoidCallback onMarkHarder;
  final VoidCallback onMarkLearned;

  const FlashcardDetailPage({
    required this.flashcard,
    required this.categoryName,
    required this.onDelete,
    required this.onEdit,
    required this.onMarkHarder,
    required this.onMarkLearned,
  });

  @override
  _FlashcardDetailPageState createState() => _FlashcardDetailPageState();
}

class _FlashcardDetailPageState extends State<FlashcardDetailPage> {
  final TextEditingController _guessController = TextEditingController();
  bool? _isCorrect;

  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

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
                iconTheme: IconThemeData(color: Colors.white),
                title: Text(
                  'Flashcard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),
              Expanded(
                child: Center(
                  child: FlipCard(
                    key: cardKey,
                    flipOnTouch: true,
                    speed: 600,
                    front: _buildFrontCard(),
                    back: _buildBackCard(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('FRONT', style: TextStyle(color: Colors.black54, fontSize: 16)),
          SizedBox(height: 20),
          Text(
            widget.flashcard['word'] ?? '',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          TextField(
            controller: _guessController,
            decoration: InputDecoration(
              hintText: 'Type your answer...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _isCorrect == null
                      ? Colors.orange
                      : (_isCorrect! ? Colors.green : Colors.red),
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.all(16),
            ),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: _checkAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              minimumSize: Size(150, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 3,
            ),
            child: Text(
              'Check Answer',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 10),
          if (_isCorrect != null)
            Text(
              _isCorrect! ? 'Correct!' : 'Wrong!',
              style: TextStyle(
                color: _isCorrect! ? Colors.green : Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          SizedBox(height: 20),
          Text(
            '(Tap to reveal answer after checking)',
            style: TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('BACK', style: TextStyle(color: Colors.black54, fontSize: 16)),
          SizedBox(height: 20),
          Text(
            widget.flashcard['meaning'] ?? '',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Category: ${widget.categoryName}',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Text(
            'Difficulty: ${widget.flashcard['difficulty']}',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          SizedBox(height: 30),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: widget.onMarkHarder,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: Size(200, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 3,
          ),
          child: Text(
            'Mark as Harder',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: widget.onMarkLearned,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: Size(200, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 3,
          ),
          child: Text(
            widget.flashcard['isLearned'] == 'true'
                ? 'Unmark as Learned'
                : 'Mark as Learned',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showEditDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(90, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 3,
              ),
              child: Text('Edit', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: widget.onDelete,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                minimumSize: Size(90, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 3,
              ),
              child: Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }

  void _checkAnswer() {
    final userAnswer = _guessController.text.trim().toLowerCase();
    final correctAnswer = (widget.flashcard['meaning'] ?? '').trim().toLowerCase();

    setState(() {
      _isCorrect = userAnswer == correctAnswer;
    });
  }

  void _showEditDialog() {
    final wordController = TextEditingController(text: widget.flashcard['word']);
    final meaningController = TextEditingController(text: widget.flashcard['meaning']);
    String difficulty = widget.flashcard['difficulty'] ?? 'Easy';

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
                'Edit Flashcard',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: wordController,
                decoration: InputDecoration(
                  labelText: 'Word',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: meaningController,
                decoration: InputDecoration(
                  labelText: 'Meaning',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 25),
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
                      widget.onEdit({
                        'word': wordController.text.trim(),
                        'meaning': meaningController.text.trim(),
                        'difficulty': difficulty,
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
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