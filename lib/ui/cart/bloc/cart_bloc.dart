import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:nike_store/common/exceptions.dart';
import 'package:nike_store/data/auth_info.dart';
import 'package:nike_store/data/cart_response.dart';
import 'package:nike_store/data/repository/cart_repository.dart';
import 'package:nike_store/ui/cart/cart_item.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository cartRepository;
  CartBloc(this.cartRepository) : super(CartLoading()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStarted) {
        await _cartStarted(event, emit);
      } else if (event is CartAuthInfoChange) {
        await _cartAuthChange(emit, event);
      } else if (event is CartDeleteButtonClicked) {
        await _deleteCartItem(emit, event);
      } else if (event is CartIncreaseItem || event is CartDecreaseItem) {
        await _changeItemCount(emit, (event as IChangeCartItem));
      }
    });
  }
  Future<void> _loadCartItem(Emitter<CartState> emit, bool isRefreshing) async {
    try {
      if (!isRefreshing) {
        emit(CartLoading());
      }
      final CartResponse cartResponse = await cartRepository.getAll();
      if (cartResponse.cartItems.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartSuccess(cartResponse));
      }
    } catch (e) {
      emit(CartError(e is AppException ? e : AppException()));
    }
  }

  Future<void> _cartStarted(CartStarted event, Emitter<CartState> emit) async {
    final AuthInfo? authInfo = event.authInfo;
    if (authInfo == null || authInfo.accessToken.isEmpty) {
      emit(CartAuthRequired());
    } else {
      await _loadCartItem(emit, event.isRefreshing);
    }
  }

  CartSuccess _calculatePriceInfo(CartResponse cartResponse) {
    int totalPrice = 0;
    int payablePrice = 0;
    int shippingCost = 0;

    for (var element in cartResponse.cartItems) {
      totalPrice += element.productEntity.previousPrice * element.count;
      payablePrice += element.productEntity.price * element.count;
    }
    shippingCost = payablePrice >= 250000 ? 0 : 30000;
    cartResponse.totalPrice = totalPrice;
    cartResponse.payablePrice = payablePrice;
    cartResponse.shippingCost = shippingCost;
    return CartSuccess(cartResponse);
  }

  Future<void> _cartAuthChange(
      Emitter<CartState> emit, CartAuthInfoChange event) async {
    if (event.authInfo == null || event.authInfo!.accessToken.isEmpty) {
      emit(CartAuthRequired());
    } else {
      if (state is CartAuthRequired) {
        await _loadCartItem(emit, false);
      }
    }
  }

  Future<void> _deleteCartItem(
      Emitter<CartState> emit, CartDeleteButtonClicked event) async {
    try {
      if (state is CartSuccess) {
        final successState = (state as CartSuccess);
        final index = successState.cartResponse.cartItems
            .indexWhere((element) => element.id == event.cartItemId);
        successState.cartResponse.cartItems[index].deleteButtonLoading = true;
        emit(CartSuccess(successState.cartResponse));
      }

      await cartRepository.delete(event.cartItemId);
      if (state is CartSuccess) {
        final successState = (state as CartSuccess);

        successState.cartResponse.cartItems
            .removeWhere((element) => element.id == event.cartItemId);
        if (successState.cartResponse.cartItems.isEmpty) {
          emit(CartEmpty());
        } else {
          emit(_calculatePriceInfo(successState.cartResponse));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _changeItemCount(
      Emitter<CartState> emit, IChangeCartItem event) async {
    try {
      if (state is CartSuccess) {
        final successState = (state as CartSuccess);
        final index = successState.cartResponse.cartItems
            .indexWhere((element) => element.id == event.cartItemId);

        successState.cartResponse.cartItems[index].changeCountLoading = true;
        emit(CartSuccess(successState.cartResponse));
        final newCount = event is CartIncreaseItem
            ? successState.cartResponse.cartItems[index].count + 1
            : successState.cartResponse.cartItems[index].count - 1;
        if (newCount > 0) {
          await cartRepository.changeCount(event.cartItemId, newCount);
          successState.cartResponse.cartItems
              .firstWhere((element) => element.id == event.cartItemId)
              .count = newCount;
          emit(_calculatePriceInfo(successState.cartResponse));
        }
        successState.cartResponse.cartItems[index].changeCountLoading = false;
        emit(CartSuccess(successState.cartResponse));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
