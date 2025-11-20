# Phase 1: Quick Start Guide

## Initial Setup (Run Once)

```bash
# 1. Navigate to project
cd /Users/tarunkodali/Projects/FlutterApps/Flutter-Gen-UI-Templates/Edutech_gen_ui

# 2. Get dependencies
flutter pub get

# 3. Generate JSON serialization code
dart run build_runner build --delete-conflicting-outputs

# 4. Verify no errors
flutter analyze
```

## Updating Models (Do This After Editing Any Model)

```bash
# Regenerate JSON serialization code
dart run build_runner build --delete-conflicting-outputs

# Clear build cache if stuck
flutter clean
dart run build_runner build --delete-conflicting-outputs
```

## Quick Usage Patterns

### Initialize Storage in main.dart

```dart
import 'package:education_gen_ui/src/services/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage FIRST
  await LocalStorageService().init();
  
  runApp(MyApp());
}
```

### Save a Chat Entry

```dart
import 'package:education_gen_ui/src/models/index.dart';
import 'package:education_gen_ui/src/services/index.dart';

final storage = LocalStorageService();

final entry = ChatEntry(
  id: 'entry_${DateTime.now().millisecondsSinceEpoch}',
  userQuery: 'Explain closures in JavaScript',
  aiExplanation: 'A closure is a function that has access to variables...',
  topic: 'JavaScript Closures',
  videoId: 'abc123xyz',
  videoTitle: 'Understanding Closures',
  videoUrl: 'https://youtube.com/watch?v=abc123xyz',
  createdAt: DateTime.now(),
);

await storage.saveChatEntry(entry);
```

### Create and Save a Quiz

```dart
import 'package:education_gen_ui/src/models/index.dart';

final quiz = Quiz(
  id: 'quiz_${DateTime.now().millisecondsSinceEpoch}',
  topic: 'JavaScript Closures',
  questions: [
    QuizQuestion(
      id: 'q1',
      text: 'What is a closure?',
      options: [
        'A function with access to outer scope',
        'A loop construct',
        'A class definition',
        'A variable declaration'
      ],
      correctIndex: 0,
      explanation: 'A closure is a function that has access to variables from its outer scope.',
    ),
    QuizQuestion(
      id: 'q2',
      text: 'Can closures access parent function variables?',
      options: ['Yes', 'No', 'Only global variables', 'Never'],
      correctIndex: 0,
      explanation: 'Yes, that\'s the whole point of closures!',
    ),
  ],
  createdAt: DateTime.now(),
);

await storage.saveQuiz(quiz);
```

### Submit Quiz and Save Result

```dart
final result = QuizResult(
  id: 'result_${DateTime.now().millisecondsSinceEpoch}',
  quizId: 'quiz_123',
  topic: 'JavaScript Closures',
  answers: {
    'q1': 0,  // User selected option 0
    'q2': 0,  // User selected option 0
  },
  score: 2,  // Got 2 correct
  totalQuestions: 2,
  completedAt: DateTime.now(),
);

await storage.saveQuizResult(result);

// Later: Mark as saved
final updated = result.copyWith(isSaved: true);
await storage.updateQuizResult(updated);
```

### Create and Save Summary

```dart
final summary = Summary(
  id: 'summary_${DateTime.now().millisecondsSinceEpoch}',
  topic: 'JavaScript Closures',
  summaryText: '''
A closure is a function that has access to variables from its own scope,
the outer function's scope, and the global scope. Closures are created
every time a function is created.
  ''',
  videoUrl: 'https://youtube.com/watch?v=abc123xyz',
  createdAt: DateTime.now(),
  keywords: ['javascript', 'closure', 'scope', 'function'],
);

await storage.saveSummary(summary);

// Save to notes
await storage.markSummaryAsSaved(summary.id);
```

### Retrieve and Display Data

```dart
// Get all chat history
final chatHistory = await storage.getChatHistory();
for (final entry in chatHistory) {
  print('${entry.topic}: ${entry.userQuery}');
}

// Get all saved notes
final savedNotes = await storage.getSavedNotes();
print('Saved notes: ${savedNotes.length}');

// Get latest quiz result
final latestResult = await storage.getLatestQuizResult();
if (latestResult != null) {
  print('Latest score: ${latestResult.percentage}%');
}

// Get results for a specific topic
final pythonResults = await storage.getQuizResultsByTopic('Python Basics');
print('Python quizzes completed: ${pythonResults.length}');

// Get statistics
final stats = await storage.getStorageStats();
print('Total chat entries: ${stats['chat_entries']}');
print('Total summaries: ${stats['summaries']}');
print('Quiz results: ${stats['quiz_results']}');
```

## Import Pattern

Always import from the index files:

```dart
// ✅ GOOD - Use the barrel export
import 'package:education_gen_ui/src/models/index.dart';
import 'package:education_gen_ui/src/services/index.dart';

// ❌ AVOID - Don't import individual files
// import 'package:education_gen_ui/src/models/quiz.dart';
```

## Common Gotchas

1. **Forgot to initialize storage?**
   ```dart
   // Error: StateError: LocalStorageService must be initialized
   await storage.init();  // Add this!
   ```

2. **Models won't serialize?**
   ```bash
   # Error: You're probably missing the .g.dart files
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Can't find file?**
   ```bash
   # Make sure you're in the right directory
   cd /Users/tarunkodali/Projects/FlutterApps/Flutter-Gen-UI-Templates/Edutech_gen_ui
   ```

4. **Build cache issues?**
   ```bash
   flutter clean
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```

## Testing Your Setup

Create a simple test to verify everything works:

```dart
// test/models_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:education_gen_ui/src/models/index.dart';
import 'package:education_gen_ui/src/services/index.dart';

void main() {
  group('LocalStorageService', () {
    setUp(() async {
      await LocalStorageService().init();
    });

    test('Can save and retrieve chat entry', () async {
      final storage = LocalStorageService();
      
      final entry = ChatEntry(
        id: 'test_1',
        userQuery: 'Test question',
        aiExplanation: 'Test answer',
        topic: 'Test topic',
        createdAt: DateTime.now(),
      );
      
      await storage.saveChatEntry(entry);
      final retrieved = await storage.getChatEntry('test_1');
      
      expect(retrieved.topic, equals('Test topic'));
    });
  });
}
```

Run tests:
```bash
flutter test
```

## Files Created in Phase 1

✅ `lib/src/models/quiz_question.dart` - Quiz question model  
✅ `lib/src/models/quiz.dart` - Quiz model  
✅ `lib/src/models/quiz_result.dart` - Quiz result model  
✅ `lib/src/models/summary.dart` - Summary model  
✅ `lib/src/models/chat_entry.dart` - Chat entry model  
✅ `lib/src/models/index.dart` - Barrel export  
✅ `lib/src/services/local_storage_service.dart` - Storage service  
✅ `lib/src/services/index.dart` - Barrel export  
✅ `pubspec.yaml` - Updated with dependencies  

## Next: Phase 2

When ready to move to Phase 2 (GenUI Catalog Items), you'll build:
- YouTubePlayerWidget
- AIExplanationBubble & UserQueryBubble
- SummaryCard
- QuizCard & QuizResultCard
- SavedNotesCard

See `PHASE_2_CATALOG.md` when ready.
