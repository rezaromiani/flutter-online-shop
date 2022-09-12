import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/order.dart';
import 'package:nike_store/data/repository/order_repository.dart';
import 'package:nike_store/ui/cart/price_info.dart';
import 'package:nike_store/ui/payment_webview.dart';
import 'package:nike_store/ui/receipt/payment_receipt.dart';
import 'package:nike_store/ui/shipping/bloc/shipping_bloc.dart';

class ShippingSreen extends StatefulWidget {
  ShippingSreen(
      {Key? key,
      required this.payablePrice,
      required this.totalPrice,
      required this.shippingCost})
      : super(key: key);
  final int payablePrice;
  final int totalPrice;
  final int shippingCost;

  @override
  State<ShippingSreen> createState() => _ShippingSreenState();
}

class _ShippingSreenState extends State<ShippingSreen> {
  final TextEditingController firstNameController =
      TextEditingController(text: "رضا");

  final TextEditingController lastNameController =
      TextEditingController(text: "محمدی");

  final TextEditingController postalCodeNameController =
      TextEditingController(text: "7896325478");

  final TextEditingController mobileController =
      TextEditingController(text: '09123456789');

  final TextEditingController addressController = TextEditingController(
      text: 'لورم ایپسوم متن ساختگی با تولید سادگی نامفه،ت،');

  late StreamSubscription subscription;

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "تحویل گیرنده",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      body: BlocProvider(
        create: (context) {
          final bloc = ShippingBloc(orderRepository: orderRepository);
          subscription = bloc.stream.listen((event) {
            if (event is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(event.appException.message)));
            } else if (event is ShippingSuccess) {
              if (event.result.bankGateway.isNotEmpty) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PaymentGateWayScreen(
                    bankGateWayUrl: event.result.bankGateway,
                  ),
                ));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PaymentReceiptScreen(
                    orderID: event.result.orderId.toString(),
                  ),
                ));
              }
            }
          });

          return bloc;
        },
        child: SingleChildScrollView(
            physics: defaultScrollPhysics,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(label: Text("نام")),
                    controller: firstNameController,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    decoration:
                        const InputDecoration(label: Text("نام خانوادگی")),
                    controller: lastNameController,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    decoration: const InputDecoration(label: Text("کدپستی")),
                    controller: postalCodeNameController,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    decoration:
                        const InputDecoration(label: Text("شماره تماس")),
                    controller: mobileController,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    decoration: const InputDecoration(label: Text("آدرس")),
                    controller: addressController,
                  ),
                  PriceInfo(
                    totalPrice: widget.totalPrice,
                    payablePrice: widget.payablePrice,
                    shippingCost: widget.shippingCost,
                  ),
                  BlocBuilder<ShippingBloc, ShippingState>(
                    builder: (context, state) {
                      return state is ShippingLoading
                          ? const Center(
                              child: CupertinoActivityIndicator(),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      BlocProvider.of<ShippingBloc>(context)
                                          .add(ShippingCreateOrder(
                                              CreateOrderParams(
                                                  firstNameController.text,
                                                  lastNameController.text,
                                                  mobileController.text,
                                                  postalCodeNameController.text,
                                                  addressController.text,
                                                  PaymentMethod.online)));
                                    },
                                    child: const Text("پرداخت اینترنتی")),
                                const SizedBox(
                                  width: 8,
                                ),
                                OutlinedButton(
                                    onPressed: () {
                                      BlocProvider.of<ShippingBloc>(context)
                                          .add(ShippingCreateOrder(
                                              CreateOrderParams(
                                                  firstNameController.text,
                                                  lastNameController.text,
                                                  mobileController.text,
                                                  postalCodeNameController.text,
                                                  addressController.text,
                                                  PaymentMethod
                                                      .cashOnDelivery)));
                                    },
                                    child: const Text("پرداخت در محل"))
                              ],
                            );
                    },
                  )
                ],
              ),
            )),
      ),
    );
  }
}
