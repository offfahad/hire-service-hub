class ProfileCompletion {
  final int userCompletionPercentage;

  ProfileCompletion({
    required this.userCompletionPercentage,
  });

  // Factory to parse JSON response
  factory ProfileCompletion.fromJson(Map<String, dynamic> json) {
    return ProfileCompletion(
      userCompletionPercentage: json['userCompletionPercentage'],
    );
  }
}
