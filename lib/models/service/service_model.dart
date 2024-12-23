import 'package:e_commerce/utils/api_constnsts.dart';

class ServiceModel {
  final String id;
  final String serviceName;
  final String description;
  final String price;
  final bool isAvailable;
  final String city;
  final String? coverPhoto;
  final String startTime;
  final String endTime;
  final User user;

  ServiceModel({
    required this.id,
    required this.serviceName,
    required this.description,
    required this.price,
    required this.isAvailable,
    required this.city,
    required this.startTime,
    required this.endTime,
    required this.user,
    required this.coverPhoto,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      serviceName: json['service_name'],
      description: json['description'],
      price: json['price'],
      isAvailable: json['is_available'],
      city: json['city'],
      coverPhoto: json["cover_photo"] != null
          ? "${Constants.baseUrl}/${json["cover_photo"]}"
          : null,
      startTime: json['start_time'],
      endTime: json['end_time'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final String firstName;
  final String lastName;
  final String? profilePicture;

  User({
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        firstName: json['first_name'],
        lastName: json['last_name'],
        profilePicture: json['profile_picture']);
  }
}
