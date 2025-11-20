# How Travel App Sends Previous Chat Context to AI

## Overview
The Travel App maintains a **complete conversation history** and sends it to the AI on every request. This allows the AI to maintain context and provide coherent responses across the entire conversation.

---

## 🔄 Complete Flow

```
User Types Message
    ↓
_sendPrompt() called
    ↓
_triggerInference(UserMessage.text(text))
    ↓
GenUiConversation.sendRequest(message)
    ↓
✅ KEY STEP: Gets history from _conversation.value
    ↓
contentGenerator.sendRequest(message, history: history)
    ↓
FirebaseAiContentGenerator receives ALL messages
    ↓
Converts to Firebase AI format
    ↓
Sends to Gemini API
    ↓
AI responds with context awareness
```

---

## 📍 Step-by-Step Code Walkthrough

### Step 1: User Sends Message (travel_planner_page.dart)

```dart
void _sendPrompt(String text) {
  if (_uiConversation.isProcessing.value || text.trim().isEmpty) return;
  _scrollToBottom();
  _textController.clear();
  _triggerInference(UserMessage.text(text));  // ← Creates new message
}

Future<void> _triggerInference(ChatMessage message) async {
  await _uiConversation.sendRequest(message);  // ← Sends to GenUiConversation
}
```

**What happens:**
- User types: `"Tell me about Paris beaches"`
- Creates: `UserMessage.text("Tell me about Paris beaches")`
- Passes to: `GenUiConversation.sendRequest()`

---

### Step 2: GenUiConversation Gathers History

```dart
// In gen_ui_conversation.dart (lines 147-153)

Future<void> sendRequest(ChatMessage message) async {
  final List<ChatMessage> history = _conversation.value;  // ← GET ALL HISTORY
  if (message is! UserUiInteractionMessage) {
    _conversation.value = [...history, message];  // ← ADD NEW MESSAGE
  }
  return contentGenerator.sendRequest(message, history: history);  // ← SEND TO AI
}
```

**What happens:**
- `_conversation.value` contains: `[UserMessage(...), AiTextMessage(...), AiUiMessage(...), ...]`
- New message is added to history
- **Complete history passed to contentGenerator**

---

### Step 3: ContentGenerator Converts History to API Format

```dart
// In firebase_ai_content_generator.dart (lines 111-133)

@override
Future<void> sendRequest(
  ChatMessage message, {
  Iterable<ChatMessage>? history,
}) async {
  _isProcessing.value = true;
  try {
    final messages = [...?history, message];  // ← COMBINE HISTORY + NEW MESSAGE
    final Object? response = await _generate(
      messages: messages,  // ← ALL MESSAGES SENT TO _generate()
    );
  } catch (e, st) {
    // Handle error
  } finally {
    _isProcessing.value = false;
  }
}
```

**What happens:**
- Combines history + current message
- Example: `[Message1, Message2, Message3, NewMessage]`
- Passes all to `_generate()`

---

### Step 4: Convert to Firebase AI Format

```dart
// In firebase_ai_content_generator.dart (lines 337-364)

Future<Object?> _generate({
  required Iterable<ChatMessage> messages,
  dsb.Schema? outputSchema,
}) async {
  // Convert ChatMessage objects to Firebase AI Content format
  final List<Content> mutableContent = converter.toFirebaseAiContent(
    messages,  // ← ALL MESSAGES (history + new message)
  );
  
  // Create model with system instruction
  final GeminiGenerativeModelInterface model = modelCreator(
    configuration: this,
    systemInstruction: systemInstruction == null
        ? null
        : Content.system(systemInstruction!),  // ← SYSTEM PROMPT ADDED
    tools: generativeAiTools,
  );
  
  // Send to Gemini API
  // model.generateContent(mutableContent)
}
```

**What happens:**
- All messages converted to Firebase AI Content format
- System instruction added (Travel Agent prompt)
- Sent to Gemini API

---

## 📊 Example: Complete Conversation Context

### Message History in Memory (_conversation.value)

```
[
  // Turn 1
  UserMessage("I want to visit Europe"),
  AiTextMessage("Great! What kind of experience..."),
  AiUiMessage(TravelCarousel with [Relaxing, Adventure, Cultural]),
  
  // Turn 2
  UserMessage("I'm interested in cultural"),
  AiTextMessage("Excellent choice..."),
  AiUiMessage(TravelCarousel with [France, Italy, Spain]),
  
  // Turn 3
  UserMessage("Tell me more about Paris")  // ← Current message
]
```

### What Gets Sent to Gemini API

```json
{
  "system_instruction": "You are a helpful travel agent...",
  "messages": [
    {
      "role": "user",
      "content": "I want to visit Europe"
    },
    {
      "role": "model",
      "content": "Great! What kind of experience..."
    },
    {
      "role": "user",
      "content": "I'm interested in cultural"
    },
    {
      "role": "model",
      "content": "Excellent choice..."
    },
    {
      "role": "user",
      "content": "Tell me more about Paris"  // ← Current
    }
  ]
}
```

### AI's Response

The AI sees the entire context:
- User wants European travel
- Chose cultural experience  
- Now asking about Paris
- Can generate relevant response with full context awareness

---

## 🔑 Key Data Structures

### ChatMessage Types

```dart
// Abstract base class
abstract class ChatMessage {
  DateTime get timestamp;
}

// User input
class UserMessage extends ChatMessage {
  final String text;
  UserMessage.text(this.text);
}

// AI text response
class AiTextMessage extends ChatMessage {
  final String text;
  AiTextMessage.text(this.text);
}

// AI UI component
class AiUiMessage extends ChatMessage {
  final String surfaceId;
  final UiDefinition definition;
}

// User interaction with UI
class UserUiInteractionMessage extends ChatMessage {
  // e.g., user clicked on carousel item
}

// Tool response
class ToolResponseMessage extends ChatMessage {
  final String toolName;
  final dynamic result;
}
```

### GenUiConversation Storage

```dart
// Line 78-79 of gen_ui_conversation.dart
final ValueNotifier<List<ChatMessage>> _conversation =
    ValueNotifier<List<ChatMessage>>([]);
```

**Storage Details:**
- Type: `ValueNotifier<List<ChatMessage>>`
- Location: **Memory only** (RAM)
- Accessed via: `_conversation.value`
- Updated by: `_conversation.value = [..._conversation.value, newMessage]`
- Lost when: App is closed or state is reset

---

## 💾 Why Memory Storage?

Travel App stores only in memory because:

1. **Demo/Showcase App**: Not production-ready
2. **Stateless by Design**: Each session is independent
3. **Simplicity**: No database overhead
4. **Performance**: Fast access for real-time AI responses
5. **No Persistence**: Data intentionally discarded on close

---

## 🎯 For Your Edutech App

Your app **should persist** because:

| Feature | Travel App | Edutech App |
|---------|-----------|-----------|
| **Persistence** | ❌ Memory only | ✅ SharedPreferences |
| **Conversation history** | Lost on close | Saved permanently |
| **Restore on restart** | ❌ | ✅ |
| **Production use** | Demo | Real education |
| **Student data** | Not important | Important |

---

## 🔄 How to Add Persistence to Your App

### Option 1: Quick Patch (Travel App)
Use `ConversationPersistence` service (from `TRAVEL_APP_PERSISTENCE_PATCH.md`)
- Save: `_conversation.value` to `SharedPreferences`
- Load: On app start, restore previous conversation

### Option 2: Better Solution (Your Edutech App)
Use your Phase 1 infrastructure:
- Convert GenUI messages → `ChatEntry` models
- Store via `LocalStorageService`
- Load history on `initState`
- Pass to BLoC via `ChatHistoryLoaded` event

(See `PERSIST_GENUI_CONVERSATIONS.md` for complete guide)

---

## ✨ Complete Message Flow Diagram

```
┌─────────────────────────────────────────────────────┐
│           USER INPUT & AI RESPONSE CYCLE            │
└─────────────────────────────────────────────────────┘

    User Types "Tell me about Paris"
              ↓
    _sendPrompt(text)
              ↓
    Creates: UserMessage.text("Tell me about Paris")
              ↓
    _triggerInference(message)
              ↓
    GenUiConversation.sendRequest(message)
              ↓
    ╔════════════════════════════════════════╗
    ║  Gets History from _conversation.value ║
    ║  [                                      ║
    ║    UserMessage("Want Europe"),          ║
    ║    AiTextMessage("Great!"),             ║
    ║    AiUiMessage(carousel),               ║
    ║    UserMessage("Cultural interest"),    ║
    ║    AiTextMessage("Excellent!"),         ║
    ║    AiUiMessage(carousel2),              ║
    ║    UserMessage("Tell me about Paris")   ║
    ║  ]                                      ║
    ╚════════════════════════════════════════╝
              ↓
    contentGenerator.sendRequest(
      message,
      history: [all 7 messages above]
    )
              ↓
    Converts to Firebase AI format
              ↓
    Sends to Gemini API
              ↓
    ╔════════════════════════════════════════╗
    ║   AI Understands Full Context:         ║
    ║   - User wants European travel         ║
    ║   - Interested in cultural             ║
    ║   - Now asking about Paris specifically║
    ║                                        ║
    ║   Generates contextual response        ║
    ╚════════════════════════════════════════╝
              ↓
    AI Response returned
              ↓
    Added to _conversation.value
              ↓
    UI updated with new messages & surfaces
```

---

## 🚀 Key Takeaway

**Every message in the Travel App includes the entire conversation history.**

This ensures the AI always has full context to:
- Remember previous choices
- Understand user intent
- Provide coherent, multi-turn conversation
- Generate contextually relevant UI components

**The cost:** Larger API payloads, but ensures natural conversation flow

---

## 📝 Code Summary

| File | Key Function | Purpose |
|------|-----------|---------|
| `travel_planner_page.dart` | `_triggerInference()` | Initiates request |
| `gen_ui_conversation.dart` | `sendRequest()` | **Gathers history** |
| `firebase_ai_content_generator.dart` | `sendRequest()` | **Sends to API** |
| `gemini_content_converter.dart` | `toFirebaseAiContent()` | Converts format |

**The critical line:**
```dart
final messages = [...?history, message];  // Combines ALL history + new message
```
