import 'package:equatable/equatable.dart';

class ChatUserEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetChatUser extends ChatUserEvent {
  final String connectionId;

  GetChatUser(this.connectionId);

  @override
  // TODO: implement props
  List<Object> get props => [connectionId];
}
