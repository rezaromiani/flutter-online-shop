import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store/common/exceptions.dart';
import 'package:nike_store/data/repository/cart_repository.dart';
import 'package:nike_store/data/repository/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ICartRepository cartRepository;
  ProductBloc(this.cartRepository) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      if (event is CartAddButtonClick) {
        emit(ProductAddToCartButtonLoading());
        try {
          await cartRepository.add(event.productId);
          emit(ProductAddToCartSuccess());
        } catch (e) {
          emit(ProductAddToCartError(e is AppException ? e : AppException()));
        }
      }
    });
  }
}
