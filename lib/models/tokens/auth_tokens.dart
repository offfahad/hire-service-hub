class AuthTokens {
  final String? accessToken;
  final String? refreshToken;

  AuthTokens({
    this.accessToken,
    this.refreshToken,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['token'] ?? '',
    );
  }
}
