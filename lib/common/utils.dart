import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

const defaultScrollPhysics = BouncingScrollPhysics();

extension PriceLabel on int {
  String withPriceLabel() => this > 0 ? "$separateByComma تومان" : "رایگان";

  String get separateByComma {
    final numberFormat = NumberFormat.decimalPattern();
    return numberFormat.format(this);
  }
}
