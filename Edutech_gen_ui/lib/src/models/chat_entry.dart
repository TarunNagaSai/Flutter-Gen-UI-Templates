import 'package:json_annotation/json_annotation.dart';

part 'chat_entry.g.dart';

@JsonSerializable()
class ChatEntry {
  /// Unique identifier for this chat entry
  final String id;

  /// The user's query/question
  final String userQuery;

  /// The AI's explanation
  final String aiExplanation;

  /// Topic being discussed
  final String topic;

  /// YouTube video ID (if available)
  final String? videoId;

  /// YouTube video title (if available)
  final String? videoTitle;

  /// YouTube video URL (if available)
  final String? videoUrl;

  /// Thumbnail URL for the video
  final String? videoThumbnailUrl;

  /// Associated summary ID (if available)
  final String? summaryId;

  /// Associated quiz ID (if available)
  final String? quizId;

  /// When this entry was created
  final DateTime createdAt;

  /// Whether this entry is pinned/saved
  final bool isPinned;

  /// Optional user notes for this entry
  final String? userNotes;

  /// Source metadata (e.g., where the video came from)
  final Map<String, String>? sourceMetadata;

  ChatEntry({
    required this.id,
    required this.userQuery,
    required this.aiExplanation,
    required this.topic,
    this.videoId,
    this.videoTitle,
    this.videoUrl,
    this.videoThumbnailUrl,
    this.summaryId,
    this.quizId,
    required this.createdAt,
    this.isPinned = false,
    this.userNotes,
    this.sourceMetadata,
  });

  /// Check if this entry has associated video
  bool get hasVideo => videoId != null && videoId!.isNotEmpty;

  /// Check if this entry has summary
  bool get hasSummary => summaryId != null && summaryId!.isNotEmpty;

  /// Check if this entry has quiz
  bool get hasQuiz => quizId != null && quizId!.isNotEmpty;

  /// Create a copy with modified fields
  ChatEntry copyWith({
    String? id,
    String? userQuery,
    String? aiExplanation,
    String? topic,
    String? videoId,
    String? videoTitle,
    String? videoUrl,
    String? videoThumbnailUrl,
    String? summaryId,
    String? quizId,
    DateTime? createdAt,
    bool? isPinned,
    String? userNotes,
    Map<String, String>? sourceMetadata,
  }) =>
      ChatEntry(
        id: id ?? this.id,
        userQuery: userQuery ?? this.userQuery,
        aiExplanation: aiExplanation ?? this.aiExplanation,
        topic: topic ?? this.topic,
        videoId: videoId ?? this.videoId,
        videoTitle: videoTitle ?? this.videoTitle,
        videoUrl: videoUrl ?? this.videoUrl,
        videoThumbnailUrl: videoThumbnailUrl ?? this.videoThumbnailUrl,
        summaryId: summaryId ?? this.summaryId,
        quizId: quizId ?? this.quizId,
        createdAt: createdAt ?? this.createdAt,
        isPinned: isPinned ?? this.isPinned,
        userNotes: userNotes ?? this.userNotes,
        sourceMetadata: sourceMetadata ?? this.sourceMetadata,
      );

  factory ChatEntry.fromJson(Map<String, dynamic> json) =>
      _$ChatEntryFromJson(json);

  Map<String, dynamic> toJson() => _$ChatEntryToJson(this);

  @override
  String toString() =>
      'ChatEntry(id: $id, topic: $topic, hasVideo: $hasVideo, hasSummary: $hasSummary)';
}
