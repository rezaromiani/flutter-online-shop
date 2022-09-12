part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartStarted extends CartEvent {
  final AuthInfo? authInfo;
  final bool isRefreshing;
  const CartStarted(this.authInfo, {this.isRefreshing = false});
}

class CartRefresh extends CartEvent {
  final AuthInfo? authInfo;

  const CartRefresh(this.authInfo);
}

class CartAuthInfoChange extends CartEvent {
  final AuthInfo? authInfo;

  const CartAuthInfoChange(this.authInfo);
}

class CartDeleteButtonClicked extends CartEvent {
  final int cartItemId;

  const CartDeleteButtonClicked(this.cartItemId);

  @override
  List<Object> get props => [cartItemId];
}

class CartIncreaseItem extends CartEvent implements IChangeCartItem {
  @override
  final int cartItemId;

  const CartIncreaseItem(this.cartItemId);

  @override
  List<Object> get props => [cartItemId];
}

class CartDecreaseItem extends CartEvent implements IChangeCartItem {
  @override
  final int cartItemId;

  const CartDecreaseItem(this.cartItemId);

  @override
  List<Object> get props => [cartItemId];
}

abstract class IChangeCartItem {
  final int cartItemId = 0;
}
