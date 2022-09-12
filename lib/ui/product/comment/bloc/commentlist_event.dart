part of 'commentlist_bloc.dart';

abstract class CommentlistEvent extends Equatable {
  const CommentlistEvent();

  @override
  List<Object> get props => [];
}

class CommentListStarted extends CommentlistEvent {}
