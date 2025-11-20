import 'package:flutter/material.dart';

class QuizCardWidget extends StatelessWidget {
  final String question;
  final List<String> options;
  final int? selectedIndex;
  final ValueChanged<int?> onOptionSelected;

  const QuizCardWidget({
    super.key,
    required this.question,
    required this.options,
    required this.onOptionSelected,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 1.5),
            const SizedBox(height: 8),
            ...List.generate(
              options.length,
              (index) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio<int>(
                  value: index,
                  groupValue: selectedIndex,
                  onChanged: onOptionSelected,
                ),
                title: Text(options[index]),
                onTap: () => onOptionSelected(index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
