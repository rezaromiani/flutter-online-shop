import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/repository/cart_repository.dart';
import 'package:nike_store/data/repository/product_repository.dart';
import 'package:nike_store/theme.dart';
import 'package:nike_store/ui/list/bloc/list_bloc.dart';
import 'package:nike_store/ui/product/product.dart';
import 'package:nike_store/ui/widgets/error.dart';
import 'package:nike_store/ui/widgets/loading.dart';

class ListScreen extends StatefulWidget {
  ListScreen({Key? key, required this.sort}) : super(key: key);
  final int sort;
  ViewType viewType = ViewType.grid;
  @override
  State<ListScreen> createState() => _ListScreenState();
}

enum ViewType { grid, list }

class _ListScreenState extends State<ListScreen> {
  ListBloc? listBloc;
  @override
  void dispose() {
    super.dispose();
    listBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("کفش های ورزشی"),
            actions: [
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(CupertinoIcons.cart),
                    Positioned(
                        top: -5,
                        right: -10,
                        child: ValueListenableBuilder<int>(
                            valueListenable:
                                CartRepository.cartItemCountNotifier,
                            builder: (context, value, child) {
                              return Badge(
                                showBadge: value > 0,
                                badgeColor:
                                    Theme.of(context).colorScheme.primary,
                                animationType: BadgeAnimationType.scale,
                                badgeContent: Text(
                                  value.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }))
                  ],
                ),
              ),
              const SizedBox(
                width: 12,
              ),
            ],
          ),
          body: BlocProvider<ListBloc>(
            create: (context) {
              listBloc = ListBloc(productRepository)
                ..add(ProductListStarted(sort: widget.sort));
              return listBloc!;
            },
            child: BlocBuilder<ListBloc, ListState>(
              builder: (context, state) {
                if (state is ListSuccess) {
                  final products = state.products;
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20)
                            ],
                            border: Border(
                                top: BorderSide(
                                    color: Theme.of(context).dividerColor,
                                    width: 1))),
                        height: 56,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                isDismissible: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(32))),
                                context: context,
                                builder: (context) {
                                  return Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 24, bottom: 24),
                                      height: 300,
                                      child: Column(
                                        children: [
                                          Text(
                                            "انتخاب مرتب سازی",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                                itemCount:
                                                    state.sortNames.length,
                                                itemBuilder: (context, index) =>
                                                    ListTile(
                                                      onTap: () {
                                                        listBloc!.add(
                                                            ProductListStarted(
                                                                sort: index));
                                                        Navigator.pop(context);
                                                      },
                                                      selected:
                                                          index == state.sort,
                                                      selectedTileColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .primary
                                                              .withOpacity(0.1),
                                                      title: Text(
                                                        state.sortNames[index],
                                                        style: TextStyle(
                                                            fontWeight: index ==
                                                                    state.sort
                                                                ? FontWeight
                                                                    .bold
                                                                : FontWeight
                                                                    .normal,
                                                            color: index ==
                                                                    state.sort
                                                                ? Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary
                                                                : Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSurface),
                                                      ),
                                                    )),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Row(children: [
                            Expanded(
                                child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(CupertinoIcons.sort_down)),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "مرتب سازی",
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      state.sortNames[state.sort],
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    )
                                  ],
                                )
                              ],
                            )),
                            Container(
                              width: 1,
                              color: Theme.of(context).dividerColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (widget.viewType == ViewType.grid) {
                                        widget.viewType = ViewType.list;
                                      } else {
                                        widget.viewType = ViewType.grid;
                                      }
                                    });
                                  },
                                  icon: Icon(widget.viewType == ViewType.grid
                                      ? CupertinoIcons.square_grid_2x2
                                      : CupertinoIcons.square)),
                            )
                          ]),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          physics: defaultScrollPhysics,
                          itemCount: products.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.65,
                                  crossAxisCount:
                                      widget.viewType == ViewType.grid ? 2 : 1),
                          itemBuilder: (context, index) {
                            return ProductItem(
                              product: products[index],
                              borderRadius: BorderRadius.circular(0),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is ListLoading) {
                  return AppLoading();
                } else if (state is ListError) {
                  return AppErrorShow(
                      appException: state.appException,
                      onTap: () {
                        BlocProvider.of<ListBloc>(context)
                            .add(ProductListStarted(sort: widget.sort));
                      });
                } else {
                  throw Exception("product list state is not supported");
                }
              },
            ),
          )),
    );
  }
}
