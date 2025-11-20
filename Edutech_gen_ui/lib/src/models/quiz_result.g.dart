// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizResult _$QuizResultFromJson(Map<String, dynamic> json) => QuizResult(
  id: json['id'] as String,
  quizId: json['quizId'] as String,
  topic: json['topic'] as String,
  answers: Map<String, int>.from(json['answers'] as Map),
  score: (json['score'] as num).toInt(),
  totalQuestions: (json['totalQuestions'] as num).toInt(),
  completedAt: DateTime.parse(json['completedAt'] as String),
  isSaved: json['isSaved'] as bool? ?? false,
  userNotes: json['userNotes'] as String?,
  timeTakenSeconds: (json['timeTakenSeconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$QuizResultToJson(QuizResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quizId': instance.quizId,
      'topic': instance.topic,
      'answers': instance.answers,
      'score': instance.score,
      'totalQuestions': instance.totalQuestions,
      'completedAt': instance.completedAt.toIso8601String(),
      'isSaved': instance.isSaved,
      'userNotes': instance.userNotes,
      'timeTakenSeconds': instance.timeTakenSeconds,
    };
