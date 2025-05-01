import 'package:hive/hive.dart';

part 'flashcard.g.dart';

@HiveType(typeId: 0)
class Flashcard extends HiveObject {
  @HiveField(0)
  String word;

  @HiveField(1)
  String meaning;

  @HiveField(2)
  String difficulty;

  @HiveField(3)
  bool isLearned;

  Flashcard({
    required this.word,
    required this.meaning,
    required this.difficulty,
    this.isLearned = false,
  });
}
