class MessageModel {
  String message;
  String dateTime;

  MessageModel({this.message, this.dateTime});

  MessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['dateTime'] = this.dateTime;
    return data;
  }
}

class ChatMessageModel extends MessageModel {
  String from;

  ChatMessageModel({this.from, String message, String dateTime})
      : super(message: message, dateTime: dateTime);

   ChatMessageModel.fromJson(Map<String,dynamic> json) {
     from = json['from'];
     message = json['message'];
     dateTime = json['dateTime'];
   }
}
