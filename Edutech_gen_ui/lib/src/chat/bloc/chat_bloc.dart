import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<UserRequest>(userRequest);
  }

  void userRequest(UserRequest event, Emitter<ChatState> emit) {
    emit(ChatLoadingState());
  }
}
