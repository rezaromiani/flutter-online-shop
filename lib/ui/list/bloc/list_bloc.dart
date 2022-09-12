import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store/common/exceptions.dart';
import 'package:nike_store/data/product.dart';
import 'package:nike_store/data/repository/product_repository.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final IProductRepository productRepository;
  ListBloc(this.productRepository) : super(ListLoading()) {
    on<ListEvent>((event, emit) async {
      if (event is ProductListStarted) {
        emit(ListLoading());
        try {
          final result = await productRepository.getAll(event.sort);

          emit(ListSuccess(result, event.sort, ProductSort.names));
        } catch (e) {
          emit(ListError(AppException()));
        }
      }
    });
  }
}
