# Persist GenUI Conversations to Local Storage

## ✅ Yes! You Can Do This

You already have `LocalStorageService` with all the methods needed. Here's how to save GenUI `ChatMessage` objects to persistent storage.

---

## 🎯 Quick Start

### Step 1: Convert GenUI ChatMessage to Your Models

Create a converter to transform GenUI's `ChatMessage` to your `ChatEntry`:

```dart
// lib/src/services/genui_conversation_service.dart

import 'package:genui/genui.dart';
import '../models/index.dart';
import 'local_storage_service.dart';

class GenUiConversationService {
  static final GenUiConversationService _instance = 
      GenUiConversationService._();

  factory GenUiConversationService() => _instance;
  GenUiConversationService._();

  /// Convert GenUI ChatMessage list to ChatEntry
  ChatEntry _messagesToChatEntry(
    List<ChatMessage> messages,
    String topic,
  ) {
    // Find user message
    final userMsg = messages.firstWhere(
      (msg) => msg is UserMessage,
      orElse: () => UserMessage.text(''),
    ) as UserMessage?;

    // Find AI explanation (text response)
    final aiMsg = messages.firstWhere(
      (msg) => msg is AiTextMessage,
      orElse: () => AiTextMessage.text(''),
    ) as AiTextMessage?;

    // Find video reference in AI UI message
    String? videoId;
    String? videoTitle;
    String? videoUrl;
    
    // Extract from toolbar response if available
    // (You can enhance this based on your AI response structure)

    return ChatEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userQuery: userMsg?.text ?? '',
      aiExplanation: aiMsg?.text ?? '',
      topic: topic,
      videoId: videoId,
      videoTitle: videoTitle,
      videoUrl: videoUrl,
      createdAt: DateTime.now(),
    );
  }

  /// Save all messages from GenUiConversation
  Future<void> saveChatHistory(
    List<ChatMessage> messages,
    String topic,
  ) async {
    final storage = LocalStorageService();
    
    try {
      final entry = _messagesToChatEntry(messages, topic);
      await storage.saveChatEntry(entry);
    } catch (e) {
      throw Exception('Failed to save chat history: $e');
    }
  }

  /// Load previous chat history
  Future<List<ChatEntry>> loadChatHistory() async {
    final storage = LocalStorageService();
    return await storage.getChatHistory();
  }
}
```

---

## 🔌 Step 2: Integrate Into Your Chat Page

Here's how to wire up GenUI with persistent storage:

```dart
// lib/src/chat/pages/education_chat_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart';
import 'package:genui_firebase_ai/genui_firebase_ai.dart';

import '../../const/education_system_prompt.dart';
import '../../models/index.dart';
import '../../services/genui_conversation_service.dart';
import '../../services/local_storage_service.dart';
import '../bloc/ai_bloc.dart';

class EducationChatPage extends StatefulWidget {
  const EducationChatPage({Key? key}) : super(key: key);

  @override
  State<EducationChatPage> createState() => _EducationChatPageState();
}

class _EducationChatPageState extends State<EducationChatPage> {
  late GenUiConversation _uiConversation;
  late GenUiConversationService _conversationService;
  late LocalStorageService _storage;
  
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  
  String _currentTopic = '';

  @override
  void initState() {
    super.initState();
    _conversationService = GenUiConversationService();
    _storage = LocalStorageService();
    
    _initializeGenUI();
    _loadPreviousChat();
  }

  void _initializeGenUI() {
    // Set up GenUI Manager
    final genUiManager = GenUiManager(
      catalog: educationCatalog,
      configuration: const GenUiConfiguration(
        actions: ActionsConfig(
          allowCreate: true,
          allowUpdate: true,
          allowDelete: true,
        ),
      ),
    );

    // Set up AI Content Generator
    final contentGenerator = FirebaseAiContentGenerator(
      catalog: educationCatalog,
      systemInstruction: educationSystemPrompt,
      additionalTools: [],
    );

    // Create GenUI Conversation
    _uiConversation = GenUiConversation(
      genUiManager: genUiManager,
      contentGenerator: contentGenerator,
      onSurfaceAdded: (_) => _scrollToBottom(),
      onSurfaceUpdated: (_) => _scrollToBottom(),
      onTextResponse: (_) => _scrollToBottom(),
    );

    // Listen to conversation changes and save
    _uiConversation.conversation.addListener(_saveConversation);
  }

  /// Load previous conversation from storage
  Future<void> _loadPreviousChat() async {
    try {
      final history = await _storage.getChatHistory();
      if (history.isNotEmpty) {
        // Restore most recent chat
        final latest = history.last;
        _currentTopic = latest.topic;
        
        // Notify BLoC to restore chat history
        if (mounted) {
          context.read<AiBloc>().add(
            ChatHistoryLoaded(history),
          );
        }
      }
    } catch (e) {
      print('Failed to load chat history: $e');
    }
  }

  /// Save conversation whenever it changes
  Future<void> _saveConversation() async {
    try {
      final messages = _uiConversation.conversation.value;
      if (messages.isNotEmpty && _currentTopic.isNotEmpty) {
        await _conversationService.saveChatHistory(
          messages,
          _currentTopic,
        );
      }
    } catch (e) {
      print('Failed to save conversation: $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendPrompt(String text) {
    if (_uiConversation.isProcessing.value || text.trim().isEmpty) {
      return;
    }

    // Extract topic from query (simple approach)
    _currentTopic = _extractTopic(text);

    // Send to AI
    _uiConversation.sendRequest(UserMessage.text(text));
    
    // Notify BLoC
    context.read<AiBloc>().add(UserQuerySubmitted(text));

    _textController.clear();
    _scrollToBottom();
  }

  String _extractTopic(String query) {
    // Simple topic extraction - enhance as needed
    final words = query.split(' ');
    return words.take(3).join(' ');
  }

  @override
  void dispose() {
    _uiConversation.conversation.removeListener(_saveConversation);
    _uiConversation.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Chat Display
          Expanded(
            child: ValueListenableBuilder<List<ChatMessage>>(
              valueListenable: _uiConversation.conversation,
              builder: (context, messages, _) {
                return _buildChatView(messages);
              },
            ),
          ),
          
          // Chat Input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder<bool>(
              valueListenable: _uiConversation.isProcessing,
              builder: (context, isLoading, _) {
                return _buildChatInput(isLoading);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatView(List<ChatMessage> messages) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        
        if (message is UserMessage) {
          return _buildUserBubble(message);
        } else if (message is AiTextMessage) {
          return _buildAIBubble(message);
        } else if (message is AiUiMessage) {
          return _buildUiBubble(message);
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildUserBubble(UserMessage message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildAIBubble(AiTextMessage message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message.text),
      ),
    );
  }

  Widget _buildUiBubble(AiUiMessage message) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('UI Component: ${message.surfaceId}'),
    );
  }

  Widget _buildChatInput(bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              enabled: !isLoading,
              decoration: const InputDecoration.collapsed(
                hintText: 'Ask me anything...',
              ),
              onSubmitted: isLoading ? null : _sendPrompt,
            ),
          ),
          if (isLoading)
            const SizedBox(
              width: 24,
              height: 24,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _sendPrompt(_textController.text),
            ),
        ],
      ),
    );
  }
}
```

---

## 📱 Step 3: Update Your BLoC

Add events to handle chat persistence:

```dart
// lib/src/chat/bloc/ai_event.dart

abstract class AiEvent extends Equatable {
  const AiEvent();

  @override
  List<Object?> get props => [];
}

class UserQuerySubmitted extends AiEvent {
  final String query;
  const UserQuerySubmitted(this.query);

  @override
  List<Object?> get props => [query];
}

class ChatHistoryLoaded extends AiEvent {
  final List<ChatEntry> history;
  const ChatHistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

class ConversationSaved extends AiEvent {
  final List<ChatMessage> messages;
  const ConversationSaved(this.messages);

  @override
  List<Object?> get props => [messages];
}
```

---

## 💾 Step 4: Enhanced ChatEntry Storage

Your `ChatEntry` model already supports this:

```dart
// From Phase 1 - lib/src/models/chat_entry.dart

ChatEntry(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  userQuery: 'Explain closures',
  aiExplanation: 'A closure is...',
  topic: 'JavaScript Closures',
  videoId: 'abc123',
  videoTitle: 'Closures Explained',
  videoUrl: 'https://youtube.com/watch?v=abc123',
  videoThumbnailUrl: '...',
  summaryId: null,  // Set later when summary created
  quizId: null,      // Set later when quiz created
  createdAt: DateTime.now(),
  isPinned: false,
  userNotes: null,
  sourceMetadata: null,
)
```

Then save using:

```dart
await storage.saveChatEntry(entry);

// Later retrieve:
final history = await storage.getChatHistory();
final topicHistory = history.where((e) => e.topic == 'JavaScript').toList();
```

---

## 🔄 Complete Flow Diagram

```
┌─────────────────────────────────────────────┐
│  _EducationChatPageState                    │
│  - _uiConversation: GenUiConversation       │
│  - _conversationService: GenUiConversationService
│  - _storage: LocalStorageService            │
└──────────────────┬──────────────────────────┘
                   │
        ┌──────────┴──────────┐
        ↓                     ↓
   User Types          AI Responds
        ↓                     ↓
   _sendPrompt()    _saveConversation()
        ↓                     ↓
GenUiConversation   Convert to ChatEntry
   sends message          ↓
        ↓          SharedPreferences
   ValueNotifier       (Local Storage)
   rebuilds UI              ↓
        ↓            User can restore
    Chat UI          chat history later
```

---

## ✨ Benefits

✅ **Persistence**: Conversations saved automatically  
✅ **Recovery**: Restore chat history on app restart  
✅ **History**: Keep records of all past conversations  
✅ **Analysis**: Track learning progress over time  
✅ **Offline**: Works without network after initial sync  

---

## 🚀 Implementation Checklist

- [ ] Create `GenUiConversationService` (converter class)
- [ ] Update `EducationChatPage` to integrate GenUI
- [ ] Add persistence hooks in `initState()` and listeners
- [ ] Update BLoC events for chat persistence
- [ ] Test saving/loading conversations
- [ ] Verify data in SharedPreferences
- [ ] Add UI to show chat history/previous conversations

---

## 📊 Data Flow Example

```dart
// Save
User: "What's recursion?"
  ↓
GenUiConversation processes
  ↓
_conversationService.saveChatHistory(messages, "Recursion")
  ↓
LocalStorageService.saveChatEntry(ChatEntry(...))
  ↓
SharedPreferences stores as JSON
  ↓
✅ Persisted!

// Load on next app start
await LocalStorageService().getChatHistory()
  ↓
Retrieve all previous ChatEntry objects
  ↓
Display in previous conversations list
  ↓
User can click to resume learning
```

---

## 🔗 Related Documentation

- `PHASE_1_SETUP.md` - LocalStorageService API
- `PHASE_1_QUICKSTART.md` - Quick usage examples
- `TRAVEL_APP_CONVERSATION_STORAGE.md` - Travel App comparison
- `SYSTEM_PROMPT_REFERENCE.md` - GenUI integration

---

## 💡 Pro Tips

1. **Auto-save on every message**: Listener pattern (shown above)
2. **Batch save**: Save after conversation completes
3. **Incremental save**: Save only new messages
4. **Archive old chats**: Move to different storage after N days
5. **Search history**: Use `getChatHistory()` then filter locally

---

**Status**: ✅ Complete guide for persistent GenUI conversations  
**Next**: Implement this in your chat page + Phase 2 GenUI catalog
