import 'package:json_annotation/json_annotation.dart';
import 'quiz_question.dart';

part 'quiz.g.dart';

@JsonSerializable()
class Quiz {
  /// Unique identifier for the quiz
  final String id;

  /// Topic this quiz is about
  final String topic;

  /// List of quiz questions
  final List<QuizQuestion> questions;

  /// When the quiz was created
  final DateTime createdAt;

  /// When the quiz was completed (null if not completed)
  final DateTime? completedAt;

  /// Total duration for the quiz in seconds (optional)
  final int? durationSeconds;

  Quiz({
    required this.id,
    required this.topic,
    required this.questions,
    required this.createdAt,
    this.completedAt,
    this.durationSeconds,
  });

  /// Check if quiz is completed
  bool get isCompleted => completedAt != null;

  /// Get total number of questions
  int get totalQuestions => questions.length;

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);

  Map<String, dynamic> toJson() => _$QuizToJson(this);

  @override
  String toString() =>
      'Quiz(id: $id, topic: $topic, questions: ${questions.length}, completed: $isCompleted)';
}
