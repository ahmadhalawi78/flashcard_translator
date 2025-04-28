import 'package:flutter/material.dart';
import 'homepage.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool showTextField = false; // switch between name input and initial button
  final TextEditingController _nameController = TextEditingController();
  bool _isNameEmpty = true; // disables "Next" button if empty

  @override
  void initState() {
    super.initState();
    // update button state when text changes
    _nameController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    // clean controller to prevent memory leaks
    _nameController.removeListener(_updateButtonState);
    _nameController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isNameEmpty = _nameController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5C89EB), Color(0xFFFECA9A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // return to flash icon if logo doesnt load
                Image.asset(
                  'assets/images/logo.png',
                  height: 150,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.flash_on,
                    size: 120,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),

                // switch between button and text input
                if (!showTextField) ...[
                  ElevatedButton(
                    onPressed: () => setState(() => showTextField = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Enter Your Name'),
                  ),
                ] else ...[
                  // customized text input container
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // navigate to HomePage when name isn't empty
                  ElevatedButton(
                    onPressed: _isNameEmpty
                        ? null
                        : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomePage(userName: _nameController.text),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isNameEmpty ? Colors.grey : Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Next'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}