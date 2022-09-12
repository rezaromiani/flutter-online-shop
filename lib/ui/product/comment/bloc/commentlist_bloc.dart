import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store/common/exceptions.dart';
import 'package:nike_store/data/comment.dart';
import 'package:nike_store/data/repository/comment_repository.dart';

part 'commentlist_event.dart';
part 'commentlist_state.dart';

class CommentlistBloc extends Bloc<CommentlistEvent, CommentlistState> {
  final ICommentRepository repository;
  final int productId;
  CommentlistBloc({required this.productId, required this.repository})
      : super(CommentlistLoading()) {
    on<CommentlistEvent>((event, emit) async {
      if (event is CommentListStarted) {
        emit(CommentlistLoading());
        try {
          final comments = await repository.getAll(productId: productId);
          emit(CommentlistSuccess(comments));
        } catch (e) {
          emit(CommentlistError(e is AppException ? e : AppException()));
        }
      }
    });
  }
}
