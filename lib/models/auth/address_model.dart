class AddressModel {
  final int streetNo;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String location;

  AddressModel({
    required this.streetNo,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.location
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      streetNo: json['street_no'] ?? 0,
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postal_code'] ?? '',
      country: json['country'] ?? '',
      location: json['location'] ?? '',
    );
  }
}
