import 'dart:convert';

class GetMyOrders {
  bool success;
  int statusCode;
  String message;
  List<Datum> data;

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
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String customerId;
  String serviceId;
  String serviceProviderId;
  DateTime placedAt;
  DateTime orderDate;
  String orderStatus;
  String orderPrice;
  String paymentStatus;
  String paymentMethod;
  Address customerAddress;
  String? additionalNotes;
  dynamic orderCompletionDate;
  dynamic cancellationReason;
  Service service;
  Customer customer;

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
    required this.additionalNotes,
    required this.orderCompletionDate,
    required this.cancellationReason,
    required this.service,
    required this.customer,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        orderCompletionDate: json["order_completion_date"],
        cancellationReason: json["cancellation_reason"],
        service: Service.fromJson(json["service"]),
        customer: Customer.fromJson(json["customer"]),
      );

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
        "order_completion_date": orderCompletionDate,
        "cancellation_reason": cancellationReason,
        "service": service.toJson(),
        "customer": customer.toJson(),
      };
}

class Customer {
  String id;
  String email;
  String password;
  String firstName;
  String lastName;
  String phone;
  String gender;
  dynamic profilePicture;
  dynamic otp;
  String cnic;
  String roleId;
  bool isVerified;
  bool isAdmin;
  Address address;
  String bio;
  bool isComplete;

  Customer({
    required this.id,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.gender,
    required this.profilePicture,
    required this.otp,
    required this.cnic,
    required this.roleId,
    required this.isVerified,
    required this.isAdmin,
    required this.address,
    required this.bio,
    required this.isComplete,
  });

  factory Customer.fromRawJson(String str) =>
      Customer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
        gender: json["gender"],
        profilePicture: json["profile_picture"],
        otp: json["otp"],
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
        "password": password,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "gender": gender,
        "profile_picture": profilePicture,
        "otp": otp,
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
  int streetNo;
  String city;
  String state;
  String postalCode;
  String country;
  String location;

  Address({
    required this.streetNo,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.location,
  });

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
