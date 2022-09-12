import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store/common/exceptions.dart';
import 'package:nike_store/data/payment_receipt.dart';
import 'package:nike_store/data/repository/order_repository.dart';

part 'payment_receipt_event.dart';
part 'payment_receipt_state.dart';

class PaymentReceiptBloc
    extends Bloc<PaymentReceiptEvent, PaymentReceiptState> {
  final IOrderRepository orderRepository;
  PaymentReceiptBloc({required this.orderRepository})
      : super(PaymentReceiptLoading()) {
    on<PaymentReceiptEvent>((event, emit) async {
      if (event is PaymentReceiptStarted) {
        emit(PaymentReceiptLoading());
        try {
          final result = await orderRepository.getPaymentReceipt(event.orderID);
          emit(PaymentReceiptSuccess(result));
        } catch (e) {
          emit(PaymentReceiptError(e is AppException ? e : AppException()));
        }
      }
    });
  }
}
