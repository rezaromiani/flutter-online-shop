import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store/common/exceptions.dart';
import 'package:nike_store/data/order.dart';
import 'package:nike_store/data/repository/order_repository.dart';

part 'order_history_event.dart';
part 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final IOrderRepository orderRepository;
  OrderHistoryBloc(this.orderRepository) : super(OrderHistoryLoading()) {
    on<OrderHistoryEvent>((event, emit) async {
      if (event is OrderHistoryStarted) {
        try {
          emit(OrderHistoryLoading());
          final result = await orderRepository.getOrders();
          emit(OrderHistorySuccess(result));
        } catch (e) {
          emit(OrderHistoryError(e is AppException ? e : AppException()));
        }
      }
    });
  }
}
