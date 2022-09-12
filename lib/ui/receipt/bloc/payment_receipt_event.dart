part of 'payment_receipt_bloc.dart';

abstract class PaymentReceiptEvent extends Equatable {
  const PaymentReceiptEvent();

  @override
  List<Object> get props => [];
}

class PaymentReceiptStarted extends PaymentReceiptEvent {
  final String orderID;

  const PaymentReceiptStarted(this.orderID);
  @override
  List<Object> get props => [orderID];
}
