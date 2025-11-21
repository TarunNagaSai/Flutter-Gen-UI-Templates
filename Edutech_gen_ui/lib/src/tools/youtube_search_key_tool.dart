import 'package:education_gen_ui/src/models/youtube_search_response.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// This is a AI tool to search YouTube videos based on a search key.
/// Basic MCP tool implementation
class YoutubeSearchKeyTool extends AiTool<Map<String, Object?>> {
  YoutubeSearchKeyTool({required this.listOfVideos})
    : super(
        name: "youtube_search_key_tool",
        description: "A tool to search YouTube videos based on a search key.",
        parameters: S.object(
          properties: {
            'searchKey': S.string(
              description: 'The search key to find relevant YouTube videos.',
            ),
          },
          required: ['searchKey'],
        ),
      );

  /// The callback to invoke when searching hotels.
  final Future<YouTubeSearchResponse> Function(String search) listOfVideos;

  @override
  Future<Map<String, Object?>> invoke(JsonMap args) async {
    final String searchKey = args['searchKey'] as String;

    /// Send the result to the youtube card
    return (await listOfVideos(searchKey)).toJson();
  }
}
