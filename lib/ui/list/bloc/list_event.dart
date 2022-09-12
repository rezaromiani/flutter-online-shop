part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object> get props => [];
}

class ProductListStarted extends ListEvent {
  final int sort;

  const ProductListStarted({required this.sort});
  @override
  List<Object> get props => [sort];
}
