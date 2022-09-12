import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/cart_item.dart';
import 'package:nike_store/ui/widgets/image.dart';
import 'package:nike_store/ui/widgets/loading.dart';

import '../../theme.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
    required this.themeData,
    required this.item,
    required this.onDeleteButtonClick,
    required this.onIncreaseButtonClick,
    required this.onDecreaseButtonClick,
  }) : super(key: key);

  final ThemeData themeData;
  final CartItemEntity item;
  final GestureTapCallback onDeleteButtonClick;
  final GestureTapCallback onIncreaseButtonClick;
  final GestureTapCallback onDecreaseButtonClick;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      decoration: BoxDecoration(
          color: themeData.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                    width: 100,
                    height: 100,
                    child: ImageLoadingService(
                        imageUrl: item.productEntity.imageUrl)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item.productEntity.title,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text("تعداد"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: onIncreaseButtonClick,
                            icon: const Icon(CupertinoIcons.plus_rectangle)),
                        item.changeCountLoading
                            ? const CupertinoActivityIndicator()
                            : SizedBox(
                                width: 20,
                                child: Text(
                                  item.count.toString(),
                                  style: themeData.textTheme.headline6,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                        IconButton(
                          
                            onPressed: onDecreaseButtonClick,
                            icon: const Icon(CupertinoIcons.minus_rectangle)),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      item.productEntity.previousPrice.withPriceLabel(),
                      style: const TextStyle(
                          color: LightThemeColors.secondaryTextColor,
                          decoration: TextDecoration.lineThrough),
                    ),
                    Text(item.productEntity.price.withPriceLabel()),
                  ],
                )
              ],
            ),
          ),
          const Divider(
            height: 1,
          ),
          item.deleteButtonLoading
              ?const SizedBox(height: 46, child:  CupertinoActivityIndicator())
              : TextButton(
                  onPressed: onDeleteButtonClick,
                  child: const Text("حذف از سبد خرید"))
        ],
      ),
    );
  }
}
