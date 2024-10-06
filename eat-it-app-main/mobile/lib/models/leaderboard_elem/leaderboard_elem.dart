class LeaderboardElemModel {
  int? position;
  String? name;
  int? points;
  String? id;

  LeaderboardElemModel({this.position, this.name, this.points, this.id});

  LeaderboardElemModel.fromJson(Map<String, dynamic> json) {
    position = json['position'];
    name = json['name'];
    points = json['points'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['position'] = position;
    data['name'] = name;
    data['points'] = points;
    data['id'] = id;
    return data;
  }
}