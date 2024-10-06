class BasketItem {
  String? foodType;
  String? foodName;
  int? points;
  String? barcode;
  String? id;

  BasketItem(
      {this.foodType, this.foodName, this.points, this.id, this.barcode});

  BasketItem.fromJson(Map<String, dynamic> json) {
    foodType = json['foodType'];
    foodName = json['foodName'];
    points = json['points'];
    id = json['id'];
    barcode = json['barcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['foodType'] = foodType;
    data['foodName'] = foodName;
    data['points'] = points;
    data['id'] = id;
    data['barcode'] = barcode;
    return data;
  }
}
