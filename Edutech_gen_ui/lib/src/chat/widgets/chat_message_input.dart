import 'package:flutter/material.dart';

class ChatMessageInput extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSendMessage;
  final bool isLoading;

  const ChatMessageInput({
    super.key,
    required this.controller,
    required this.onSendMessage,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                suffixIcon: IconButton(
                  onPressed: isLoading ? null : () => onSendMessage(controller.text),
                  icon: const Icon(Icons.send),
                ),
              ),
              onSubmitted: isLoading ? null : onSendMessage,
              textInputAction: TextInputAction.send,
            ),
          ),
        ],
      ),
    );
  }
}
