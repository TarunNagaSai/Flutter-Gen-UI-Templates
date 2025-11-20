import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:education_gen_ui/src/providers/ai_provider.dart';
import 'package:education_gen_ui/src/chat/widgets/chat_suggestion_chip.dart';

class ChatSuggestionChips extends ConsumerWidget {
  const ChatSuggestionChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        ChatSuggestionChip(
          label: 'Plan a 7-day trip to Rome',
          icon: Icons.flight_takeoff,
          onTap: (label) => ref.read(aiChatProvider.notifier).sendMessage(label),
        ),
        ChatSuggestionChip(
          label: 'Budget hotels in Paris',
          icon: Icons.hotel,
          onTap: (label) => ref.read(aiChatProvider.notifier).sendMessage(label),
        ),
        ChatSuggestionChip(
          label: 'Kid-friendly activities',
          icon: Icons.family_restroom,
          onTap: (label) => ref.read(aiChatProvider.notifier).sendMessage(label),
        ),
      ],
    );
  }
}
