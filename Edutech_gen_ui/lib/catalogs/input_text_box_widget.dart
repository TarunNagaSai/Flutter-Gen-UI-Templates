import 'package:flutter/material.dart';

class InputTextBoxWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSend;
  final bool enabled;

  const InputTextBoxWidget({
    super.key,
    required this.controller,
    required this.onSend,
    this.hintText = 'Enter text...',
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: enabled ? onSend : null,
            ),
          ),
        ),
      ),
    );
  }
}
