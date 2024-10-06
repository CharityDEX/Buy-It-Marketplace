class ConfirmPurchaseItem {
  int? qnty; 
  int? points;
  String? barcode;

  ConfirmPurchaseItem({this.qnty, this.barcode, this.points });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qnty'] = qnty;
    data['points'] = points;
    data['barcode'] = barcode;
    return data;
  }
}