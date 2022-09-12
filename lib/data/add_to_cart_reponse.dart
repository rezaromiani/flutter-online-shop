class AddToCartResponse {
  final int productId;
  final int cartItemId;
  final int count;

  AddToCartResponse(this.productId, this.cartItemId, this.count);

  AddToCartResponse.fromJson(Map<String, dynamic> json)
      : cartItemId = json['id'],
        productId = json['product_id'],
        count = json['count'];
}
