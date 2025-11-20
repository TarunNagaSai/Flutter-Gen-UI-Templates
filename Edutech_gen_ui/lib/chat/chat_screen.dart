import 'package:auto_route/auto_route.dart';
import 'package:education_gen_ui/chat/widgets/chat_empty_state.dart';
import 'package:education_gen_ui/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart' hide ChatMessage;
import 'package:genui_firebase_ai/genui_firebase_ai.dart';
import 'package:education_gen_ui/chat/bloc/ai_bloc.dart';
import 'package:education_gen_ui/chat/widgets/chat_message_input.dart';
import 'package:education_gen_ui/chat/widgets/chat_message_list.dart';

@RoutePage()
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
      systemInstruction: ''' 
      # Instructions

You are a helpful Education Tutor that communicates by creating and updating
UI Elements that appear in the chat. Your Job is to help user to understand the concept
By giving details explanation, provide a YouTube search key, analysis the video and explain
It and ask question related to the summery you give a final score to the user. You will always 
maintain the tutor role and won't pretend to be other personas

## Conversation Flow

Conversation should the following rough flow. In Each part of the flow,
You should display different types of UI elements to interact with the user.

-1)  Analysis: Analyze the user vocabulary and use Jargon Analysis to categorise the question into
Basic, Intermediate and Advanced. Examples: "What are those AI programs that talk?”(Basic),
"What's the difference between a hyperparameter and a parameter in ML?”(Intermediate),
How does the Gated Recurrent Unit (GRU) architecture address the vanishing gradient problem, 
particularly compared to the original LSTM?(Advanced).Ask clarifying questions if unsure of 
the user's level.

Generate output based on the level of explanation. You need to generate a key
phrase to search related videos in the youtube And also suggestion to learn similar topics. Maintain 
same level of explanation throughout the conversation.

-2) Youtube Video Summary: Users may provide a YouTube link and ask to summarise the video. Provide a detailed summary
And give key points with timestamps if possible. 
      ''',
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
              context.read<AiBloc>().add(ResetMessagesEvent(context: context));
            },
          ),
        ],
      ),
      body: BlocConsumer<AiBloc, AiState>(
        listener: (context, state) {
          // Auto-scroll when new content arrives during streaming
          if (state is AiLoadingState || state is AiLoadedState) {
            // _scrollToBottom();
          }
        },
        builder: (context, state) {
          List<ChatMessage> messages = [];
          bool isLoading = false;

          if (state is AiLoadedState) {
            messages = state.messages;
          } else if (state is AiLoadingState) {
            messages = state.messages;
            isLoading = true;
          } else if (state is AiErrorState) {
            messages = state.messages;
          } else if (state is AiInitializingState) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: surfaceIds.isEmpty
                    ? ChatEmptyState()
                    : ChatMessageList(
                        messages: messages,
                        isLoading: isLoading,
                        scrollController: _scrollController,
                        surfaceIds: surfaceIds,
                        conversation: conversation,
                      ),
              ),
              ChatMessageInput(
                controller: _messageController,
                onSendMessage: _handleSendMessage,
              ),
            ],
          );
        },
      ),
    );
  }
}
