import 'package:flutter/material.dart';

class ChatSuggestionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function(String) onTap;

  const ChatSuggestionChip({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: () => onTap(label),
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
    );
  }
}
