# Phase 1: Foundation - Setup & Data Models

## Overview
This phase establishes the core data models and local storage layer for the educational GenUI app.

**Files created:**
- `lib/src/models/` - Data models for Quiz, QuizResult, Summary, ChatEntry
- `lib/src/services/local_storage_service.dart` - Persistence layer using SharedPreferences
- Updated `pubspec.yaml` with required dependencies

## What's Included

### 1. Data Models (`lib/src/models/`)

#### `quiz_question.dart`
Represents a single quiz question with multiple choice options.

**Fields:**
- `id` - Unique identifier
- `text` - Question text
- `options` - List of answer choices (typically 4)
- `correctIndex` - Index of correct answer (0-based)
- `explanation` - Why the answer is correct
- `hints` - Optional hints for the user

**Usage:**
```dart
final question = QuizQuestion(
  id: 'q1',
  text: 'What is the capital of France?',
  options: ['Paris', 'London', 'Berlin', 'Madrid'],
  correctIndex: 0,
  explanation: 'Paris is the capital and largest city of France.',
  hints: 'Think of the Eiffel Tower...',
);
```

#### `quiz.dart`
Represents a complete quiz with multiple questions about a topic.

**Fields:**
- `id` - Unique identifier
- `topic` - Topic being quizzed on
- `questions` - List of QuizQuestion objects
- `createdAt` - When the quiz was created
- `completedAt` - When completed (null if pending)
- `durationSeconds` - Optional duration limit

**Usage:**
```dart
final quiz = Quiz(
  id: 'quiz_python_101',
  topic: 'Python Basics',
  questions: [question1, question2, ...],
  createdAt: DateTime.now(),
);
```

#### `quiz_result.dart`
Stores the user's performance on a completed quiz.

**Fields:**
- `id` - Unique identifier
- `quizId` - Quiz ID this result belongs to
- `topic` - Topic of the quiz
- `answers` - Map of question ID → selected option index
- `score` - Number of correct answers
- `totalQuestions` - Total questions in quiz
- `completedAt` - When submitted
- `isSaved` - Whether saved to notes
- `userNotes` - Optional user annotations
- `timeTakenSeconds` - How long it took

**Helpful getters:**
- `percentage` - Calculate percentage score
- `correctAnswers` - Number of correct
- `incorrectAnswers` - Number of incorrect

**Usage:**
```dart
final result = QuizResult(
  id: 'result_001',
  quizId: 'quiz_python_101',
  topic: 'Python Basics',
  answers: {'q1': 0, 'q2': 1, 'q3': 2}, // User's selections
  score: 2, // Got 2 out of 3 correct
  totalQuestions: 3,
  completedAt: DateTime.now(),
);

print('Score: ${result.score}/${result.totalQuestions}');
print('Percentage: ${result.percentage}%');
```

#### `summary.dart`
AI-generated summaries of explanations, saved as notes.

**Fields:**
- `id` - Unique identifier
- `topic` - Topic being summarized
- `summaryText` - The summarized content
- `originalExplanation` - Reference to full explanation
- `quizId` - Associated quiz ID (if any)
- `videoUrl` - YouTube source URL
- `createdAt` - When created
- `isSaved` - Whether saved to notes
- `viewCount` - Number of views
- `keywords` - Extracted keywords
- `language` - Language code (default 'en')

**Usage:**
```dart
final summary = Summary(
  id: 'summary_001',
  topic: 'Python Lists',
  summaryText: 'Python lists are...',
  videoUrl: 'https://youtube.com/watch?v=...',
  createdAt: DateTime.now(),
  keywords: ['python', 'lists', 'arrays'],
);

// Save to notes
final savedSummary = summary.copyWith(isSaved: true);
```

#### `chat_entry.dart`
Stores complete conversation entries with AI explanation and video.

**Fields:**
- `id` - Unique identifier
- `userQuery` - User's question
- `aiExplanation` - AI's response
- `topic` - Topic being discussed
- `videoId`, `videoTitle`, `videoUrl` - YouTube video details
- `videoThumbnailUrl` - Video thumbnail
- `summaryId` - Associated summary
- `quizId` - Associated quiz
- `createdAt` - When created
- `isPinned` - Pinned/saved
- `userNotes` - User annotations
- `sourceMetadata` - Source information

**Helpful getters:**
- `hasVideo` - Check if video exists
- `hasSummary` - Check if summary exists
- `hasQuiz` - Check if quiz exists

**Usage:**
```dart
final entry = ChatEntry(
  id: 'entry_001',
  userQuery: 'Explain Python lists',
  aiExplanation: 'Lists in Python are...',
  topic: 'Python Lists',
  videoId: 'dQw4w9WgXcQ',
  videoTitle: 'Understanding Python Lists',
  videoUrl: 'https://youtube.com/watch?v=dQw4w9WgXcQ',
  createdAt: DateTime.now(),
);
```

### 2. Local Storage Service (`local_storage_service.dart`)

A singleton service that manages all data persistence using SharedPreferences.

#### Initialization
Must call `init()` before using:

```dart
// In main.dart or before app starts
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService().init();
  runApp(MyApp());
}
```

#### Chat History Methods

```dart
final storage = LocalStorageService();

// Save a chat entry
await storage.saveChatEntry(chatEntry);

// Get all chat history
final history = await storage.getChatHistory();

// Get specific entry
final entry = await storage.getChatEntry('entry_id');

// Update entry
await storage.updateChatEntry(updatedEntry);

// Delete entry
await storage.deleteChatEntry('entry_id');

// Clear all history
await storage.clearChatHistory();
```

#### Summary Methods

```dart
// Save a summary
await storage.saveSummary(summary);

// Get all summaries
final summaries = await storage.getSummaries();

// Mark as saved note
await storage.markSummaryAsSaved('summary_id');

// Get saved notes only
final notes = await storage.getSavedNotes();

// Get specific summary
final summary = await storage.getSummary('summary_id');

// Update summary
await storage.updateSummary(updatedSummary);

// Delete summary
await storage.deleteSummary('summary_id');

// Clear all summaries
await storage.clearSummaries();
```

#### Quiz Methods

```dart
// Save quiz
await storage.saveQuiz(quiz);

// Get all quizzes
final quizzes = await storage.getQuizzes();

// Get specific quiz
final quiz = await storage.getQuiz('quiz_id');

// Clear all quizzes
await storage.clearQuizzes();
```

#### Quiz Results Methods

```dart
// Save result
await storage.saveQuizResult(result);

// Get all results
final results = await storage.getQuizResults();

// Get specific result
final result = await storage.getQuizResult('result_id');

// Get latest result
final latest = await storage.getLatestQuizResult();

// Get results by topic
final topicResults = await storage.getQuizResultsByTopic('Python Basics');

// Update result (e.g., mark as saved)
final updated = result.copyWith(isSaved: true);
await storage.updateQuizResult(updated);

// Delete result
await storage.deleteQuizResult('result_id');

// Clear all results
await storage.clearQuizResults();
```

#### Utility Methods

```dart
// Get storage statistics
final stats = await storage.getStorageStats();
print('Chat entries: ${stats['chat_entries']}');
print('Summaries: ${stats['summaries']}');
print('Quizzes: ${stats['quizzes']}');
print('Quiz results: ${stats['quiz_results']}');

// Clear everything
await storage.clearAllData();
```

## Setup Instructions

### Step 1: Get Dependencies

```bash
cd /Users/tarunkodali/Projects/FlutterApps/Flutter-Gen-UI-Templates/Edutech_gen_ui
flutter pub get
```

### Step 2: Generate JSON Serialization Code

The models use `json_annotation` for serialization. Run the code generator:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates `.g.dart` files for each model (e.g., `quiz_question.g.dart`).

**Note:** After modifying any model file, re-run this command.

### Step 3: Verify Compilation

```bash
flutter analyze
```

Ensure no errors. Then try compiling:

```bash
flutter build ios --dry-run  # or flutter build apk --dry-run on Android
```

## Usage Example

Here's a complete workflow:

```dart
import 'package:education_gen_ui/src/models/index.dart';
import 'package:education_gen_ui/src/services/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  final storage = LocalStorageService();
  await storage.init();
  
  // Create a chat entry
  final entry = ChatEntry(
    id: 'entry_1',
    userQuery: 'What is recursion in Python?',
    aiExplanation: 'Recursion is when a function calls itself...',
    topic: 'Python Recursion',
    videoId: 'abc123',
    videoTitle: 'Recursion Explained',
    videoUrl: 'https://youtube.com/watch?v=abc123',
    createdAt: DateTime.now(),
  );
  
  // Save it
  await storage.saveChatEntry(entry);
  
  // Create a summary
  final summary = Summary(
    id: 'summary_1',
    topic: 'Python Recursion',
    summaryText: 'Recursion: A function calling itself with a base case...',
    videoUrl: 'https://youtube.com/watch?v=abc123',
    createdAt: DateTime.now(),
  );
  
  await storage.saveSummary(summary);
  
  // Create a quiz
  final quiz = Quiz(
    id: 'quiz_1',
    topic: 'Python Recursion',
    questions: [
      QuizQuestion(
        id: 'q1',
        text: 'What must every recursive function have?',
        options: ['A base case', 'A loop', 'A class', 'An import'],
        correctIndex: 0,
        explanation: 'A base case prevents infinite recursion.',
      ),
    ],
    createdAt: DateTime.now(),
  );
  
  await storage.saveQuiz(quiz);
  
  // Create a result
  final result = QuizResult(
    id: 'result_1',
    quizId: 'quiz_1',
    topic: 'Python Recursion',
    answers: {'q1': 0}, // User selected option 0
    score: 1, // Got 1 correct
    totalQuestions: 1,
    completedAt: DateTime.now(),
  );
  
  await storage.saveQuizResult(result);
  
  // Retrieve and display
  final history = await storage.getChatHistory();
  print('Chat history: ${history.length} entries');
  
  final stats = await storage.getStorageStats();
  print('Storage: $stats');
}
```

## Key Design Decisions

1. **Singleton Pattern**: LocalStorageService is a singleton to ensure single access point
2. **Async Operations**: All methods are async for consistency and future flexibility
3. **Error Handling**: Exceptions are thrown with descriptive messages
4. **JSON Serialization**: Using `json_annotation` for type-safe serialization
5. **copyWith Methods**: Models include `copyWith` for immutable updates
6. **Getter Helpers**: Models include useful getters (e.g., `percentage`, `hasVideo`)

## Common Mistakes to Avoid

❌ **Don't forget to call `init()`**
```dart
// WRONG
await storage.saveChatEntry(entry);

// RIGHT
await storage.init();
await storage.saveChatEntry(entry);
```

❌ **Don't forget to re-run build_runner after model changes**
```bash
# After editing a model file
dart run build_runner build --delete-conflicting-outputs
```

❌ **Don't create multiple LocalStorageService instances**
```dart
// WRONG - Creates multiple instances
final s1 = LocalStorageService();
final s2 = LocalStorageService(); // Different instance

// RIGHT - Always use singleton
final storage = LocalStorageService();
```

## Next Steps

After completing Phase 1:

1. ✅ Data models created and tested
2. ✅ LocalStorageService functional
3. 📋 Next: Phase 2 - Build GenUI Catalog Items
   - YouTubePlayerWidget
   - AIExplanationBubble
   - UserQueryBubble
   - SummaryCard
   - QuizCard
   - QuizResultCard
   - SavedNotesCard

## Files Structure After Phase 1

```
lib/src/
├── models/
│   ├── index.dart
│   ├── chat_entry.dart
│   ├── chat_entry.g.dart (generated)
│   ├── quiz.dart
│   ├── quiz.g.dart (generated)
│   ├── quiz_question.dart
│   ├── quiz_question.g.dart (generated)
│   ├── quiz_result.dart
│   ├── quiz_result.g.dart (generated)
│   ├── summary.dart
│   └── summary.g.dart (generated)
└── services/
    ├── index.dart
    └── local_storage_service.dart
```

## Troubleshooting

**Q: Getting errors about missing `.g.dart` files?**
A: Run `dart run build_runner build --delete-conflicting-outputs`

**Q: LocalStorageService initialization error?**
A: Ensure you call `await storage.init()` before any operations.

**Q: Compilation fails with "StateError"?**
A: Make sure the service is initialized before use.

**Q: Changes to models not reflected?**
A: Re-run the build_runner to regenerate JSON serialization code.
