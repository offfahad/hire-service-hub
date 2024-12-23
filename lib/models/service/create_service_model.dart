import 'package:e_commerce/utils/api_constnsts.dart';

class CreateService {
  final String? id;
  final String serviceName;
  final String description;
  final String? userId;
  final String? categoryId;
  final int price;
  final bool isAvailable;
  final String? coverPhoto;
  final String startTime;
  final String endTime;
  final String? city;

  CreateService({
    this.id,
    required this.serviceName,
    required this.description,
    this.userId,
    this.categoryId,
    required this.price,
    required this.isAvailable,
    this.coverPhoto,
    required this.startTime,
    required this.endTime,
    this.city,
  });

  // Factory method to create an instance from JSON
  factory CreateService.fromJson(Map<String, dynamic> json) {
    return CreateService(
      id: json['id'],
      serviceName: json['service_name'],
      description: json['description'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      price: int.parse(json['price']),
      isAvailable: json['is_available'],
      coverPhoto: json["cover_photo"] != null
          ? "${Constants.baseUrl}/${json["cover_photo"]}"
          : null,
      startTime: json['start_time'],
      endTime: json['end_time'],
      city: json['city'],
    );
  }

  // Convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'service_name': serviceName,
      'description': description,
      'category_id': categoryId,
      'price': price,
      'is_available': isAvailable,
      'cover_photo': coverPhoto,
      'start_time': startTime,
      'end_time': endTime,
    };
  }
}
