class UserData {
  String? email;
  String? userName;
  String? userText;
  int? points;

  UserData({this.email, this.userName, this.userText, this.points});

  UserData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    userName = json['userName'];
    userText = json['userText'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['userName'] = userName;
    data['userText'] = userText;
    data['points'] = points;
    return data;
  }
}