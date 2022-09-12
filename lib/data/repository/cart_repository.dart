import 'package:flutter/cupertino.dart';
import 'package:nike_store/common/http_client.dart';
import 'package:nike_store/data/add_to_cart_reponse.dart';
import 'package:nike_store/data/cart_response.dart';
import 'package:nike_store/data/source/cart_source.dart';

abstract class ICartRepository extends ICartDataSource {}

final CartRepository cartRepository =
    CartRepository(CartRemoteDataSource(httpClient));

class CartRepository extends ICartRepository {
  final ICartDataSource dataSource;
  static final ValueNotifier<int> cartItemCountNotifier = ValueNotifier(0);
  CartRepository(this.dataSource);
  @override
  Future<AddToCartResponse> add(int productId) async {
    final response = await dataSource.add(productId);
    count();
    return response;
  }

  @override
  Future<AddToCartResponse> changeCount(int cartItemId, int count) async {
    final response = await dataSource.changeCount(cartItemId, count);
    this.count();
    return response;
  }

  @override
  Future<int> count() async {
      final count = await dataSource.count();
      cartItemCountNotifier.value = count;
      return count;
  }

  @override
  Future<void> delete(int cartItemId) async {
    await dataSource.delete(cartItemId);
    await count();
  }

  @override
  Future<CartResponse> getAll() => dataSource.getAll();
}
