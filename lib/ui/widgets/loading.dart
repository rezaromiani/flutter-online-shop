import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLoading extends StatelessWidget {
   AppLoading({
    Key? key,
    this.width=150,
    this.height=150
  }) : super(key: key);
  double width;
  double height;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset("assets/animation/loading.json",
          width: width, height: height, fit: BoxFit.fill),
    );
  }
}
