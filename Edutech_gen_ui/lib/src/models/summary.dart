import 'package:json_annotation/json_annotation.dart';

part 'summary.g.dart';

@JsonSerializable()
class Summary {
  /// Unique identifier for the summary
  final String id;

  /// Topic of the summary
  final String topic;

  /// The summarized text
  final String summaryText;

  /// Original explanation text (for reference)
  final String? originalExplanation;

  /// Associated quiz ID (if quiz was generated)
  final String? quizId;

  /// URL to the YouTube video source
  final String? videoUrl;

  /// When the summary was created
  final DateTime createdAt;

  /// Whether this summary has been saved as a note
  final bool isSaved;

  /// Number of times this summary was viewed
  final int viewCount;

  /// Keywords extracted from the summary
  final List<String> keywords;

  /// Language of the summary (default: 'en')
  final String language;

  Summary({
    required this.id,
    required this.topic,
    required this.summaryText,
    this.originalExplanation,
    this.quizId,
    this.videoUrl,
    required this.createdAt,
    this.isSaved = false,
    this.viewCount = 0,
    this.keywords = const [],
    this.language = 'en',
  });

  /// Create a copy with modified fields
  Summary copyWith({
    String? id,
    String? topic,
    String? summaryText,
    String? originalExplanation,
    String? quizId,
    String? videoUrl,
    DateTime? createdAt,
    bool? isSaved,
    int? viewCount,
    List<String>? keywords,
    String? language,
  }) =>
      Summary(
        id: id ?? this.id,
        topic: topic ?? this.topic,
        summaryText: summaryText ?? this.summaryText,
        originalExplanation: originalExplanation ?? this.originalExplanation,
        quizId: quizId ?? this.quizId,
        videoUrl: videoUrl ?? this.videoUrl,
        createdAt: createdAt ?? this.createdAt,
        isSaved: isSaved ?? this.isSaved,
        viewCount: viewCount ?? this.viewCount,
        keywords: keywords ?? this.keywords,
        language: language ?? this.language,
      );

  /// Increment view count
  Summary withIncrementedViewCount() => copyWith(viewCount: viewCount + 1);

  factory Summary.fromJson(Map<String, dynamic> json) =>
      _$SummaryFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryToJson(this);

  @override
  String toString() =>
      'Summary(id: $id, topic: $topic, saved: $isSaved, views: $viewCount)';
}
