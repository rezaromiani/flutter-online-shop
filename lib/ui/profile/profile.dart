import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_store/data/auth_info.dart';
import 'package:nike_store/data/repository/auth_repository.dart';
import 'package:nike_store/data/repository/cart_repository.dart';
import 'package:nike_store/ui/auth/auth.dart';
import 'package:nike_store/ui/favorite/favorite.dart';
import 'package:nike_store/ui/order/order.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("پروفایل"),
      ),
      body: ValueListenableBuilder<AuthInfo?>(
          valueListenable: AuthRepository.authChangeNotifier,
          builder: (context, authInfo, child) {
            final isLogin = authInfo != null && authInfo.accessToken.isNotEmpty;
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 65,
                      height: 65,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(top: 32, bottom: 8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Theme.of(context).dividerColor, width: 1)),
                      child: Image.asset("assets/img/nike_logo.png")),
                  Text(isLogin ? authInfo.email : "کاربر مهمان"),
                  const SizedBox(
                    height: 32,
                  ),
                  Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const FavoriteScreen(),
                      ));
                    },
                    title: const Text('لیست علاقه مندی ها'),
                    leading: const Icon(CupertinoIcons.heart),
                  ),
                  Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const OrderHistoryScreen(),
                      ));
                    },
                    title: const Text('سوابق سفارش'),
                    leading: const Icon(CupertinoIcons.cart),
                  ),
                  Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                  ListTile(
                    onTap: () {
                      if (isLogin) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: AlertDialog(
                                  title: const Text("خروح ار حساب کاربری"),
                                  content: const Text(
                                      'آیا می خواهید از حساب کاربری خود خارج شوید؟'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("خیر")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          CartRepository
                                              .cartItemCountNotifier.value = 0;
                                          authRepository.signOut();
                                        },
                                        child: const Text("بله"))
                                  ],
                                ),
                              );
                            });
                      } else {
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                          builder: (context) => const AuthScreen(),
                        ));
                      }
                    },
                    title: Text(isLogin
                        ? "خروح از حساب کاربری"
                        : "ورود به حساب کاربری"),
                    leading: Icon(isLogin
                        ? CupertinoIcons.arrow_right_square
                        : CupertinoIcons.arrow_left_square),
                  ),
                  Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
