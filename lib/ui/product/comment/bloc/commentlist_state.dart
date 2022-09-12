part of 'commentlist_bloc.dart';

abstract class CommentlistState extends Equatable {
  const CommentlistState();

  @override
  List<Object> get props => [];
}

class CommentlistLoading extends CommentlistState {}

class CommentlistSuccess extends CommentlistState {
  final List<CommentEntity> comments;

  const CommentlistSuccess(this.comments);

  @override
  List<Object> get props => [comments];
}

class CommentlistError extends CommentlistState {
  final AppException exception;

  const CommentlistError(this.exception);
  @override
  List<Object> get props => [exception];
}
