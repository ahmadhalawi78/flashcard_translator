import 'package:flutter/material.dart';
import 'translation_service.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final TextEditingController _textController = TextEditingController();
  final TranslationService _translationService = TranslationService();
  String _translatedText = '';
  bool _isTranslating = false;
  String _errorMessage = '';
  String _fromLanguage = 'en';
  String _toLanguage = 'es';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
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
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text(
                  'Translation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Language Selection Row
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
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButton<String>(
                                value: _fromLanguage,
                                isExpanded: true,
                                underline: const SizedBox(),
                                icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                                items: const [
                                  DropdownMenuItem(value: 'en', child: Text('English')),
                                  DropdownMenuItem(value: 'es', child: Text('Spanish')),
                                  DropdownMenuItem(value: 'fr', child: Text('French')),
                                  DropdownMenuItem(value: 'de', child: Text('German')),
                                ],
                                onChanged: (value) => setState(() => _fromLanguage = value!),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DropdownButton<String>(
                                value: _toLanguage,
                                isExpanded: true,
                                underline: const SizedBox(),
                                icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                                items: const [
                                  DropdownMenuItem(value: 'en', child: Text('English')),
                                  DropdownMenuItem(value: 'es', child: Text('Spanish')),
                                  DropdownMenuItem(value: 'fr', child: Text('French')),
                                  DropdownMenuItem(value: 'de', child: Text('German')),
                                ],
                                onChanged: (value) => setState(() => _toLanguage = value!),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Text Input
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
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: 'Enter text to translate',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          maxLines: 3,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Translate Button
                      ElevatedButton(
                        onPressed: _isTranslating ? null : _translate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: _isTranslating
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          'Translate',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Error Message
                      if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: TextStyle(
                            color: Colors.red[200],
                            fontSize: 16,
                          ),
                        ),

                      // Translation Result
                      if (_translatedText.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Expanded(
                          child: Container(
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
                            padding: const EdgeInsets.all(16),
                            child: SingleChildScrollView(
                              child: Text(
                                _translatedText,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Future<void> _translate() async {
    if (_textController.text.isEmpty) return;

    setState(() {
      _isTranslating = true;
      _errorMessage = '';
      _translatedText = '';
    });

    try {
      final result = await _translationService.translate(
        _textController.text,
        _fromLanguage,
        _toLanguage,
      );
      setState(() => _translatedText = result);
    } catch (e) {
      setState(() => _errorMessage = 'Translation failed. Please try again.');
    } finally {
      setState(() => _isTranslating = false);
    }
  }
}