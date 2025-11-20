import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class UserMessageBubble extends StatelessWidget {
  const UserMessageBubble({super.key, required this.userMessage});

  final String userMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisSize: .min,
        mainAxisAlignment: .end,
        crossAxisAlignment: .start,
        children: [
          Expanded(child: GptMarkdown(userMessage)),
          SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primaryContainer,
                ],
              ),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 25),
          ),
        ],
      ),
    );
  }
}
