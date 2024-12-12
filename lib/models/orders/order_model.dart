import 'package:e_commerce/models/auth/address_model.dart';

class Order {
  final String? id;
  final String orderDate; // Required
  final String serviceId; // Required
  final String paymentMethod; // Required
  final String? additionalNotes;
  final String? orderPrice;
  final AddressModel? customerAddress; // Nested address model
  final String? serviceProviderId;
  final String? placedAt;
  final String? orderStatus;
  final String? paymentStatus;
  final String? orderCompletionDate;
  final String? cancellationReason;

  Order({
    this.id,
    required this.orderDate,
    required this.serviceId,
    required this.paymentMethod,
    this.additionalNotes,
    this.orderPrice,
    this.customerAddress,
    this.serviceProviderId,
    this.placedAt,
    this.orderStatus,
    this.paymentStatus,
    this.orderCompletionDate,
    this.cancellationReason,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderDate: json['order_date'],
      serviceId: json['service_id'],
      paymentMethod: json['payment_method'],
      additionalNotes: json['additional_notes'],
      orderPrice: json['order_price'],
      customerAddress: json['customer_address'] != null
          ? AddressModel.fromJson(json['customer_address'])
          : null,
      serviceProviderId: json['service_provider_id'],
      placedAt: json['placed_at'],
      orderStatus: json['order_status'],
      paymentStatus: json['payment_status'],
      orderCompletionDate: json['order_completion_date'],
      cancellationReason: json['cancellation_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_date': orderDate,
      'service_id': serviceId,
      'payment_method': paymentMethod,
      if (additionalNotes != null) 'additional_notes': additionalNotes,
    };
  }
}
