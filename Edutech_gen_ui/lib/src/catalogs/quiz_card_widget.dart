import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  properties: {
    'question': A2uiSchemas.stringReference(
      description: 'A Question to ask the user.',
    ),
    'options': S.list(
      description: 'A list of options for the user to choose from.',
      items: S.object(
        properties: {
          'value': A2uiSchemas.stringReference(
            description:
                'An option that the user can select as an answer to the question.',
          ),
        },
        required: ['value'],
      ),
    ),
  },
  required: ['question, options'],
);

final quizCardWidgetCatalogItem = CatalogItem(
  name: 'QuizCardWidget',
  widgetBuilder: (itemContext) {
    final data = itemContext.data as Map<String, String>;

    final question = data["question"] as String;
    final options = data["options"] as List<String>;
    return QuizCardWidget(question: question, options: options);
  },
  dataSchema: _schema,
  exampleData: [_example1, _example2],
);

class QuizCardWidget extends StatefulWidget {
  final String question;
  final List<String> options;

  const QuizCardWidget({
    super.key,
    required this.question,
    required this.options,
  });

  @override
  State<QuizCardWidget> createState() => _QuizCardWidgetState();
}

class _QuizCardWidgetState extends State<QuizCardWidget> {
  String? _selectedOption;
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
              widget.question,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 1.5),
            const SizedBox(height: 8),
            ...List.generate(
              widget.options.length,
              (index) => RadioListTile<dynamic>.adaptive(
                value: widget.options[index],
                title: Text(widget.options[index]),
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value as String?;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),

            FilledButton(
              onPressed: _selectedOption == null ? null : () {},
              child: Text("Submit Answer"),
            ),
          ],
        ),
      ),
    );
  }
}

String _example1() => '''
{
  "question": "What is the capital of France?",
  "options": [
    {"value": "Berlin"},
    {"value": "Madrid"},
    {"value": "Paris"},
    {"value": "Rome"}
  ]
}
''';

String _example2() => '''
{
  "question": "Which planet is known as the Red Planet?",
  "options": [
    {"value": "Earth"},
    {"value": "Mars"},
    {"value": "Jupiter"},
    {"value": "Saturn"}
  ]
}
''';
