import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/favorite_manager.dart';
import 'package:nike_store/data/product.dart';
import 'package:nike_store/ui/product/details.dart';
import 'package:nike_store/ui/widgets/image.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("لیست علاقه مندی ها"),
      ),
      body: ValueListenableBuilder<Box<ProductEntity>>(
          valueListenable: favoriteManager.listenable,
          builder: (context, box, _) {
            final products = box.values.toList();
            return ListView.builder(
              physics: defaultScrollPhysics,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final ProductEntity product = products[index];
                return InkWell(
                  onLongPress: () {
                    favoriteManager.delete(product);
                  },
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: product),
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 110,
                            height: 110,
                            child: ImageLoadingService(
                              imageUrl: product.imageUrl,
                              borderRadius: BorderRadius.circular(8),
                            )),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(child: Text(product.title))
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
