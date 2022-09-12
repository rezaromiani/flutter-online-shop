import 'package:flutter/material.dart';
import 'package:nike_store/common/utils.dart';

class PriceInfo extends StatelessWidget {
  const PriceInfo(
      {Key? key,
      required this.payablePrice,
      required this.totalPrice,
      required this.shippingCost})
      : super(key: key);
  final int payablePrice;
  final int totalPrice;
  final int shippingCost;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 12, 0),
          child: Text(
            "جزئیات خرید",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(12, 6, 12, 24),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
              ],
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 12, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("مبلغ کل خرید"),
                     RichText(
                        text: TextSpan(
                            text: totalPrice.separateByComma,
                            style: DefaultTextStyle.of(context)
                                .style
                                .copyWith(fontSize: 15),
                            children: const [
                          TextSpan(
                              text: " تومان",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal))
                        ]))
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 12, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("هزینه ارسال"),
                    Text(shippingCost.withPriceLabel())
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 12, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("مبلغ کل خرید"),
                    RichText(
                        text: TextSpan(
                            text: payablePrice.separateByComma,
                            style: DefaultTextStyle.of(context)
                                .style
                                .copyWith(fontWeight: FontWeight.bold,fontSize: 16),
                            children: const [
                          TextSpan(
                              text: " تومان",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal))
                        ]))
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
