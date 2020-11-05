import 'package:flutter_app_signalr_chat/bloc/chat_user_bloc/event.dart';
import 'package:flutter_app_signalr_chat/bloc/chat_user_bloc/satate.dart';
import 'package:flutter_app_signalr_chat/bloc/chat_user_bloc/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatUserBloc extends Bloc<ChatUserEvent, ChatUserState> {
  ChatUserBloc() : super(ChatUserLoading());

  @override
  Stream<ChatUserState> mapEventToState(ChatUserEvent event) async* {
    // TODO: implement mapEventToState
    if (event is GetChatUser) {
      yield* mapGetChatUserToState(event);
    }
  }

  Stream<ChatUserState> mapGetChatUserToState(GetChatUser event) async* {
    var user =
        await ChatUsersService.getChatUserViaConnectionId(event.connectionId);
    if (user != null) {
      yield ChatUserLoaded(user);
    } else {
      yield ChatUserError();
    }
  }
}
