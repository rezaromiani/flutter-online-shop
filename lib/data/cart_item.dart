import 'package:nike_store/data/product.dart';

class CartItemEntity {
  final ProductEntity productEntity;
  final int id;
   int count;
  bool deleteButtonLoading = false;
  bool changeCountLoading = false;
  CartItemEntity.fromJson(Map<String, dynamic> json)
      : productEntity = ProductEntity.fromJson(json['product']),
        id = json['cart_item_id'],
        count = json['count'];

  static List<CartItemEntity> parseJsonArray(List<dynamic> jsonArray) {
    final List<CartItemEntity> cartItems = [];
    for (var element in jsonArray) {
      cartItems.add(CartItemEntity.fromJson(element));
    }
    return cartItems;
  }
}
