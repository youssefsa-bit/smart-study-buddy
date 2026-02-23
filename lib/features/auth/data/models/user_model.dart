// lib/features/auth/data/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

// موديل الرد الكامل (Response)
class AuthResponse {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  AuthResponse({required this.user, required this.accessToken, required this.refreshToken});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // نلاحظ أن الباك إند يرسل البيانات داخل حقل 'data' حسب ApiResponse.js
    final data = json['data'];
    return AuthResponse(
      user: UserModel.fromJson(data['user']),
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
    );
  }
}