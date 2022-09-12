import 'package:nike_store/common/http_client.dart';
import 'package:nike_store/data/comment.dart';
import 'package:nike_store/data/repository/product_repository.dart';
import 'package:nike_store/data/source/comment_data_source.dart';

abstract class ICommentRepository {
  Future<List<CommentEntity>> getAll({required int productId});
}

final commentReposiory = CommentReposiory(CommentRemoteDataSource(httpClient));

class CommentReposiory implements ICommentRepository {
  final ICommentDataSource dataSource;

  CommentReposiory(this.dataSource);
  @override
  Future<List<CommentEntity>> getAll({required int productId}) =>
      dataSource.getAll(productId: productId);
}
