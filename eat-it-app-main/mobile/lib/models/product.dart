import 'package:eat_it/models/category.dart';
import 'package:eat_it/models/parameter.dart';

class Product {
  final String brands;
  final String productName;
  final String quantity;
  final String productCategory;
  final double score;
  final double total;
  final String grade;
  final String barcode;

  final List<Category> categories;
  final List<Parameter> lifeCycleAnalysis;

  const Product({
    required this.brands,
    required this.productName,
    required this.quantity,
    required this.productCategory,
    required this.categories,
    required this.score,
    required this.total,
    required this.grade,
    required this.lifeCycleAnalysis,
    required this.barcode,
  });

  static Product fromJson(dynamic json) {
    var brands = json['brands'] ?? '';
    var barcode = json['code'] ?? '';
    var productName = json['product_name'] ?? '';
    var quantity = json['quantity'] ?? '';
    var productCategory = json['categories'] ?? '';

    var ecoscoreData = json['ecoscore_data'];

    var adjustments =
        ecoscoreData != null ? json['ecoscore_data']['adjustments'] : {};

    var agribalyse = ecoscoreData != null
        ? json['ecoscore_data']['agribalyse'].toList()
        : [];

    List<Category> categories = adjustments
            .map<Category>((category) => Category(
                value: category["value"],
                status: CategoryImpact.values.byName(category["status"]),
                title: category["header"],
                message: category["text"],
                icon: category["imagePath"]))
            .toList() ??
        List<Category>.empty();

    List<Parameter> lifeCycle = agribalyse
            .map<Parameter>((entry) =>
                Parameter(name: entry["name"], value: entry["value"]))
            .toList() ??
        List<Parameter>.empty();

    var score = ecoscoreData != null ? ecoscoreData['total'].toDouble() : 0.0;
    var total = ecoscoreData != null ? ecoscoreData['score'].toDouble() : 0.0;
    var grade = ecoscoreData != null ? ecoscoreData['grade'] : '';

    return Product(
        brands: brands,
        productName: productName,
        quantity: quantity,
        productCategory: productCategory,
        categories: categories,
        score: score,
        total: total,
        lifeCycleAnalysis: lifeCycle,
        grade: grade,
        barcode: barcode);
  }
}
