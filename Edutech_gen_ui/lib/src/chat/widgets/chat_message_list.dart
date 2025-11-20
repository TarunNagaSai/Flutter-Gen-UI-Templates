import 'package:education_gen_ui/src/chat/widgets/user_chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';

class ChatMessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final bool isLoading;
  final ScrollController scrollController;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.isLoading,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return UserMessageBubble(userMessage: messages[index].toString());
      },
    );
  }
}
