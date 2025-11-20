// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Summary _$SummaryFromJson(Map<String, dynamic> json) => Summary(
  id: json['id'] as String,
  topic: json['topic'] as String,
  summaryText: json['summaryText'] as String,
  originalExplanation: json['originalExplanation'] as String?,
  quizId: json['quizId'] as String?,
  videoUrl: json['videoUrl'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  isSaved: json['isSaved'] as bool? ?? false,
  viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
  keywords:
      (json['keywords'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  language: json['language'] as String? ?? 'en',
);

Map<String, dynamic> _$SummaryToJson(Summary instance) => <String, dynamic>{
  'id': instance.id,
  'topic': instance.topic,
  'summaryText': instance.summaryText,
  'originalExplanation': instance.originalExplanation,
  'quizId': instance.quizId,
  'videoUrl': instance.videoUrl,
  'createdAt': instance.createdAt.toIso8601String(),
  'isSaved': instance.isSaved,
  'viewCount': instance.viewCount,
  'keywords': instance.keywords,
  'language': instance.language,
};
