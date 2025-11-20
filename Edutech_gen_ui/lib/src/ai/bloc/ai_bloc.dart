import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:education_gen_ui/src/models/chat_message.dart';
import 'package:education_gen_ui/src/const/constents.dart';

part 'ai_event.dart';
part 'ai_state.dart';

class AiBloc extends Bloc<AiEvent, AiState> {
  AiBloc() : super(AiInitial()) {
    on<InitializeAiEvent>(initializeAi);
    on<SendMessageEvent>(sendMessage);
    on<ResetMessagesEvent>(resetMessages);
  }

  final List<ChatMessage> messages = [];
  String conversationSummary = "-";
  late GenerativeModel model;
  final String reply = "reply";
  final String summary = "summary";
  late SharedPreferences prefs;
  final String preferenceMessages = "messages";
  final String preferenceSummary = "summary";

  Future<void> initializeAi(
    InitializeAiEvent event,
    Emitter<AiState> emit,
  ) async {
    emit(AiInitializingState());
    try {
      prefs = await SharedPreferences.getInstance();
      getChat();
      model = FirebaseAI.googleAI().generativeModel(
        model: AppConstants.geminiModel,
      );
      if (messages.isEmpty) {
        await getInitialMessage();
      }
      emit(AiLoadedState(messages: messages));
    } catch (e) {
      messages.add(ChatMessage(message: "Error: $e", isUser: false));
      emit(AiErrorState(error: e.toString(), messages: messages));
    }
  }

  Future<void> getInitialMessage() async {
    final Map<String, dynamic> response = await generateMessage(
      message: 'Hello',
    );
    messages.add(
      ChatMessage(message: response[reply]!.toString(), isUser: false),
    );
    conversationSummary = response[summary]!.toString();
    await saveChat();
  }

  void getChat() {
    final List<String>? jsonMessages = prefs.getStringList(preferenceMessages);
    final String? savedSummary = prefs.getString(preferenceSummary);
    messages.clear();
    if (jsonMessages != null) {
      messages.addAll(
        jsonMessages.map(
          (m) => ChatMessage.fromJson(jsonDecode(m) as Map<String, dynamic>),
        ),
      );
    }
    conversationSummary = savedSummary ?? "";
  }

  Future<void> saveChat() async {
    final List<String> jsonMessages = messages
        .map((m) => jsonEncode(m.toJson()))
        .toList();
    await prefs.setStringList(preferenceMessages, jsonMessages);
    await prefs.setString(preferenceSummary, conversationSummary);
  }

  Future<void> resetMessages(
    ResetMessagesEvent event,
    Emitter<AiState> emit,
  ) async {
    messages.clear();
    conversationSummary = "-";
    await saveChat();
    emit(AiLoadingState(messages: messages));
    await getInitialMessage();
    emit(AiLoadedState(messages: messages));
  }

  Future<void> sendMessage(
    SendMessageEvent event,
    Emitter<AiState> emit,
  ) async {
    if (state is AiLoadingState) {
      return;
    }

    messages.add(ChatMessage(message: event.message, isUser: true));
    emit(AiLoadingState(messages: messages));

    try {
      // Add empty AI message that will be updated with streaming content
      messages.add(ChatMessage(message: "", isUser: false));
      final aiMessageIndex = messages.length - 1;

      await generateStreamingMessage(
        message: event.message,
        onChunk: (chunk) {
          // Update the last message with accumulated content
          messages[aiMessageIndex] = ChatMessage(message: chunk, isUser: false);
          emit(AiLoadingState(messages: List.from(messages)));
        },
        onSummary: (newSummary) {
          conversationSummary = newSummary;
        },
      );

      await saveChat();
      emit(AiLoadedState(messages: messages));
    } catch (e) {
      messages.add(
        ChatMessage(message: "Error: ${e.toString()}", isUser: false),
      );
      emit(AiErrorState(error: e.toString(), messages: messages));
    }
  }

  Future<Map<String, dynamic>> generateMessage({
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

  Future<void> generateStreamingMessage({
    required String message,
    required Function(String) onChunk,
    required Function(String) onSummary,
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
