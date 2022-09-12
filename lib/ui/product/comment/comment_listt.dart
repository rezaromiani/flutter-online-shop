import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/data/repository/comment_repository.dart';
import 'package:nike_store/ui/product/comment/bloc/commentlist_bloc.dart';
import 'package:nike_store/ui/product/comment/comment.dart';
import 'package:nike_store/ui/widgets/error.dart';
import 'package:nike_store/ui/widgets/loading.dart';

class CommentList extends StatelessWidget {
  const CommentList({Key? key, required this.productId}) : super(key: key);
  final int productId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) {
      final CommentlistBloc bloc =
          CommentlistBloc(productId: productId, repository: commentReposiory);
      bloc.add(CommentListStarted());
      return bloc;
    }, child: BlocBuilder<CommentlistBloc, CommentlistState>(
      builder: (context, state) {
        if (state is CommentlistSuccess) {
          return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return CommentItem(comment: state.comments[index]);
          }, childCount: state.comments.length));
        } else if (state is CommentlistLoading) {
          return SliverToBoxAdapter(
            child: AppLoading(),
          );
        } else if (state is CommentlistError) {
          return SliverToBoxAdapter(
            child: AppErrorShow(
              appException: state.exception,
              onTap: () {
                BlocProvider.of<CommentlistBloc>(context)
                    .add(CommentListStarted());
              },
            ),
          );
        } else {
          throw Exception('state is not supported');
        }
      },
    ));
  }
}
