import 'package:json_annotation/json_annotation.dart';

part 'quiz_question.g.dart';

@JsonSerializable()
class QuizQuestion {
  /// Unique identifier for the question
  final String id;

  /// The question text
  final String text;

  /// Multiple choice options (typically 4)
  final List<String> options;

  /// Index of the correct option (0-based)
  final int correctIndex;

  /// Explanation for why the correct answer is right
  final String explanation;

  /// Optional additional notes or hints
  final String? hints;

  QuizQuestion({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.hints,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuizQuestionToJson(this);

  @override
  String toString() =>
      'QuizQuestion(id: $id, text: $text, options: $options, correctIndex: $correctIndex)';
}
