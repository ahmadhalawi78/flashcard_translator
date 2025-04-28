import 'package:translator/translator.dart';

class TranslationService {
  final GoogleTranslator _translator = GoogleTranslator();

  Future<String> translate(
      String text,
      String from,
      String to,
      ) async {
    try {
      final translation = await _translator.translate(
        text,
        from: from,
        to: to,
      );
      return translation.text;
    } catch (e) {
      throw Exception('Translation failed: $e');
    }
  }
}