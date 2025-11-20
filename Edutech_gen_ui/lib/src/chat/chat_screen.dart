import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genui/genui.dart' hide ChatMessage;
import 'package:genui_firebase_ai/genui_firebase_ai.dart';
import 'package:education_gen_ui/src/providers/ai_provider.dart';
import 'package:education_gen_ui/src/chat/widgets/chat_message_input.dart';
import 'package:education_gen_ui/src/chat/widgets/chat_message_list.dart';

@RoutePage()
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final GenUiConversation conversation;

  final List<String> surfaceIds = <String>[];

  @override
  void initState() {
    super.initState();

    final Catalog catalog = CoreCatalogItems.asCatalog();
    final generator = FirebaseAiContentGenerator(
      catalog: catalog,
      systemInstruction:
          ''' You are a helpful Education Tutor that communicates by creating and updating
UI elements that appear in the chat. Your job is to help users understand concepts
by giving detailed explanations, providing YouTube search suggestions, summarizing videos,
and assessing knowledge through quizzes. You will always maintain the tutor role
and won't pretend to be other personas.''',
    );
    conversation = GenUiConversation(
      genUiManager: GenUiManager(catalog: catalog),
      contentGenerator: generator,
      onSurfaceAdded: _onSurfaceAdded,
      onSurfaceDeleted: _onSurfaceDeleted,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSurfaceAdded(SurfaceAdded surface) {
    setState(() {
      surfaceIds.add(surface.surfaceId);
    });
  }

  void _onSurfaceDeleted(SurfaceRemoved surface) {
    setState(() {
      surfaceIds.remove(surface.surfaceId);
    });
  }

  // void _scrollToBottom() {
  //   if (_scrollController.hasClients) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       _scrollController.animateTo(
  //         _scrollController.position.maxScrollExtent,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     });
  //   }
  // }

  Future<void> _handleSendMessage(String text) async {
    final msg = text.trim();
    if (msg.isNotEmpty) {
      _messageController.clear();
      ref.read(aiChatProvider.notifier).sendMessage(text);
      return conversation.sendRequest(UserMessage.text(text));
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
                      messages: chatState.messages,
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
