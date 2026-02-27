import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    required super.accessToken,
    required super.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data == null) throw Exception("Missing 'data' field in server response");

    final userData = data['user'];
    if (userData == null) throw Exception("Missing 'user' inside 'data' field");

    return UserModel(
      id: userData['id'].toString(),
      email: userData['email'] ?? '',
      name: userData['name'],
      accessToken: data['accessToken'] ?? '',
      refreshToken: data['refreshToken'] ?? '',
    );
  }
}
