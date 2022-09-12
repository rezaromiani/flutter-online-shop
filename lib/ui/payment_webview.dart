import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nike_store/ui/receipt/payment_receipt.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentGateWayScreen extends StatelessWidget {
  const PaymentGateWayScreen({Key? key, required this.bankGateWayUrl})
      : super(key: key);
  final String bankGateWayUrl;
  @override
  Widget build(BuildContext context) {
    
    return WebView(
      initialUrl: bankGateWayUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onPageStarted: (url) {
        debugPrint("url : $url");
        final uri = Uri.parse(url);
        if (uri.scheme == 'nike' &&
            uri.pathSegments.contains("appCheckout") &&
            uri.host == "expertdevelopers.ir") {
          final orderID = uri.queryParameters['order_id']!;
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PaymentReceiptScreen(orderID: orderID),
          ));
        }
      },
    );
  }
}
