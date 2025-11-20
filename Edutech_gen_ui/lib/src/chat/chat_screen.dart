import 'package:auto_route/auto_route.dart';
import 'package:education_gen_ui/src/catalogs/catalogs.dart';
import 'package:education_gen_ui/src/const/education_system_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genui/genui.dart';
import 'package:education_gen_ui/src/providers/ai_provider.dart';
import 'package:education_gen_ui/src/chat/widgets/chat_message_input.dart';
import 'package:education_gen_ui/src/chat/widgets/chat_message_list.dart';
import 'package:genui_firebase_ai/genui_firebase_ai.dart';

@RoutePage()
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> surfaceIds = <String>[];
  // AI Model
  late final GenUiConversation _uiConversation;

  @override
  void initState() {
    final Catalog catalog = CoreCatalogItems.asCatalog();
    final genUiManager = GenUiManager(
      catalog: travelAppCatalog,
      configuration: const GenUiConfiguration(
        actions: ActionsConfig(
          allowCreate: true,
          allowUpdate: true,
          allowDelete: true,
        ),
      ),
    );
    final FirebaseAiContentGenerator generator = FirebaseAiContentGenerator(
      catalog: catalog,
      systemInstruction: educationSystemPrompt,
    );

    _uiConversation = GenUiConversation(
      genUiManager: genUiManager,
      contentGenerator: generator,
      onSurfaceUpdated: (update) {
        _scrollToBottom();
      },
      onSurfaceAdded: (update) {
        _scrollToBottom();
      },
      onTextResponse: (text) {
        if (!mounted) return;
        if (text.isNotEmpty) {
          _scrollToBottom();
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _handleSendMessage(String text) async {
    final msg = text.trim();
    if (msg.isNotEmpty) {
      _messageController.clear();
      ref.read(aiChatProvider.notifier).sendMessage(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EduTech Gen AI'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(aiChatProvider.notifier).resetMessages();
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final aiChatState = ref.watch(aiChatProvider);

          return aiChatState.when(
            data: (chatState) {
              return Column(
                children: [
                  Expanded(
                    child: ChatMessageList(
                      messages: <ChatMessage>[],
                      isLoading: chatState.isLoading,
                      scrollController: _scrollController,
                    ),
                  ),
                  ChatMessageInput(
                    controller: _messageController,
                    onSendMessage: _handleSendMessage,
                    isLoading: chatState.isLoading,
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $error'),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(aiChatProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
