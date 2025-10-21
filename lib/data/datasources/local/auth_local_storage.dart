// lib/data/datasources/local/auth_local_storage.dart
import '../../../core/services/storage_service.dart';
import '../../models/auth/user_model.dart';

// ⭐ Constantes locales para evitar conflictos
class _StorageKeys {
  static const String authToken = 'auth_token';
  static const String userInfo = 'user_info';
}

class AuthLocalStorage {
  final StorageService _storageService;

  AuthLocalStorage(this._storageService);

  // Token
  Future<bool> saveToken(String token) async {
    return await _storageService.setString(_StorageKeys.authToken, token);
  }

  String? getToken() {
    return _storageService.getString(_StorageKeys.authToken);
  }

  bool hasToken() {
    return _storageService.containsKey(_StorageKeys.authToken);
  }

  // Usuario
  Future<bool> saveUser(UserModel user) async {
    return await _storageService.setJson(_StorageKeys.userInfo, user.toJson());
  }

  UserModel? getUser() {
    final json = _storageService.getJson(_StorageKeys.userInfo);
    if (json == null) return null;
    return UserModel.fromJson(json);
  }

  // Limpiar todo
  Future<void> clearAll() async {
    await _storageService.remove(_StorageKeys.authToken);
    await _storageService.remove(_StorageKeys.userInfo);
  }
}