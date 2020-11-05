class ChatUserModel {
  String nickname;
  String connectionId;
  String avatar;
  String email;

  ChatUserModel({this.nickname, this.connectionId, this.avatar, this.email});

  ChatUserModel.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    connectionId = json['connectionId'];
    avatar = json['avatar'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickname'] = this.nickname;
    data['connectionId'] = this.connectionId;
    data['avatar'] = this.avatar;
    data['email'] = this.email;
    return data;
  }
}
