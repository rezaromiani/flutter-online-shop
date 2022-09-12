import 'package:nike_store/common/http_client.dart';
import 'package:nike_store/data/repository/product_repository.dart';
import 'package:nike_store/data/source/banner_data_source.dart';

import '../banner.dart';

final bannerRepository = BannerRepository(BannerRemoteDataSource(httpClient));

abstract class IBannerRepository {
  Future<List<BannerEntity>> getAll();
}

class BannerRepository implements IBannerRepository {
  final IBannerDataSource dataSource;

  BannerRepository(this.dataSource);

  @override
  Future<List<BannerEntity>> getAll() => dataSource.getAll();
}
