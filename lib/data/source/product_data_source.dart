import 'package:dio/dio.dart';
import 'package:nike_store/common/http_response_validator.dart';

import '../product.dart';

abstract class IProductDataSource {
  Future<List<ProductEntity>> getAll(int sort);

  Future<List<ProductEntity>> search(String searchTerm);
}

class ProductRemoteDataSource with HttpResponseValidator implements IProductDataSource {
  final Dio httpClient;

  ProductRemoteDataSource(this.httpClient);

  @override
  Future<List<ProductEntity>> getAll(int sort) async {
    final response = await httpClient.get("product/list?sort=$sort");
    validateResponse(response);
    final products = <ProductEntity>[];
    for (var element in (response.data as List)) {
      products.add(ProductEntity.fromJson(element));
    }
    return products;
  }

  @override
  Future<List<ProductEntity>> search(String searchTerm) async {
    final response = await httpClient.get("product/list?q=$searchTerm");
    validateResponse(response);
    final products = <ProductEntity>[];
    for (var element in (response.data as List)) {
      products.add(ProductEntity.fromJson(element));
    }
    return products;
  }


}
