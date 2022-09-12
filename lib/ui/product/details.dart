import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/product.dart';
import 'package:nike_store/data/repository/cart_repository.dart';
import 'package:nike_store/theme.dart';
import 'package:nike_store/ui/product/bloc/product_bloc.dart';
import 'package:nike_store/ui/product/comment/comment_listt.dart';
import 'package:nike_store/ui/widgets/image.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);
  final ProductEntity product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ScrollController _scrollController;
  StreamSubscription<ProductState>? stateSubscription;
  final GlobalKey<ScaffoldMessengerState> _scafoldKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _isSliverAppBarExpanded;
        });
      });
  }

  @override
  void dispose() {
    stateSubscription?.cancel();
    _scafoldKey.currentState?.dispose();
    super.dispose();
  }

  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset >
            ((MediaQuery.of(context).size.width * 0.8) - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<ProductBloc>(
        create: (context) {
          final bloc = ProductBloc(cartRepository);

          stateSubscription = bloc.stream.listen((state) {
            if (state is ProductAddToCartSuccess) {
              _scafoldKey.currentState?.showSnackBar(const SnackBar(
                  content: Text('با موفقیت به سبد خرید شما اضافه شد')));
            } else if (state is ProductAddToCartError) {
              _scafoldKey.currentState?.showSnackBar(
                  SnackBar(content: Text(state.exception.message)));
            }
          });
          return bloc;
        },
        child: ScaffoldMessenger(
          key: _scafoldKey,
          child: Scaffold(
            floatingActionButton: SizedBox(
              width: MediaQuery.of(context).size.width - 48,
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  return FloatingActionButton.extended(
                      onPressed: () {
                        BlocProvider.of<ProductBloc>(context)
                            .add(CartAddButtonClick(widget.product.id));
                      },
                      label: (state is ProductAddToCartButtonLoading)
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : const Text("افزودن به سبد خرید"));
                },
              ),
            ),
            body: CustomScrollView(
              physics: defaultScrollPhysics,
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  title: _isSliverAppBarExpanded
                      ? Text(widget.product.title)
                      : null,
                  pinned: true,
                  snap: false,
                  floating: false,
                  expandedHeight: MediaQuery.of(context).size.width * 0.8,
                  flexibleSpace: FlexibleSpaceBar(
                    background:
                        ImageLoadingService(imageUrl: widget.product.imageUrl),
                  ),
                  foregroundColor: LightThemeColors.primaryTextColor,
                  actions: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.heart))
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.title,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.product.previousPrice.withPriceLabel(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .apply(
                                          decoration:
                                              TextDecoration.lineThrough),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(widget.product.price.withPriceLabel()),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text(
                          'این کتونی شدیدا برای دویدن و راه رفتن مناسب هست و تقریبا. هیچ فشار مخربی رو نمیذارد به پا و زانوان شما انتقال داده شود',
                          style: TextStyle(height: 1.4),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'نظرات کاربران',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            TextButton(
                                onPressed: () {}, child: const Text('ثبت نظر'))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                CommentList(productId: widget.product.id)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
