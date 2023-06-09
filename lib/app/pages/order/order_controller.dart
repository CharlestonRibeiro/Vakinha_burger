import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakinha_burger_provider_com_bloc/app/dto/order_dto.dart';
import 'package:vakinha_burger_provider_com_bloc/app/dto/order_product_dto.dart';
import 'package:vakinha_burger_provider_com_bloc/app/pages/order/order_state.dart';
import 'package:vakinha_burger_provider_com_bloc/app/repositories/order/order_repository.dart';

class OrderController extends Cubit<OrderState> {
  final OrderRepository _orderRepository;
  OrderController(this._orderRepository) : super(const OrderState.initial());

  Future<void> load(List<OrderProductDto> products) async {
    try {
      emit(state.copyWith(status: OrderStatus.loading));
      final paymentTypes = await _orderRepository.getAllPaymentTypes();
      emit(state.copyWith(
          orderProducts: products,
          status: OrderStatus.ready,
          paymentTypes: paymentTypes));
    } catch (e, s) {
      log('Erro ao carregar página', error: e, stackTrace: s);
      emit(state.copyWith(
          status: OrderStatus.error, errorMessage: 'Erro ao carregar página'));
    }
  }

  void incrementProduct(int index) {
    final orders = [...state.orderProducts];
    final order = orders[index];

    orders[index] = order.copyWith(amount: order.amount + 1);
    emit(state.copyWith(
      status: OrderStatus.updateOrder,
      orderProducts: orders,
    ));
  }

  void decrementProduct(int index) {
    final orders = [...state.orderProducts];
    final order = orders[index];
    final amount = order.amount;

    if (amount == 1) {
      if (state.status != OrderStatus.confirmRemoveProduct) {
        emit(
          OrderConfirmDeleteProductState(
            status: OrderStatus.confirmRemoveProduct,
            orderProducts: state.orderProducts,
            paymentTypes: state.paymentTypes,
            orderProduct: order,
            index: index,
            errorMessage: state.errorMessage,
          ),
        );
        return;
      } else {
        orders.removeAt(index);
      }
    } else {
      orders[index] = order.copyWith(amount: order.amount - 1);
    }
    if (orders.isEmpty) {
      emit(state.copyWith(status: OrderStatus.emptyCart));
    }
    emit(
      state.copyWith(status: OrderStatus.updateOrder, orderProducts: orders),
    );
  }

  void cancelDeleteProcess() => emit(state.copyWith(status: OrderStatus.ready));

  void emptyCart() => emit(state.copyWith(status: OrderStatus.emptyCart));

  void saveOrder(
      {required String address,
      required String document,
      required int paymentMethodId}) async {
    emit(state.copyWith(status: OrderStatus.loading));
    await _orderRepository.saveOrder(OrderDto(
        products: state.orderProducts,
        address: address,
        document: document,
        paymentMethodId: paymentMethodId));

    emit(state.copyWith(status: OrderStatus.success));
  }
}