class CreateOrderResponse {
  final bool success;
  final int statusCode;
  final String message;
  final OrderDetails? data;

  CreateOrderResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory CreateOrderResponse.fromMap(Map<String, dynamic> map) {
    return CreateOrderResponse(
      success: map['success'],
      statusCode: map['statusCode'],
      message: map['message'],
      data: map['data'] != null && map['data']['data'] != null
          ? OrderDetails.fromMap(
              map['data']['data'][0]) // Access the first item in the list
          : null,
    );
  }
}

class OrderDetails {
  final String id;
  final String customerId;
  final String serviceId;
  final String serviceProviderId;
  final DateTime placedAt;
  final DateTime orderDate;
  final String orderStatus;
  final String orderPrice;
  final String paymentStatus;
  final String paymentMethod;
  final CustomerAddress? customerAddress;
  final String? additionalNotes;
  final DateTime? orderCompletionDate;
  final String? cancellationReason;

  OrderDetails({
    required this.id,
    required this.customerId,
    required this.serviceId,
    required this.serviceProviderId,
    required this.placedAt,
    required this.orderDate,
    required this.orderStatus,
    required this.orderPrice,
    required this.paymentStatus,
    required this.paymentMethod,
    this.customerAddress,
    this.additionalNotes,
    this.orderCompletionDate,
    this.cancellationReason,
  });

  factory OrderDetails.fromMap(Map<String, dynamic> map) {
    return OrderDetails(
      id: map['id'],
      customerId: map['customer_id'],
      serviceId: map['service_id'],
      serviceProviderId: map['service_provider_id'],
      placedAt: DateTime.parse(map['placed_at']),
      orderDate: DateTime.parse(map['order_date']),
      orderStatus: map['order_status'],
      orderPrice: map['order_price'],
      paymentStatus: map['payment_status'],
      paymentMethod: map['payment_method'],
      customerAddress: map['customer_address'] != null
          ? CustomerAddress.fromMap(map['customer_address'])
          : null,
      additionalNotes: map['additional_notes'],
      orderCompletionDate: map['order_completion_date'] != null
          ? DateTime.tryParse(map['order_completion_date'])
          : null,
      cancellationReason: map['cancellation_reason'],
    );
  }
}

class CustomerAddress {
  final int streetNo;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String location;

  CustomerAddress({
    required this.streetNo,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.location,
  });

  factory CustomerAddress.fromMap(Map<String, dynamic> map) {
    return CustomerAddress(
      streetNo: map['street_no'],
      city: map['city'],
      state: map['state'],
      postalCode: map['postal_code'],
      country: map['country'],
      location: map['location'],
    );
  }
}
