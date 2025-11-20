import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:education_gen_ui/src/ai/bloc/ai_bloc.dart';
import 'package:education_gen_ui/src/chat/widgets/chat_suggestion_chip.dart';

class ChatSuggestionChips extends StatelessWidget {
  const ChatSuggestionChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        ChatSuggestionChip(
          label: 'Plan a 7-day trip to Rome',
          icon: Icons.flight_takeoff,
          onTap: (label) => context.read<AiBloc>().add(
            SendMessageEvent(message: label, context: context),
          ),
        ),
        ChatSuggestionChip(
          label: 'Budget hotels in Paris',
          icon: Icons.hotel,
          onTap: (label) => context.read<AiBloc>().add(
            SendMessageEvent(message: label, context: context),
          ),
        ),
        ChatSuggestionChip(
          label: 'Kid-friendly activities',
          icon: Icons.family_restroom,
          onTap: (label) => context.read<AiBloc>().add(
            SendMessageEvent(message: label, context: context),
          ),
        ),
      ],
    );
  }
}
