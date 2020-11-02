class ChatUserModel {
  String email;
  bool isConnected;
  bool hasPartner;

  ChatUserModel({this.email, this.isConnected, this.hasPartner});

  ChatUserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    isConnected = json['isConnected'];
    hasPartner = json['hasPartner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['isConnected'] = this.isConnected;
    data['hasPartner'] = this.hasPartner;
    return data;
  }
}