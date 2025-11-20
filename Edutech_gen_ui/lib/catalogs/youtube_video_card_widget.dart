import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YouTubeVideoCardWidget extends StatefulWidget {
  final String videoId;
  final VoidCallback onAnalyze;
  final String analyzeButtonText;

  const YouTubeVideoCardWidget({
    super.key,
    required this.videoId,
    required this.onAnalyze,
    this.analyzeButtonText = 'Analyse',
  });

  @override
  State<YouTubeVideoCardWidget> createState() => _YouTubeVideoCardWidgetState();
}

class _YouTubeVideoCardWidgetState extends State<YouTubeVideoCardWidget> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          YoutubePlayerScaffold(
            controller: _controller,
            builder: (context, player) {
              return AspectRatio(aspectRatio: 16 / 9, child: player);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: widget.onAnalyze,
                child: Text(widget.analyzeButtonText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
