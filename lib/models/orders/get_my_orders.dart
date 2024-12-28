import 'dart:convert';

import 'package:e_commerce/utils/api_constnsts.dart';

class GetMyOrders {
  final bool success;
  final int statusCode;
  final String message;
  final List<Datum> data;

  GetMyOrders({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory GetMyOrders.fromRawJson(String str) =>
      GetMyOrders.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetMyOrders.fromJson(Map<String, dynamic> json) => GetMyOrders(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "statusCode": statusCode,
        "message": message,
        "data": data.map((x) => x.toJson()).toList(),
      };
}

class Datum {
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
  final Address customerAddress;
  final String? additionalNotes;
  final DateTime? orderCompletionDate;
  final String? cancellationReason;
  final Service service;
  final Customer? customer;
  final Customer? serviceProvider;

  Datum({
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
    required this.customerAddress,
    this.additionalNotes,
    this.orderCompletionDate,
    this.cancellationReason,
    required this.service,
    this.customer,
    this.serviceProvider,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["id"],
      customerId: json["customer_id"],
      serviceId: json["service_id"],
      serviceProviderId: json["service_provider_id"],
      placedAt: DateTime.parse(json["placed_at"]),
      orderDate: DateTime.parse(json["order_date"]),
      orderStatus: json["order_status"],
      orderPrice: json["order_price"],
      paymentStatus: json["payment_status"],
      paymentMethod: json["payment_method"],
      customerAddress: Address.fromJson(json["customer_address"]),
      additionalNotes: json["additional_notes"],
      orderCompletionDate: json["order_completion_date"] != null
          ? DateTime.tryParse(json["order_completion_date"])
          : null,
      cancellationReason: json["cancellation_reason"],
      service: Service.fromJson(json["service"]),
      customer:
          json["customer"] != null ? Customer.fromJson(json["customer"]) : null,
      serviceProvider: json["serviceProvider"] != null
          ? Customer.fromJson(json["serviceProvider"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "service_id": serviceId,
        "service_provider_id": serviceProviderId,
        "placed_at": placedAt.toIso8601String(),
        "order_date": orderDate.toIso8601String(),
        "order_status": orderStatus,
        "order_price": orderPrice,
        "payment_status": paymentStatus,
        "payment_method": paymentMethod,
        "customer_address": customerAddress.toJson(),
        "additional_notes": additionalNotes,
        "order_completion_date": orderCompletionDate?.toIso8601String(),
        "cancellation_reason": cancellationReason,
        "service": service.toJson(),
        "customer": customer?.toJson(),
        "service_provider": serviceProvider?.toJson(),
      };
}

class Customer {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String? gender;
  final String? profilePicture;
  final String cnic;
  final String roleId;
  final bool isVerified;
  final bool isAdmin;
  final Address address;
  final String bio;
  final bool isComplete;

  Customer({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.gender,
    this.profilePicture,
    required this.cnic,
    required this.roleId,
    required this.isVerified,
    required this.isAdmin,
    required this.address,
    required this.bio,
    required this.isComplete,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
        gender: json["gender"],
        profilePicture: json['profile_picture'] != null
            ? "${Constants.baseUrl}/${json['profile_picture']}"
            : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small_2x/default-avatar-icon-of-social-media-user-vector.jpg',
        cnic: json["cnic"],
        roleId: json["role_id"],
        isVerified: json["is_verified"],
        isAdmin: json["is_admin"],
        address: Address.fromJson(json["address"]),
        bio: json["bio"],
        isComplete: json["is_complete"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "gender": gender,
        "profile_picture": profilePicture,
        "cnic": cnic,
        "role_id": roleId,
        "is_verified": isVerified,
        "is_admin": isAdmin,
        "address": address.toJson(),
        "bio": bio,
        "is_complete": isComplete,
      };
}

class Address {
  final int streetNo;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;
  final String? location;

  Address({
    required this.streetNo,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.location,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        streetNo: json["street_no"],
        city: json["city"],
        state: json["state"],
        postalCode: json["postal_code"],
        country: json["country"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "street_no": streetNo,
        "city": city,
        "state": state,
        "postal_code": postalCode,
        "country": country,
        "location": location,
      };
}

class Service {
  String id;
  String serviceName;
  String description;
  String userId;
  String categoryId;
  int price;
  bool isAvailable;
  dynamic coverPhoto;
  DateTime startTime;
  DateTime endTime;
  String city;

  Service({
    required this.id,
    required this.serviceName,
    required this.description,
    required this.userId,
    required this.categoryId,
    required this.price,
    required this.isAvailable,
    required this.coverPhoto,
    required this.startTime,
    required this.endTime,
    required this.city,
  });

  factory Service.fromRawJson(String str) => Service.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        serviceName: json["service_name"],
        description: json["description"],
        userId: json["user_id"],
        categoryId: json["category_id"],
        price: json["price"],
        isAvailable: json["is_available"],
        coverPhoto: json["cover_photo"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
        city: json["city"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_name": serviceName,
        "description": description,
        "user_id": userId,
        "category_id": categoryId,
        "price": price,
        "is_available": isAvailable,
        "cover_photo": coverPhoto,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
        "city": city,
      };
}
