import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nike_store/common/exceptions.dart';

class AppErrorShow extends StatelessWidget {
  final AppException appException;
  final GestureTapCallback onTap;
  const AppErrorShow(
      {Key? key, required this.appException, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/svg/error.svg",
          height: 180,
        ),
        const SizedBox(height: 24),
        Text(appException.message),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: onTap, child: const Text('تلاش دوباره'))
      ],
    ));
  }
}
