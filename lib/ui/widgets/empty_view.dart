import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  const EmptyView(
      {Key? key, required this.message, required this.image, this.callToAction})
      : super(key: key);
  final String message;
  final Widget image;
  final Widget? callToAction;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        image,
        Padding(
          padding:
              const EdgeInsets.only(left: 48, right: 48, top: 24, bottom: 16),
          child: Text(
            message,
            style: Theme.of(context).textTheme.headline6!.copyWith(height: 1.3),
            textAlign: TextAlign.center,
          ),
        ),
        if (callToAction != null) callToAction!
      ],
    );
  }
}
