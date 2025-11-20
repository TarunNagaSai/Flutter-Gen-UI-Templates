# Phase 1: Master Index

## 📋 Files Created

### Models (`lib/src/models/`)

| File | Purpose | Key Classes |
|------|---------|------------|
| `quiz_question.dart` | Single quiz question | `QuizQuestion` |
| `quiz.dart` | Complete quiz | `Quiz` |
| `quiz_result.dart` | Quiz performance | `QuizResult` |
| `summary.dart` | AI-generated summaries | `Summary` |
| `chat_entry.dart` | Chat conversation | `ChatEntry` |
| `index.dart` | Barrel export (use this!) | All above |

**Import:** `import 'package:education_gen_ui/src/models/index.dart';`

### Services (`lib/src/services/`)

| File | Purpose | Key Classes |
|------|---------|------------|
| `local_storage_service.dart` | Data persistence | `LocalStorageService` |
| `index.dart` | Barrel export (use this!) | All above |

**Import:** `import 'package:education_gen_ui/src/services/index.dart';`

### Documentation

| File | Purpose | Read When |
|------|---------|-----------|
| `PHASE_1_SETUP.md` | Comprehensive guide | Setting up for the first time |
| `PHASE_1_QUICKSTART.md` | Quick reference | Need quick code patterns |
| `PHASE_1_SUMMARY.md` | Checklist & verification | Completing Phase 1 |
| `PHASE_1_INDEX.md` | This file | Navigating Phase 1 |

### Configuration

| File | Purpose | Change |
|------|---------|--------|
| `pubspec.yaml` | Dependencies | Added `json_annotation` & `json_serializable` |

## 🔍 Quick Reference

### To Save Chat Entry
```dart
import 'package:education_gen_ui/src/models/index.dart';
import 'package:education_gen_ui/src/services/index.dart';

final entry = ChatEntry(...);
await LocalStorageService().saveChatEntry(entry);
```

### To Create Quiz
```dart
final quiz = Quiz(
  id: 'q1',
  topic: 'Python',
  questions: [QuizQuestion(...), ...],
  createdAt: DateTime.now(),
);
```

### To Get All Summaries
```dart
final summaries = await LocalStorageService().getSummaries();
```

See **PHASE_1_QUICKSTART.md** for more examples.

## 📊 Data Structure Overview

```
ChatEntry
├── userQuery: String
├── aiExplanation: String
├── topic: String
├── videoId: String?
├── summaryId: String? → Summary
├── quizId: String? → Quiz
└── createdAt: DateTime

Quiz
├── topic: String
├── questions: List<QuizQuestion>
├── createdAt: DateTime
└── completedAt: DateTime?

QuizQuestion
├── text: String
├── options: List<String>
├── correctIndex: int
├── explanation: String
└── hints: String?

QuizResult
├── quizId: String → Quiz
├── answers: Map<questionId, selectedIndex>
├── score: int
├── percentage: double (calculated)
└── completedAt: DateTime

Summary
├── topic: String
├── summaryText: String
├── videoUrl: String?
├── quizId: String? → Quiz
├── isSaved: bool
└── createdAt: DateTime
```

## 🔧 Setup Checklist

Complete these in order:

1. ✅ **Files created** - All models and services generated
2. ⬜ Run `flutter pub get` - Install dependencies
3. ⬜ Run `dart run build_runner build --delete-conflicting-outputs` - Generate `.g.dart` files
4. ⬜ Run `flutter analyze` - Verify no errors
5. ⬜ Update `main.dart` - Add `LocalStorageService().init()`
6. ⬜ Create test file - Verify everything works

**Complete items 2-6 before moving to Phase 2.**

## 🎯 Model Usage Quick Links

### ChatEntry
- **Create**: `ChatEntry(id, userQuery, aiExplanation, topic, ...)`
- **Save**: `storage.saveChatEntry(entry)`
- **Retrieve**: `storage.getChatHistory()` or `storage.getChatEntry(id)`
- **Update**: `storage.updateChatEntry(updatedEntry)`
- **Delete**: `storage.deleteChatEntry(id)`
- **Getters**: `hasVideo`, `hasSummary`, `hasQuiz`

### Quiz
- **Create**: `Quiz(id, topic, questions, createdAt, ...)`
- **Save**: `storage.saveQuiz(quiz)`
- **Retrieve**: `storage.getQuizzes()` or `storage.getQuiz(id)`
- **Getters**: `isCompleted`, `totalQuestions`

### QuizQuestion
- **Create**: `QuizQuestion(id, text, options, correctIndex, ...)`
- **Note**: Usually created as part of Quiz, not standalone
- **Getters**: None (simple data model)

### QuizResult
- **Create**: `QuizResult(id, quizId, topic, answers, score, ...)`
- **Save**: `storage.saveQuizResult(result)`
- **Retrieve**: `storage.getQuizResults()`, `getLatestQuizResult()`, `getQuizResultsByTopic(topic)`
- **Update**: `storage.updateQuizResult(result.copyWith(...))`
- **Getters**: `percentage`, `correctAnswers`, `incorrectAnswers`

### Summary
- **Create**: `Summary(id, topic, summaryText, ...)`
- **Save**: `storage.saveSummary(summary)`
- **Retrieve**: `storage.getSummaries()` or `storage.getSummary(id)`
- **Mark Saved**: `storage.markSummaryAsSaved(summaryId)`
- **Get Notes**: `storage.getSavedNotes()`
- **Update**: `storage.updateSummary(summary.copyWith(...))`
- **Getters**: `withIncrementedViewCount()` method

## 🔗 Data Relationships

```
User Query
   ↓
ChatEntry (stores query + explanation)
   ├─→ has videoId (YouTube video)
   ├─→ links to Summary (via summaryId)
   └─→ links to Quiz (via quizId)
        ↓
      Quiz
        ├─→ contains QuizQuestion[]
        └─→ links to QuizResult (user's attempt)
             ├─→ stores answers Map
             └─→ calculates score
        
Summary
   ├─→ summarizes explanation
   ├─→ can be marked as saved note
   └─→ tracks view count
```

## 💾 SharedPreferences Keys

Used internally by LocalStorageService:

- `chat_history` - List of ChatEntry objects
- `summaries` - List of Summary objects  
- `quizzes` - List of Quiz objects
- `quiz_results` - List of QuizResult objects
- `saved_notes` - Derived from summaries where `isSaved=true`

## 📚 When to Read Each Doc

| Document | When | Why |
|----------|------|-----|
| `PHASE_1_SETUP.md` | First time setup | Complete reference for models & service |
| `PHASE_1_QUICKSTART.md` | Writing code | Quick patterns and examples |
| `PHASE_1_SUMMARY.md` | Before Phase 2 | Checklist and success criteria |
| `PHASE_1_INDEX.md` | Navigating Phase 1 | This file - quick reference |

## 🚀 Next Steps

1. Complete setup checklist items 2-6 above
2. Read `PHASE_1_SUMMARY.md` success criteria
3. Run the test file to verify everything works
4. When ready, move to Phase 2: GenUI Catalog Items

## ❓ FAQ

**Q: Do I need to call `init()` every time?**  
A: No, it's a singleton. Call once in `main()`, then use `LocalStorageService()` anywhere.

**Q: How do I delete everything?**  
A: `await storage.clearAllData();`

**Q: Can I modify a saved item?**  
A: Yes, use `copyWith()` then `update()`:
```dart
final updated = item.copyWith(isSaved: true);
await storage.update(updated);
```

**Q: What if serialization fails?**  
A: Exception is thrown. All exceptions include context message for debugging.

**Q: Can I run this offline?**  
A: Yes! Everything uses local storage. No network calls in Phase 1.

## 🆘 Need Help?

1. **Setup issues?** → See `PHASE_1_SETUP.md` Troubleshooting
2. **Code patterns?** → See `PHASE_1_QUICKSTART.md` Quick Usage
3. **Completion check?** → See `PHASE_1_SUMMARY.md` Success Criteria
4. **Model details?** → See individual files in `lib/src/models/`

---

**Phase 1 Status**: ✅ Complete  
**Last Updated**: November 20, 2025  
**Next Phase**: Phase 2 - GenUI Catalog Items
