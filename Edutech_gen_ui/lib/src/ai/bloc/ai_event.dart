part of 'ai_bloc.dart';

@immutable
sealed class AiEvent {}

class InitializeAiEvent extends AiEvent {
  final BuildContext context;
  
  InitializeAiEvent({required this.context});
}

class SendMessageEvent extends AiEvent {
  final String message;
  final BuildContext context;
  
  SendMessageEvent({
    required this.message,
    required this.context,
  });
}

class ResetMessagesEvent extends AiEvent {
  final BuildContext context;
  
  ResetMessagesEvent({required this.context});
}
