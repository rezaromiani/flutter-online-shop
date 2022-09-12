import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/repository/order_repository.dart';
import 'package:nike_store/theme.dart';
import 'package:nike_store/ui/receipt/bloc/payment_receipt_bloc.dart';
import 'package:nike_store/ui/widgets/loading.dart';

class PaymentReceiptScreen extends StatelessWidget {
  const PaymentReceiptScreen({Key? key, required this.orderID})
      : super(key: key);
  final String orderID;
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('رسید پرداخت')),
      body: BlocProvider(
        create: (context) =>
            PaymentReceiptBloc(orderRepository: orderRepository)
              ..add(PaymentReceiptStarted(orderID)),
        child: BlocBuilder<PaymentReceiptBloc, PaymentReceiptState>(
          builder: (context, state) {
            if (state is PaymentReceiptSuccess) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: themeData.dividerColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Text(
                          state.paymentReceiptData.purchaseSuccess
                              ? 'پرداخت با موفقیت انجام شد'
                              : "پرداخت ناموفق",
                          style: themeData.textTheme.headline6!
                              .apply(color: themeData.colorScheme.primary),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'وضعیت سفارش',
                              style: TextStyle(
                                  color: LightThemeColors.secondaryTextColor),
                            ),
                            Text(
                              state.paymentReceiptData.paymentStatus,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const Divider(
                          height: 32,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'مبلغ',
                              style: TextStyle(
                                  color: LightThemeColors.secondaryTextColor),
                            ),
                            Text(
                              state.paymentReceiptData.payablePrice
                                  .withPriceLabel(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: const Text('بازگشت به صفحه اصلی'))
                ],
              );
            } else if (state is PaymentReceiptLoading) {
              return AppLoading();
            } else if (state is PaymentReceiptError) {
              return Center(
                child: Text(state.appException.message),
              );
            } else {
              throw Exception("state is not supported");
            }
          },
        ),
      ),
    );
  }
}
