// lib/data/datasources/remote/users_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/auth/user_model.dart';
import '../../../core/services/http_service.dart';
import '../../../core/constants/api_endpoints.dart';

class UsersApi {
  final HttpService _httpService;

  UsersApi(this._httpService);

  // Obtener todos los usuarios
  Future<List<UserModel>> getAllUsers() async {
    final response = await _httpService.get(ApiEndpoints.users);
    
    // Manejar respuesta que puede ser array directo o con 'data'
    if (response is List) {
      return response.map((json) => UserModel.fromJson(json)).toList();
    } else if (response is Map && response.containsKey('data')) {
      final List<dynamic> data = response['data'];
      return data.map((json) => UserModel.fromJson(json)).toList();
    }
    
    return [];
  }

  // Obtener usuarios por estado
  Future<List<UserModel>> getUsersByState(String state) async {
    final response = await _httpService.get('${ApiEndpoints.users}/state/$state');
    final List<dynamic> data = response is List ? response : (response['data'] ?? []);
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  // Obtener usuarios por rol
  Future<List<UserModel>> getUsersByRole(int roleId) async {
    final response = await _httpService.get('${ApiEndpoints.users}/role/$roleId');
    final List<dynamic> data = response is List ? response : (response['data'] ?? []);
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  // Obtener usuarios por rol y estado
  Future<List<UserModel>> getUsersByRoleAndState(int roleId, String state) async {
    final response = await _httpService.get('${ApiEndpoints.users}/role/$roleId/state/$state');
    final List<dynamic> data = response is List ? response : (response['data'] ?? []);
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  // Obtener usuario por ID
  Future<UserModel> getUserById(int idUser) async {
    final response = await _httpService.get('${ApiEndpoints.users}/$idUser');
    final data = response is Map && response.containsKey('data') ? response['data'] : response;
    return UserModel.fromJson(data);
  }

  // Crear usuario
  Future<UserModel> createUser(Map<String, dynamic> userData) async {
    try {
      print('📤 CREATE USER - Enviando datos:');
      print(jsonEncode(userData));

      final response = await _httpService.post(
        '${ApiEndpoints.users}/save',
        userData,
      );

      print('📥 CREATE USER - Respuesta:');
      print(response);

      final userDataResponse = response is Map && response.containsKey('data') 
          ? response['data'] 
          : response;
          
      return UserModel.fromJson(userDataResponse);
    } catch (e) {
      print('❌ Error en createUser: $e');
      rethrow;
    }
  }

  // Actualizar usuario - ✅ MANEJA RESPUESTAS STRING Y JSON
  Future<UserModel> updateUser(Map<String, dynamic> userData) async {
    try {
      print('═══════════════════════════════');
      print('📤 UPDATE USER - Enviando datos:');
      print('═══════════════════════════════');
      
      // ✅ CORREGIR: Asegurar que registrationDate existe
      if (!userData.containsKey('registrationDate') || userData['registrationDate'] == null) {
        // Si no tiene fecha, usar la actual en el formato que espera el backend
        userData['registrationDate'] = DateTime.now().toIso8601String();
        print('⚠️ registrationDate no estaba presente, agregado: ${userData['registrationDate']}');
      }
      
      print(jsonEncode(userData));
      print('═══════════════════════════════');

      // Importar ApiConfig
      final url = Uri.parse('http://localhost:8085${ApiEndpoints.users}/update');
      final token = await _httpService.tokenService.getToken();
      
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      print('🚀 PUT Request: $url');
      print('📤 Headers: $headers');

      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(userData),
      );

      print('═══════════════════════════════');
      print('📥 UPDATE USER - Respuesta:');
      print('═══════════════════════════════');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.body}');
      print('═══════════════════════════════');

      // ✅ MANEJAR DIFERENTES RESPUESTAS
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Respuesta exitosa
        if (response.body.isEmpty) {
          print('✅ Respuesta vacía, usando datos enviados');
          return UserModel.fromJson(userData);
        }

        try {
          final data = jsonDecode(response.body);
          
          // Si es un objeto User directo
          if (data is Map && data.containsKey('idUser')) {
            print('✅ Respuesta con User directo');
            return UserModel.fromJson(Map<String, dynamic>.from(data));
          }
          
          // Si viene con 'data'
          if (data is Map && data.containsKey('data')) {
            print('✅ Respuesta con data wrapper');
            return UserModel.fromJson(Map<String, dynamic>.from(data['data']));
          }

          // Fallback
          print('⚠️ Estructura inesperada, usando datos enviados');
          return UserModel.fromJson(userData);
        } catch (e) {
          print('⚠️ Error parseando JSON: $e');
          return UserModel.fromJson(userData);
        }
      } else if (response.statusCode == 403) {
        // Error de permisos
        String errorMessage = 'No tienes permisos para actualizar este usuario';
        
        if (response.body.isNotEmpty) {
          // Intentar parsear como JSON
          try {
            final errorData = jsonDecode(response.body);
            errorMessage = errorData['message'] ?? errorData.toString();
          } catch (e) {
            // Si no es JSON, es un String plano
            errorMessage = response.body;
          }
        }
        
        print('❌ Error 403: $errorMessage');
        throw Exception(errorMessage);
      } else {
        // Otros errores
        String errorMessage = 'Error al actualizar usuario (${response.statusCode})';
        
        if (response.body.isNotEmpty) {
          try {
            final errorData = jsonDecode(response.body);
            errorMessage = errorData['message'] ?? errorData['error'] ?? errorData.toString();
          } catch (e) {
            errorMessage = response.body;
          }
        }
        
        print('❌ Error ${response.statusCode}: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Error en updateUser: $e');
      rethrow;
    }
  }

// Eliminar usuario (soft delete) - ✅ SIMPLIFICADO
Future<void> deleteUser(int idUser) async {
  try {
    print('🗑️ Eliminando usuario: $idUser');
    
    await _httpService.patch(
      '${ApiEndpoints.users}/delete/$idUser',
      {}, // Body vacío
    );
    
    print('✅ Usuario eliminado correctamente');
  } catch (e) {
    print('❌ Error en deleteUser: $e');
    // No intentar parsear, solo relanzar el error
    rethrow;
  }
}

// Restaurar usuario - ✅ SIMPLIFICADO
Future<void> restoreUser(int idUser) async {
  try {
    print('♻️ Restaurando usuario: $idUser');
    
    await _httpService.patch(
      '${ApiEndpoints.users}/restore/$idUser',
      {}, // Body vacío
    );
    
    print('✅ Usuario restaurado correctamente');
  } catch (e) {
    print('❌ Error en restoreUser: $e');
    rethrow;
  }
}

}