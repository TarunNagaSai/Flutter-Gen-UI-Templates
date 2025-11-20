# Travel App: Add Local Persistence (Quick Patch)

## The Problem
Travel App only stores in memory → loses all data when app closes

## The Solution
Add SharedPreferences to persist GenUI conversations

---

## ✅ Minimal Implementation (5 Steps)

### Step 1: Add Dependency

```yaml
# pubspec.yaml
dependencies:
  shared_preferences: ^2.5.3
  json_annotation: ^4.8.1

dev_dependencies:
  json_serializable: ^6.7.1
```

Run: `flutter pub get`

---

### Step 2: Create Persistence Service

```dart
// lib/src/services/conversation_persistence.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:genui/genui.dart';

class ConversationPersistence {
  static const String _key = 'travel_conversations';

  /// Save GenUI conversation messages
  static Future<void> saveConversation(
    List<ChatMessage> messages,
    String conversationId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    
    final conversationData = {
      'id': conversationId,
      'timestamp': DateTime.now().toIso8601String(),
      'messages': _serializeMessages(messages),
    };

    final conversations = await _loadAllConversations();
    conversations.add(conversationData);
    
    await prefs.setString(_key, jsonEncode(conversations));
    print('✅ Saved conversation: $conversationId');
  }

  /// Load all saved conversations
  static Future<List<Map<String, dynamic>>> loadAllConversations() async {
    return await _loadAllConversations();
  }

  /// Load specific conversation
  static Future<List<ChatMessage>?> loadConversation(
    String conversationId,
  ) async {
    final conversations = await _loadAllConversations();
    
    final match = conversations.firstWhere(
      (c) => c['id'] == conversationId,
      orElse: () => {},
    );

    if (match.isEmpty) return null;

    return _deserializeMessages(
      List<Map<String, dynamic>>.from(match['messages'] ?? []),
    );
  }

  /// Delete conversation
  static Future<void> deleteConversation(String conversationId) async {
    final prefs = await SharedPreferences.getInstance();
    final conversations = await _loadAllConversations();
    
    conversations.removeWhere((c) => c['id'] == conversationId);
    
    await prefs.setString(_key, jsonEncode(conversations));
    print('🗑️ Deleted conversation: $conversationId');
  }

  /// Clear all conversations
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    print('🗑️ Cleared all conversations');
  }

  // Private helpers
  static Future<List<Map<String, dynamic>>> _loadAllConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    
    if (json == null) return [];
    
    return List<Map<String, dynamic>>.from(jsonDecode(json));
  }

  static List<Map<String, dynamic>> _serializeMessages(
    List<ChatMessage> messages,
  ) {
    return messages.map((msg) {
      if (msg is UserMessage) {
        return {
          'type': 'user',
          'text': msg.text,
          'timestamp': msg.timestamp.toIso8601String(),
        };
      } else if (msg is AiTextMessage) {
        return {
          'type': 'aiText',
          'text': msg.text,
          'timestamp': msg.timestamp.toIso8601String(),
        };
      } else if (msg is AiUiMessage) {
        return {
          'type': 'aiUi',
          'surfaceId': msg.surfaceId,
          'timestamp': msg.timestamp.toIso8601String(),
        };
      }
      return {};
    }).toList();
  }

  static List<ChatMessage> _deserializeMessages(
    List<Map<String, dynamic>> data,
  ) {
    return data.map((msg) {
      final type = msg['type'] as String?;
      final timestamp = DateTime.parse(msg['timestamp'] as String? ?? '');

      switch (type) {
        case 'user':
          return UserMessage.text(msg['text'] as String? ?? '');
        case 'aiText':
          return AiTextMessage.text(msg['text'] as String? ?? '');
        case 'aiUi':
          return AiUiMessage(
            surfaceId: msg['surfaceId'] as String? ?? '',
          );
        default:
          return UserMessage.text('');
      }
    }).toList();
  }
}
```

---

### Step 3: Update Travel Planner Page

```dart
// lib/src/travel_planner_page.dart - Add these imports
import 'services/conversation_persistence.dart';

// In _TravelPlannerPageState, add this:
@override
void initState() {
  super.initState();
  
  // ... existing code ...
  
  // Add persistence listener
  _uiConversation.conversation.addListener(_saveCurrentConversation);
  
  // Load previous conversation on start
  _loadPreviousConversation();
}

void _saveCurrentConversation() {
  ConversationPersistence.saveConversation(
    _uiConversation.conversation.value,
    'current_session',
  );
}

Future<void> _loadPreviousConversation() async {
  try {
    final messages = await ConversationPersistence.loadConversation(
      'current_session',
    );
    // Optionally restore messages to UI
  } catch (e) {
    print('Could not load previous conversation: $e');
  }
}

@override
void dispose() {
  _uiConversation.conversation.removeListener(_saveCurrentConversation);
  // Save one final time before closing
  _saveCurrentConversation();
  
  _userMessageSubscription.cancel();
  _uiConversation.dispose();
  _textController.dispose();
  _scrollController.dispose();
  super.dispose();
}
```

---

### Step 4: Add UI to View Saved Conversations

```dart
// Add to main.dart or new page
class PreviousConversations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ConversationPersistence.loadAllConversations(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        
        final conversations = snapshot.data!;
        
        return ListView.builder(
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            final conv = conversations[index];
            return ListTile(
              title: Text('Conversation ${conv['id']}'),
              subtitle: Text(conv['timestamp'] ?? ''),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  ConversationPersistence.deleteConversation(conv['id']);
                  // Refresh UI
                },
              ),
            );
          },
        );
      },
    );
  }
}
```

---

### Step 5: Test It

```dart
// In main() or a test widget
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Test persistence
  await ConversationPersistence.saveConversation([], 'test_1');
  final saved = await ConversationPersistence.loadAllConversations();
  print('Saved conversations: ${saved.length}');
  
  runApp(const TravelApp());
}
```

---

## 🔄 Complete Flow

```
User Input
    ↓
_sendPrompt()
    ↓
GenUiConversation updates
    ↓
_saveCurrentConversation() triggered
    ↓
ConversationPersistence.saveConversation()
    ↓
SharedPreferences stores JSON
    ↓
✅ PERSISTED TO DISK
    ↓
App closes
    ↓
User opens app again
    ↓
_loadPreviousConversation()
    ↓
SharedPreferences retrieves JSON
    ↓
✅ RESTORED FROM DISK
```

---

## 📊 Data Structure

```json
{
  "id": "current_session",
  "timestamp": "2025-11-20T17:22:39Z",
  "messages": [
    {
      "type": "user",
      "text": "Tell me about Paris",
      "timestamp": "2025-11-20T17:22:39Z"
    },
    {
      "type": "aiText",
      "text": "Paris is...",
      "timestamp": "2025-11-20T17:22:42Z"
    },
    {
      "type": "aiUi",
      "surfaceId": "carousel_1",
      "timestamp": "2025-11-20T17:22:45Z"
    }
  ]
}
```

---

## ✨ Benefits vs Travel App

| Feature | Travel App | With Persistence |
|---------|-----------|------------------|
| Store in memory | ✅ | ✅ |
| **Save to disk** | ❌ | ✅ |
| **Restore on restart** | ❌ | ✅ |
| **View conversation history** | ❌ | ✅ |
| **Delete old chats** | ❌ | ✅ |

---

## 🚀 That's It!

Now the Travel App will:
- Save conversations automatically
- Restore them on app restart
- Keep history even after closing
- Allow viewing/managing previous conversations

---

## 📋 Advanced Options (Optional)

**Encrypt sensitive data:**
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Use for API keys, but conversations can be plain JSON
```

**Use Hive for better performance:**
```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0
```

**Implement sync to cloud:**
```dart
// Save to Firebase after local save
await FirebaseFirestore.instance
  .collection('conversations')
  .add(conversationData);
```

---

**See `PERSIST_GENUI_CONVERSATIONS.md` for your Edutech app approach**
