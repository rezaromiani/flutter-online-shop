import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/repository/order_repository.dart';
import 'package:nike_store/ui/order/bloc/order_history_bloc.dart';
import 'package:nike_store/ui/widgets/error.dart';
import 'package:nike_store/ui/widgets/image.dart';
import 'package:nike_store/ui/widgets/loading.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderHistoryBloc(orderRepository)..add(OrderHistoryStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("سوابق سفارش"),
        ),
        body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistorySuccess) {
              final orders = state.orders;
              return ListView.builder(
                physics: defaultScrollPhysics,
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Theme.of(context).dividerColor, width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 56,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("شماره سفارش"),
                                  Text(order.id.toString()),
                                ]),
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                        SizedBox(
                          height: 56,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("مبلغ سفارش"),
                                  Text(order.payablePrice.withPriceLabel()),
                                ]),
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                        SizedBox(
                          height: 132,
                          child: ListView.builder(
                            physics: defaultScrollPhysics,
                            scrollDirection: Axis.horizontal,
                            itemCount: order.items.length,
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            itemBuilder: (context, index) {
                              return Container(
                                width: 100,
                                height: 100,
                                margin:
                                    const EdgeInsets.only(left: 6, right: 6),
                                child: ImageLoadingService(
                                    imageUrl: order.items[index].imageUrl,
                                    borderRadius: BorderRadius.circular(8)),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            } else if (state is OrderHistoryLoading) {
              return AppLoading();
            } else if (state is OrderHistoryError) {
              return AppErrorShow(
                appException: state.exception,
                onTap: () {},
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
