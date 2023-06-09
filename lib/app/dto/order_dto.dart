import 'package:vakinha_burger_provider_com_bloc/app/dto/order_product_dto.dart';

class OrderDto {
  List<OrderProductDto> products;
  String address;
  String document;
  int paymentMethodId;
  OrderDto({
    required this.products,
    required this.address,
    required this.document,
    required this.paymentMethodId,
  });
}