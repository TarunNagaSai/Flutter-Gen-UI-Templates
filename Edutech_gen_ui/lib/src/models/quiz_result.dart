import 'package:json_annotation/json_annotation.dart';

part 'quiz_result.g.dart';

@JsonSerializable()
class QuizResult {
  /// Unique identifier for this result
  final String id;

  /// Quiz ID this result belongs to
  final String quizId;

  /// Topic of the quiz
  final String topic;

  /// User's answers mapped by question ID to selected option index
  final Map<String, int> answers;

  /// Score achieved (0-100)
  final int score;

  /// Total questions in the quiz
  final int totalQuestions;

  /// When the quiz was submitted
  final DateTime completedAt;

  /// Whether this result has been saved to notes
  final bool isSaved;

  /// Optional user notes about this quiz
  final String? userNotes;

  /// Time taken to complete quiz in seconds
  final int? timeTakenSeconds;

  QuizResult({
    required this.id,
    required this.quizId,
    required this.topic,
    required this.answers,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
    this.isSaved = false,
    this.userNotes,
    this.timeTakenSeconds,
  });

  /// Calculate percentage score
  double get percentage => (score / totalQuestions * 100).roundToDouble();

  /// Get number of correct answers
  int get correctAnswers => score;

  /// Get number of incorrect answers
  int get incorrectAnswers => totalQuestions - score;

  /// Create a copy with modified fields
  QuizResult copyWith({
    String? id,
    String? quizId,
    String? topic,
    Map<String, int>? answers,
    int? score,
    int? totalQuestions,
    DateTime? completedAt,
    bool? isSaved,
    String? userNotes,
    int? timeTakenSeconds,
  }) =>
      QuizResult(
        id: id ?? this.id,
        quizId: quizId ?? this.quizId,
        topic: topic ?? this.topic,
        answers: answers ?? this.answers,
        score: score ?? this.score,
        totalQuestions: totalQuestions ?? this.totalQuestions,
        completedAt: completedAt ?? this.completedAt,
        isSaved: isSaved ?? this.isSaved,
        userNotes: userNotes ?? this.userNotes,
        timeTakenSeconds: timeTakenSeconds ?? this.timeTakenSeconds,
      );

  factory QuizResult.fromJson(Map<String, dynamic> json) =>
      _$QuizResultFromJson(json);

  Map<String, dynamic> toJson() => _$QuizResultToJson(this);

  @override
  String toString() =>
      'QuizResult(id: $id, quizId: $quizId, score: $score/$totalQuestions, percentage: $percentage%)';
}
