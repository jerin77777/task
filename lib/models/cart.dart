import 'products.dart';

class CartItem {
  final int id;
  final Product product;
  final int qty;

  CartItem({
    required this.id,
    required this.product,
    this.qty = 1,
  });

  CartItem copyWith({int? id, Product? product, int? qty}) => CartItem(
        id: id ?? this.id,
        product: product ?? this.product,
        qty: qty ?? this.qty,
      );

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"],
        product: Product(
            id: json["product_id"],
            name: json["name"],
            image: json["image"],
            brand: json["brand"],
            price: json["price"],
            discount: json["discount"],
            originalPrice: json["originalPrice"]),
      );

  Map toJson() => {
        "id": this.id,
        "product_id": this.product.id,
        "name": this.product.name,
        "image": this.product.image,
        "brand": this.product.brand,
        "price": this.product.price,
        "discount": this.product.discount,
        "originalPrice": this.product.originalPrice
      };
}
