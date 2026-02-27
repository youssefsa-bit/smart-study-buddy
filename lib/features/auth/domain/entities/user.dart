class User {
  final String id;
  final String email;
  final String? name;
  final String accessToken;
  final String refreshToken;

  const User({
    required this.id,
    required this.email,
    this.name,
    required this.accessToken,
    required this.refreshToken,
  });
}