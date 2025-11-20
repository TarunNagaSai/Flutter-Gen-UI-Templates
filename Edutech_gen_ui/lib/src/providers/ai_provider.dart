import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:education_gen_ui/src/models/chat_message.dart';
import 'package:education_gen_ui/src/const/constents.dart';

part 'ai_provider.g.dart';

class AiChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const AiChatState({
    required this.messages,
    this.isLoading = false,
    this.error,
  });

  AiChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

@riverpod
class AiChat extends _$AiChat {
  String conversationSummary = "-";
  late GenerativeModel model;
  final String reply = "reply";
  final String summary = "summary";
  late SharedPreferences prefs;
  final String preferenceMessages = "messages";
  final String preferenceSummary = "summary";

  @override
  Future<AiChatState> build() async {
    // Initialize
    try {
      prefs = await SharedPreferences.getInstance();
      final messages = await _loadChat();
      model = FirebaseAI.googleAI().generativeModel(
        model: AppConstants.geminiModel,
      );
      
      if (messages.isEmpty) {
        final initialMessage = await _getInitialMessage();
        return AiChatState(messages: [initialMessage]);
      }
      
      return AiChatState(messages: messages);
    } catch (e) {
      return AiChatState(
        messages: [ChatMessage(message: "Error: $e", isUser: false)],
        error: e.toString(),
      );
    }
  }

  Future<ChatMessage> _getInitialMessage() async {
    final Map<String, dynamic> response = await _generateMessage(
      message: 'Hello',
    );
    final message = ChatMessage(
      message: response[reply]!.toString(),
      isUser: false,
    );
    conversationSummary = response[summary]!.toString();
    await _saveChat([message]);
    return message;
  }

  Future<List<ChatMessage>> _loadChat() async {
    final List<String>? jsonMessages = prefs.getStringList(preferenceMessages);
    final String? savedSummary = prefs.getString(preferenceSummary);
    
    List<ChatMessage> messages = [];
    if (jsonMessages != null) {
      messages = jsonMessages
          .map((m) => ChatMessage.fromJson(jsonDecode(m) as Map<String, dynamic>))
          .toList();
    }
    conversationSummary = savedSummary ?? "";
    return messages;
  }

  Future<void> _saveChat(List<ChatMessage> messages) async {
    final List<String> jsonMessages = messages
        .map((m) => jsonEncode(m.toJson()))
        .toList();
    await prefs.setStringList(preferenceMessages, jsonMessages);
    await prefs.setString(preferenceSummary, conversationSummary);
  }

  Future<void> resetMessages() async {
    state = const AsyncValue.loading();
    
    try {
      conversationSummary = "-";
      await _saveChat([]);
      
      final initialMessage = await _getInitialMessage();
      state = AsyncValue.data(AiChatState(messages: [initialMessage]));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> sendMessage(String message) async {
    final currentState = state.value;
    if (currentState == null || currentState.isLoading) {
      return;
    }

    final userMessage = ChatMessage(message: message, isUser: true);
    final updatedMessages = [...currentState.messages, userMessage];
    
    // Update state with user message and loading
    state = AsyncValue.data(
      currentState.copyWith(messages: updatedMessages, isLoading: true),
    );

    try {
      // Add empty AI message that will be updated with streaming content
      final aiMessage = ChatMessage(message: "", isUser: false);
      final messagesWithAi = [...updatedMessages, aiMessage];
      final aiMessageIndex = messagesWithAi.length - 1;

      await _generateStreamingMessage(
        message: message,
        onChunk: (chunk) {
          // Update the last message with accumulated content
          final updatedList = List<ChatMessage>.from(messagesWithAi);
          updatedList[aiMessageIndex] = ChatMessage(message: chunk, isUser: false);
          
          state = AsyncValue.data(
            AiChatState(messages: updatedList, isLoading: true),
          );
        },
        onSummary: (newSummary) {
          conversationSummary = newSummary;
        },
      );

      final finalMessages = state.value?.messages ?? messagesWithAi;
      await _saveChat(finalMessages);
      
      state = AsyncValue.data(AiChatState(messages: finalMessages));
    } catch (e, stack) {
      final errorMessage = ChatMessage(
        message: "Error: ${e.toString()}",
        isUser: false,
      );
      final messagesWithError = [...updatedMessages, errorMessage];
      
      state = AsyncValue.data(
        AiChatState(
          messages: messagesWithError,
          error: e.toString(),
        ),
      );
    }
  }

  Future<Map<String, dynamic>> _generateMessage({
    required String message,
  }) async {
    final response = await model.generateContent([
      Content.text(
        "You are a travel plan guide. "
        "Update the conversation summary so it stays under 150 words. ",
      ),
      Content.text(
        "The conversation so far (summary): $conversationSummary "
        "User message: $message ",
      ),
      Content.text("""
        Respond in this exact JSON format:
        {
          "$reply": "<your reply to the user>",
          "$summary": "<updated summary>"
        }
        """),
    ]);

    final raw = response.text ?? "{}";

    try {
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(raw);
      if (jsonMatch != null) {
        final extracted = jsonMatch.group(0)!;
        final parsed = jsonDecode(extracted) as Map<String, dynamic>;
        return {
          reply: parsed[reply] ?? "Something went wrong",
          summary: parsed[summary] ?? conversationSummary,
        };
      }
      return {reply: "Something went wrong", summary: conversationSummary};
    } catch (e) {
      return {reply: "Something went wrong", summary: conversationSummary};
    }
  }

  Future<void> _generateStreamingMessage({
    required String message,
    required void Function(String) onChunk,
    required void Function(String) onSummary,
  }) async {
    final stream = model.generateContentStream([
      Content.text(
        "You are a travel plan guide. "
        "Respond naturally and conversationally. "
        "At the end of your response, add a line starting with 'SUMMARY:' followed by a brief summary of the conversation (under 150 words).",
      ),
      Content.text(
        "The conversation so far (summary): $conversationSummary "
        "User message: $message ",
      ),
    ]);

    String accumulatedText = "";

    await for (final chunk in stream) {
      final text = chunk.text ?? "";
      if (text.isNotEmpty) {
        accumulatedText += text;

        // Check if we have the summary marker
        if (accumulatedText.contains('SUMMARY:')) {
          final parts = accumulatedText.split('SUMMARY:');
          final responseText = parts[0].trim();
          final summaryText = parts.length > 1
              ? parts[1].trim()
              : conversationSummary;

          onChunk(responseText);
          onSummary(summaryText);
        } else {
          onChunk(accumulatedText);
        }
      }
    }

    // If no summary was found, keep the old one
    if (!accumulatedText.contains('SUMMARY:')) {
      onSummary(conversationSummary);
    }
  }
}
