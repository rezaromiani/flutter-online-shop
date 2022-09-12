import 'package:nike_store/common/http_client.dart';
import 'package:nike_store/data/order.dart';
import 'package:nike_store/data/payment_receipt.dart';
import 'package:nike_store/data/source/order_data_source.dart';

abstract class IOrderRepository extends IOrderDataSource {}

final orderRepository = OrderRepository(OrderRemoteDataSource(httpClient));

class OrderRepository implements IOrderRepository {
  final IOrderDataSource orderDataSource;

  OrderRepository(this.orderDataSource);

  @override
  Future<CreateOrderResult> create(CreateOrderParams params) =>
      orderDataSource.create(params);

  @override
  Future<PaymentReceiptData> getPaymentReceipt(String orderID) =>
      orderDataSource.getPaymentReceipt(orderID);

  @override
  Future<List<OrderEntity>> getOrders() {
    return orderDataSource.getOrders();
  }
}
