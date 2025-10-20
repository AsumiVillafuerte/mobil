// lib/core/services/token_service.dart
import 'storage_service.dart';
import '../constants/storage_keys.dart';

class TokenService {
  final StorageService storageService;

  TokenService(this.storageService);

  // Guardar token
  Future<bool> saveToken(String token) async {
    return await storageService.setString(StorageKeys.authToken, token);
  }

  // Obtener token
  Future<String?> getToken() async {
    return storageService.getString(StorageKeys.authToken);
  }

  // Eliminar token
  Future<bool> removeToken() async {
    return await storageService.remove(StorageKeys.authToken);
  }

  // Verificar si existe token
  bool hasToken() {
    return storageService.containsKey(StorageKeys.authToken);
  }

  // Verificar si el token es válido (básico)
  Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      return false;
    }
    // Aquí podrías agregar lógica adicional para verificar expiración
    return true;
  }
}