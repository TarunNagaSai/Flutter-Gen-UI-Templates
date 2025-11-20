# Travel App: Quick Storage Reference

## 🎯 TL;DR

**Travel App stores conversations IN-MEMORY ONLY. No persistence.**

---

## 📊 Quick Comparison

### Travel App
```dart
// Line 51: Stored in StatefulWidget
late final GenUiConversation _uiConversation;

// Line 147: Accessed via ValueNotifier
ValueListenableBuilder<List<ChatMessage>>(
  valueListenable: _uiConversation.conversation,  // In-memory
```

**Lifetime:** Session only (cleared on dispose)

---

### Your Edutech App (Better)
```dart
// Same GenUiConversation + LocalStorageService
late final GenUiConversation _uiConversation;
late final LocalStorageService _storage;

// Persist after each message
await _storage.saveChatEntry(entry);

// Restore on app start
await _storage.getChatHistory();
```

**Lifetime:** Permanent (device storage)

---

## 🔄 Message Types

Both use GenUI's `ChatMessage`:

- `UserMessage` - User input
- `AiTextMessage` - AI explanation
- `AiUiMessage` - AI-generated UI widget
- `ToolResponseMessage` - Tool execution results
- `InternalMessage` - Logging

---

## 💡 Key Insight

Travel App architecture:
```
User Input → GenUiConversation → ValueNotifier → UI Update
                    ↓
            (Lost when app closes)
```

Your Edutech architecture:
```
User Input → GenUiConversation → ValueNotifier → UI Update
                    ↓                    ↓
           LocalStorageService    (Persistent)
```

---

## 📋 Dependencies

| Travel App | Your App |
|-----------|----------|
| genui | genui |
| genui_firebase_ai | genui_firebase_ai |
| (No DB) | shared_preferences |
| (No BLoC) | flutter_bloc |

---

## 🚀 Your Advantage

✅ Conversations persist across app restarts  
✅ Users can review learning history  
✅ Quiz results saved for progress tracking  
✅ Summaries stored as permanent notes  

vs.

❌ Travel App loses everything on close

---

## 📍 File Reference

Travel App main files:
- `travel_planner_page.dart` - State management (lines 49-107)
- `src/catalog.dart` - UI components
- `main.dart` - App setup

Your Edutech files:
- `lib/src/models/` - Data models ✅ (Phase 1)
- `lib/src/services/local_storage_service.dart` - Persistence ✅ (Phase 1)
- `lib/src/const/education_system_prompt.dart` - AI tutor ✅ (Just created)
- `lib/src/catalog/` - UI components (Phase 2, next)

---

**See `TRAVEL_APP_CONVERSATION_STORAGE.md` for complete analysis**
