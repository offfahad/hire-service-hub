class CreateService {
  final String? id;
  final String serviceName;
  final String description;
  final String? userId;
  final String? categoryId;
  final String price;
  final bool isAvailable;
  final String? coverPhoto;
  final DateTime startTime;
  final DateTime endTime;
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
      serviceName: json['CreateService_name'],
      description: json['description'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      price: json['price'],
      isAvailable: json['is_available'],
      coverPhoto: json['cover_photo'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
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
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
    };
  }
}
