import 'package:equatable/equatable.dart';
import 'package:flutter_app_signalr_chat/bloc/chat_user_bloc/model.dart';

class ChatUserState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ChatUserLoaded extends ChatUserState {
  final ChatUserModel model;

  ChatUserLoaded(this.model);

  @override
  // TODO: implement props
  List<Object> get props => [model];
}

class ChatUserError extends ChatUserState {}

class ChatUserLoading extends ChatUserState {}
