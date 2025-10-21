// lib/data/datasources/remote/auth_api.dart
import '../../../core/services/http_service.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../models/auth/login_request.dart';
import '../../models/auth/login_response.dart';
import '../../models/auth/register_request.dart';

class AuthApi {
  final HttpService _httpService;

  AuthApi(this._httpService);

  /// Login - Retorna LoginResponse
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      print('🔐 Intentando login...');
      
      // HttpService.post retorna el JSON ya parseado
      // Necesita 2 argumentos: endpoint y body
      final response = await _httpService.post(
        ApiEndpoints.login,
        request.toJson(), // Segundo argumento: el body
      );

      print('✅ Login exitoso');
      return LoginResponse.fromJson(response);
    } catch (e) {
      print('❌ Error en login: $e');
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  /// Register - Retorna Map con la respuesta
  Future<Map<String, dynamic>> register(RegisterRequest request) async {
    try {
      print('📝 Intentando registro...');
      
      final response = await _httpService.post(
        ApiEndpoints.register,
        request.toJson(), // Segundo argumento: el body
      );

      print('✅ Registro exitoso');
      return response;
    } catch (e) {
      print('❌ Error en register: $e');
      throw Exception('Error al registrar usuario: $e');
    }
  }

  /// Validar Token - Retorna bool
  Future<bool> validateToken() async {
    try {
      print('🔍 Validando token...');
      
      await _httpService.get(ApiEndpoints.validateToken);
      
      print('✅ Token válido');
      return true;
    } catch (e) {
      print('❌ Token inválido: $e');
      return false;
    }
  }

  /// Logout (opcional)
  Future<void> logout() async {
    try {
      print('👋 Cerrando sesión...');
      await _httpService.post(ApiEndpoints.logout, {});
      print('✅ Sesión cerrada');
    } catch (e) {
      print('⚠️ Error al cerrar sesión: $e');
      // No lanzar excepción, el logout local debe continuar
    }
  }
}