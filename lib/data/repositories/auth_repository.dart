// lib/data/repositories/auth_repository.dart
import 'dart:convert';
import '../datasources/remote/auth_api.dart';
import '../models/auth/login_response.dart';
import '../models/auth/register_request.dart';
import '../models/auth/login_request.dart';
import '../models/auth/user_model.dart';
import '../../core/services/token_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/constants/storage_keys.dart';

class AuthRepository {
  final AuthApi _authApi;
  final TokenService _tokenService;
  final StorageService _storageService;

  // ✅ Constructor actualizado - ahora recibe StorageService también
  AuthRepository(this._authApi, this._tokenService, this._storageService);

  // ==========================================
  // 🔐 LOGIN
  // ==========================================
  Future<LoginResponse> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _authApi.login(request);

      // Guardar token usando TokenService
      await _tokenService.saveToken(response.token);
      
      // Guardar usuario
      await _storageService.setString(
        StorageKeys.userData,
        json.encode(response.user.toJson()),
      );

      return response;
    } catch (e) {
      print('❌ Error en login: $e');
      rethrow;
    }
  }

  // ==========================================
  // 📝 REGISTRO
  // ==========================================
  Future<void> register(RegisterRequest request) async {
    try {
      await _authApi.register(request);
    } catch (e) {
      print('❌ Error en registro: $e');
      rethrow;
    }
  }

  // ==========================================
  // 🚪 LOGOUT
  // ==========================================
  Future<void> logout() async {
    try {
      // Logout en backend (opcional, no falla si hay error)
      await _authApi.logout();
    } catch (e) {
      print('⚠️ Error en logout backend: $e');
    } finally {
      // Siempre limpiar datos locales
      await _tokenService.removeToken();
      await _storageService.remove(StorageKeys.userData);
    }
  }

  // ==========================================
  // ✅ VERIFICAR SI ESTÁ LOGUEADO
  // ==========================================
  bool isLoggedIn() {
    return _tokenService.hasToken();
  }

  // ==========================================
  // 👤 OBTENER USUARIO ACTUAL
  // ==========================================
  UserModel? getCurrentUser() {
    try {
      final userJson = _storageService.getString(StorageKeys.userData);
      if (userJson == null || userJson.isEmpty) return null;

      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      print('❌ Error al obtener usuario: $e');
      return null;
    }
  }

  // ==========================================
  // 🔑 OBTENER TOKEN
  // ==========================================
  Future<String?> getToken() async {
    return await _tokenService.getToken();
  }

  // ==========================================
  // 🔄 ACTUALIZAR USUARIO
  // ==========================================
  Future<void> updateUser(UserModel user) async {
    try {
      await _storageService.setString(
        StorageKeys.userData,
        json.encode(user.toJson()),
      );
    } catch (e) {
      print('❌ Error al actualizar usuario: $e');
      rethrow;
    }
  }

  // ==========================================
  // ✅ VALIDAR TOKEN
  // ==========================================
  Future<bool> validateToken() async {
    try {
      if (!isLoggedIn()) return false;
      return await _authApi.validateToken();
    } catch (e) {
      print('❌ Error validando token: $e');
      return false;
    }
  }

  // ==========================================
  // 🔄 ACTUALIZAR TOKEN
  // ==========================================
  Future<void> updateToken(String newToken) async {
    try {
      await _tokenService.saveToken(newToken);
    } catch (e) {
      print('❌ Error actualizando token: $e');
      rethrow;
    }
  }
}