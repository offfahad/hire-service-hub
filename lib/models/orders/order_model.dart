class Order {
  final String? id;
  final String orderDate;
  final String serviceId;
  final String additionalNotes;
  final String paymentMethod;
  final String? orderPrice;
  final String? customerAddress;

  Order({
    this.id,
    required this.orderDate,
    required this.serviceId,
    required this.additionalNotes,
    required this.paymentMethod,
    this.orderPrice,
    this.customerAddress,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderDate: json['order_date'],
      serviceId: json['service_id'],
      additionalNotes: json['additional_notes'],
      paymentMethod: json['payment_method'],
      orderPrice: json['order_price'],
      customerAddress: json['customer_address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_date': orderDate,
      'service_id': serviceId,
      'additional_notes': additionalNotes,
      'payment_method': paymentMethod,
    };
  }
}
