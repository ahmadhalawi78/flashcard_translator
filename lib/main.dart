import 'package:flutter/material.dart';
import 'screens/begin.dart';

// main entry point of app
void main() {
  // run FlashcardApp widget as root
  runApp(const FlashcardApp());
}

// root widget, stateless, so it doesnt hold a state
class FlashcardApp extends StatelessWidget {
  const FlashcardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard App', // app name
      debugShowCheckedModeBanner: false,
      theme: ThemeData( // style of app
        scaffoldBackgroundColor: Colors.white, // background color for Scaffold widgets
        primarySwatch: Colors.deepPurple, // color palette used

        // appBar customize globally
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0, // remove shadow
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // ElevatedButton customize globally
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF231274),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),

        // input fields customize globally
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF231274), width: 2),
          ),
          focusedBorder: OutlineInputBorder( // style when focused
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF231274), width: 2),
          ),
        ),
      ),

      // begin.dart as initial
      home: WelcomeScreen(),
    );
  }
}