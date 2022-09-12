import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/cart_item.dart';
import 'package:nike_store/data/cart_response.dart';
import 'package:nike_store/data/repository/auth_repository.dart';
import 'package:nike_store/data/repository/cart_repository.dart';
import 'package:nike_store/theme.dart';
import 'package:nike_store/ui/auth/auth.dart';
import 'package:nike_store/ui/cart/bloc/cart_bloc.dart';
import 'package:nike_store/ui/cart/price_info.dart';
import 'package:nike_store/ui/shipping/shipping.dart';
import 'package:nike_store/ui/widgets/empty_view.dart';
import 'package:nike_store/ui/widgets/error.dart';
import 'package:nike_store/ui/widgets/image.dart';
import 'package:nike_store/ui/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartBloc? cartBloc;
  final RefreshController _refreshController = RefreshController();
  late StreamSubscription? streamSubscription;
  bool showFloatActionButton = false;
  @override
  void initState() {
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
    super.initState();
  }

  @override
  void dispose() {
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);

    cartBloc?.close();
    streamSubscription?.cancel();
    super.dispose();
  }

  void authChangeNotifierListener() {
    cartBloc?.add(CartAuthInfoChange(AuthRepository.authChangeNotifier.value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: showFloatActionButton,
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: FloatingActionButton.extended(
              onPressed: () {
                final state = cartBloc?.state;
                if (state is CartSuccess) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return ShippingSreen(
                        totalPrice: state.cartResponse.totalPrice,
                        payablePrice: state.cartResponse.payablePrice,
                        shippingCost: state.cartResponse.shippingCost,
                      );
                    },
                  ));
                }
              },
              label: const Text("پرداخت")),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
        title: Text(
          "سبد خرید",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      body: BlocProvider<CartBloc>(
        create: (context) {
          final bloc = CartBloc(cartRepository);
          cartBloc = bloc;
          bloc.add(CartStarted(AuthRepository.authChangeNotifier.value));

          streamSubscription = bloc.stream.listen((state) {
            if (state is CartSuccess) {
              setState(() {
                showFloatActionButton = true;
              });
            } else {
              setState(() {
                showFloatActionButton = false;
              });
            }
            if (_refreshController.isRefresh) {
              if (state is CartSuccess) {
                _refreshController.refreshCompleted();
              }
            }
          });
          return bloc;
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return AppLoading();
            } else if (state is CartAuthRequired) {
              return _cartAuthRequiredState(context);
            } else if (state is CartSuccess) {
              return CartBody(
                cartResponse: state.cartResponse,
                refreshController: _refreshController,
                onrefresh: () {
                  cartBloc?.add(CartStarted(
                      AuthRepository.authChangeNotifier.value,
                      isRefreshing: true));
                },
              );
            } else if (state is CartError) {
              return AppErrorShow(
                appException: state.appException,
                onTap: () {
                  BlocProvider.of<CartBloc>(context).add(
                      CartRefresh(AuthRepository.authChangeNotifier.value));
                },
              );
            } else if (state is CartEmpty) {
              return _cartEmptyState();
            } else {
              throw Exception("current state is not valid!");
            }
          },
        ),
      ),
    );
  }

  EmptyView _cartAuthRequiredState(BuildContext context) {
    return EmptyView(
      message: 'برای مشاهده ی سبد خرید ابتدا وارد حساب کاربری خود شوید',
      image: SvgPicture.asset(
        "assets/svg/unauthenticated.svg",
        height: 180,
      ),
      callToAction: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AuthScreen()));
          },
          child: const Text('ورود به حساب کاربری')),
    );
  }

  EmptyView _cartEmptyState() {
    return EmptyView(
        message: 'تاکنون هیچ محصولی به سبد خرید خود اضافه نکرده اید',
        image: SvgPicture.asset(
          "assets/svg/cart_empty_state.svg",
          height: 180,
        ));
  }
}

class CartBody extends StatelessWidget {
  const CartBody(
      {Key? key,
      required this.cartResponse,
      required this.refreshController,
      required this.onrefresh})
      : super(key: key);
  final CartResponse cartResponse;
  final RefreshController refreshController;
  final Function() onrefresh;
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 56),
      child: SmartRefresher(
        physics: defaultScrollPhysics,
        controller: refreshController,
        onRefresh: onrefresh,
        child: ListView.builder(
          physics: defaultScrollPhysics,
          itemCount: cartResponse.cartItems.length + 1,
          itemBuilder: (context, index) {
            if (cartResponse.cartItems.length > index) {
              final CartItemEntity item = cartResponse.cartItems[index];

              return CartItem(
                themeData: themeData,
                item: item,
                onIncreaseButtonClick: () {
                  BlocProvider.of<CartBloc>(context)
                      .add(CartIncreaseItem(item.id));
                },
                onDecreaseButtonClick: () {
                  BlocProvider.of<CartBloc>(context)
                      .add(CartDecreaseItem(item.id));
                },
                onDeleteButtonClick: () {
                  BlocProvider.of<CartBloc>(context)
                      .add(CartDeleteButtonClicked(item.id));
                },
              );
            } else {
              return PriceInfo(
                totalPrice: cartResponse.totalPrice,
                payablePrice: cartResponse.payablePrice,
                shippingCost: cartResponse.shippingCost,
              );
            }
          },
        ),
      ),
    );
  }
}
