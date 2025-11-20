import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:education_gen_ui/catalogs/input_text_box_widget.dart';
import 'package:education_gen_ui/catalogs/youtube_video_card_widget.dart';
import 'package:education_gen_ui/catalogs/quiz_card_widget.dart';

@RoutePage()
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    int? selectedQuizOption;

    return Scaffold(
      appBar: AppBar(title: const Text('Catalog Screen')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Text Box Widget
            const Text(
              'Input Text Box Widget',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            InputTextBoxWidget(
              controller: textController,
              hintText: 'Type your message...',
              onSend: () {
                debugPrint('Send button pressed: ${textController.text}');
              },
            ),
            const SizedBox(height: 24),

            // YouTube Video Card Widget
            const Text(
              'YouTube Video Card Widget',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            YouTubeVideoCardWidget(
              videoId: 'nTOVIGsqCuY',
              onAnalyze: () {
                debugPrint('Analyze button pressed');
              },
            ),
            const SizedBox(height: 24),

            // Quiz Card Widget
            const Text(
              'Quiz Card Widget',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            QuizCardWidget(
              question: 'What is the capital of France?',
              options: ['London', 'Berlin', 'Paris', 'Madrid'],
              selectedIndex: selectedQuizOption,
              onOptionSelected: (index) {
                debugPrint('Selected option: $index');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
