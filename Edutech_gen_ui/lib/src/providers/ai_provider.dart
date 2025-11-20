import 'package:education_gen_ui/src/const/education_system_prompt.dart';
import 'package:genui/genui.dart';
import 'package:genui_firebase_ai/genui_firebase_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      await _loadChat();
      return AiChatState(messages: []);
    } catch (e) {
      return AiChatState(messages: [], error: e.toString());
    }
  }

  void _onSurfaceAdded(SurfaceAdded surface) {}

  void _onSurfaceDeleted(SurfaceRemoved surface) {}

  Future<void> _loadChat() async {}

  Future<void> _saveChat(List<ChatMessage> messages) async {}

  Future<void> resetMessages() async {}

  Future<void> sendMessage(String message) async {
    // conversation.sendRequest(UserMessage.text(message));
  }
}
