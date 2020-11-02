class MessageModel {
  String content;
  DateTime dateTime;

  MessageModel({this.content, this.dateTime});
}

class ChatMessageModel extends MessageModel {
  String from;
  String to;

  ChatMessageModel({this.from, this.to, String content, DateTime dateTime})
      : super(content: content, dateTime: dateTime);
}
