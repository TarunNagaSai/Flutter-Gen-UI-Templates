part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class UserRequest extends ChatEvent {
  final String message;

  UserRequest({required this.message});
}

class ChatLoadingCompleted extends ChatEvent {}
