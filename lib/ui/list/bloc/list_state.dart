part of 'list_bloc.dart';

abstract class ListState extends Equatable {
  const ListState();

  @override
  List<Object> get props => [];
}

class ListSuccess extends ListState {
  final List<ProductEntity> products;
  final int sort;
  final List<String> sortNames;
  const ListSuccess(this.products, this.sort, this.sortNames);
  @override
  List<Object> get props => [products, sort];
}

class ListLoading extends ListState {}

class ListError extends ListState {
  final AppException appException;

  const ListError(this.appException);

  @override
  List<Object> get props => [appException];
}
