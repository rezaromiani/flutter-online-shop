import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/product.dart';
import 'package:nike_store/data/repository/banner_repository.dart';
import 'package:nike_store/data/repository/product_repository.dart';
import 'package:nike_store/ui/home/bloc/home_bloc.dart';
import 'package:nike_store/ui/list/list.dart';
import 'package:nike_store/ui/product/product.dart';
import 'package:nike_store/ui/widgets/error.dart';
import 'package:nike_store/ui/widgets/loading.dart';
import 'package:nike_store/ui/widgets/slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget showedWidget = Container();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) {
      final homeBloc = HomeBloc(
          productRepository: productRepository,
          bannerRepository: bannerRepository);
      homeBloc.add(HomeStarted());
      return homeBloc;
    }, child: Scaffold(
      body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: getWidget(state, context),
        );
      })),
    ));
  }

  Widget getWidget(state, context) {
    if (state is HomeSuccess) {
      return ListView.builder(
          key: const ValueKey("Product_List"),
          physics: defaultScrollPhysics,
          itemCount: 5,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return Container(
                  height: 56,
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/img/nike_logo.png",
                    height: 24,
                    fit: BoxFit.fitHeight,
                  ),
                );
              case 2:
                return BannerSlider(
                  banners: state.banners,
                );
              case 3:
                return _HorizontalProductList(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                      builder: (context) =>  ListScreen(
                        sort: ProductSort.latest,
                      ),
                    ));
                  },
                  title: 'جدیدترین',
                  products: state.latestProducts,
                );
              case 4:
                return _HorizontalProductList(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                      builder: (context) =>  ListScreen(
                        sort: ProductSort.popular,
                      ),
                    ));
                  },
                  title: 'پربازدیدترین',
                  products: state.popularProducts,
                );
              default:
                return Container();
            }
          });
    } else if (state is HomeLoading) {
      return AppLoading(
        key: ValueKey("loading"),
      );
    } else if (state is HomeError) {
      return AppErrorShow(
        key: const ValueKey("Error"),
        onTap: () {
          BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
        },
        appException: state.exception,
      );
    } else {
      throw Exception("state is not supported");
    }
  }
}

class _HorizontalProductList extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  final List<ProductEntity> products;
  const _HorizontalProductList(
      {Key? key,
      required this.title,
      required this.products,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              TextButton(onPressed: onTap, child: const Text('مشاهده همه'))
            ],
          ),
        ),
        SizedBox(
          height: 290,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: defaultScrollPhysics,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductItem(
                product: product,
                borderRadius: BorderRadius.circular(12),
              );
            },
          ),
        ),
      ],
    );
  }
}
