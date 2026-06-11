class Product {
  final int id;
  final String name;
  final double purchasePrice;
  final double salePrice;
  final double profit;
  final int? categoryId;
  final String? categoryName;

  Product({
    required this.id,
    required this.name,
    required this.purchasePrice,
    required this.salePrice,
    required this.profit,
    this.categoryId,
    this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      purchasePrice: (json['purchase_price'] as num).toDouble(),
      salePrice: (json['sale_price'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
      categoryId: json['category_id'] as int?,
      categoryName: json['category_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'purchase_price': purchasePrice,
      'sale_price': salePrice,
      'profit': profit,
      'category_id': categoryId,
      'category_name': categoryName,
    };
  }
}
