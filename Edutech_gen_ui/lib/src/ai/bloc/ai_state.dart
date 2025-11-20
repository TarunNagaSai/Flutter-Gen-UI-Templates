part of 'ai_bloc.dart';

@immutable
sealed class AiState {}

final class AiInitial extends AiState {}

class AiInitializingState extends AiState {}

class AiLoadingState extends AiState {
  final List<ChatMessage> messages;
  
  AiLoadingState({required this.messages});
}

class AiLoadedState extends AiState {
  final List<ChatMessage> messages;
  
  AiLoadedState({required this.messages});
}

class AiErrorState extends AiState {
  final List<ChatMessage> messages;
  final String error;
  
  AiErrorState({
    required this.error,
    required this.messages,
  });
}
