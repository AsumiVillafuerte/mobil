// lib/data/models/auth/login_response.dart
import 'user_model.dart';
import 'role_model.dart';

class LoginResponse {
  final String token;
  final UserModel user;

  LoginResponse({
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Parseando LoginResponse desde JSON:');
      print('Raw JSON: $json');

      // ✅ Estructura actual (anidada)
      if (json.containsKey('user') && json['user'] is Map<String, dynamic>) {
        return LoginResponse(
          token: json['token']?.toString() ?? '',
          user: UserModel.fromJson(json['user']),
        );
      }

      // ⚠️ Estructura alternativa (por compatibilidad futura)
      return LoginResponse(
        token: json['token']?.toString() ?? '',
        user: UserModel.fromJson(json),
      );
    } catch (e, stackTrace) {
      print('❌ Error parseando LoginResponse: $e');
      print('StackTrace: $stackTrace');
      print('JSON recibido: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }

  @override
  String toString() {
    return 'LoginResponse(token: ${token.substring(0, 20)}..., user: $user)';
  }
}
