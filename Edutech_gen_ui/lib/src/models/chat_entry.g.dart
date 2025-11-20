// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatEntry _$ChatEntryFromJson(Map<String, dynamic> json) => ChatEntry(
  id: json['id'] as String,
  userQuery: json['userQuery'] as String,
  aiExplanation: json['aiExplanation'] as String,
  topic: json['topic'] as String,
  videoId: json['videoId'] as String?,
  videoTitle: json['videoTitle'] as String?,
  videoUrl: json['videoUrl'] as String?,
  videoThumbnailUrl: json['videoThumbnailUrl'] as String?,
  summaryId: json['summaryId'] as String?,
  quizId: json['quizId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  isPinned: json['isPinned'] as bool? ?? false,
  userNotes: json['userNotes'] as String?,
  sourceMetadata: (json['sourceMetadata'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
);

Map<String, dynamic> _$ChatEntryToJson(ChatEntry instance) => <String, dynamic>{
  'id': instance.id,
  'userQuery': instance.userQuery,
  'aiExplanation': instance.aiExplanation,
  'topic': instance.topic,
  'videoId': instance.videoId,
  'videoTitle': instance.videoTitle,
  'videoUrl': instance.videoUrl,
  'videoThumbnailUrl': instance.videoThumbnailUrl,
  'summaryId': instance.summaryId,
  'quizId': instance.quizId,
  'createdAt': instance.createdAt.toIso8601String(),
  'isPinned': instance.isPinned,
  'userNotes': instance.userNotes,
  'sourceMetadata': instance.sourceMetadata,
};
