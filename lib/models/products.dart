extension DynamicToDouble on dynamic {
  double toDouble() {
    if (this is int) {
      return (this as int).toDouble();
    } else if (this is double || this is num) {
      return double.parse(this.toStringAsFixed(2));
    }
    return 0.0;
  }
}

extension DoubleToFix on double {
  double fix2() {
    return double.parse(this.toStringAsFixed(2));
  }
}

class Product {
  final int id;
  final String name;
  final String image;
  final String brand;
  final double price;
  final double discount;
  final double originalPrice;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.brand,
    required this.price,
    required this.discount,
    required this.originalPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    double discount = json['discountPercentage'].toDouble();
    if (discount < 1.0) {
      discount = json['discountPercentage'] * 100;
    }
    double newPrice = json['price'].toDouble() - ((json['price'].toDouble()) / discount);
    return Product(
      id: json['id'],
      name: json['title'],
      image: json['thumbnail'],
      brand: json['brand'] ?? "",
      originalPrice: json['price'].toDouble(),
      discount: discount.fix2(),
      price: newPrice.fix2(),
    );
  }
  toJson() => {
        "id": this.id,
        "name": this.name,
        "image": this.image,
        "brand": this.brand,
        "originalPrice": this.originalPrice,
        "discount": this.discount,
        "price": this.price,
      };
}
