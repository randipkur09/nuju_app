import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  Order? _currentOrder;
  Order? get currentOrder => _currentOrder;

  Future<void> createOrder(Order order) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _orders.add(order);
      _currentOrder = order;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index >= 0) {
        final updatedOrder = Order(
          id: _orders[index].id,
          customerId: _orders[index].customerId,
          baristaId: _orders[index].baristaId,
          items: _orders[index].items,
          totalPrice: _orders[index].totalPrice,
          status: status,
          paymentMethod: _orders[index].paymentMethod,
          notes: _orders[index].notes,
          createdAt: _orders[index].createdAt,
          updatedAt: DateTime.now(),
        );
        _orders[index] = updatedOrder;
        if (_currentOrder?.id == orderId) {
          _currentOrder = updatedOrder;
        }
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Order> getCustomerOrders(String customerId) {
    return _orders.where((order) => order.customerId == customerId).toList();
  }

  List<Order> getPendingOrders() {
    return _orders
        .where((order) => order.status == 'pending' || order.status == 'confirmed')
        .toList();
  }

  List<Order> getProcessingOrders() {
    return _orders.where((order) => order.status == 'processing').toList();
  }

  List<Order> getCompletedOrders() {
    return _orders.where((order) => order.status == 'completed').toList();
  }

  void clearCurrentOrder() {
    _currentOrder = null;
    notifyListeners();
  }
}
