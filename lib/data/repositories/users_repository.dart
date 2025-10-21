// lib/data/repositories/users_repository.dart
import '../datasources/remote/users_api.dart';
import '../models/auth/user_model.dart';

class UsersRepository {
  final UsersApi _usersApi;

  UsersRepository(this._usersApi);

  // ==========================================
  // 📋 LISTAR USUARIOS
  // ==========================================
  
  Future<List<UserModel>> getAllUsers() async {
    return await _usersApi.getAllUsers();
  }

  Future<List<UserModel>> getUsersByState(String state) async {
    return await _usersApi.getUsersByState(state);
  }

  Future<List<UserModel>> getUsersByRole(int roleId) async {
    return await _usersApi.getUsersByRole(roleId);
  }

  Future<List<UserModel>> getUsersByRoleAndState(int roleId, String state) async {
    return await _usersApi.getUsersByRoleAndState(roleId, state);
  }

  Future<UserModel> getUserById(int idUser) async {
    return await _usersApi.getUserById(idUser);
  }

  // ==========================================
  // ✏️ CREAR Y ACTUALIZAR USUARIOS
  // ==========================================
  
  /// Crear usuario (usado por cualquier formulario de creación)
  Future<UserModel> createUser(Map<String, dynamic> userData) async {
    return await _usersApi.createUser(userData);
  }

  /// Alias para registro (compatibilidad con código existente)
  Future<UserModel> registerUser(Map<String, dynamic> userData) async {
    return await _usersApi.createUser(userData);
  }

  /// Alias para admin (compatibilidad con código existente)
  Future<UserModel> createUserByAdmin(Map<String, dynamic> userData) async {
    return await _usersApi.createUser(userData);
  }

  /// Actualizar usuario
  Future<UserModel> updateUser(Map<String, dynamic> userData) async {
    return await _usersApi.updateUser(userData);
  }

  // ==========================================
  // 🗑️ ELIMINAR Y RESTAURAR (SOFT DELETE)
  // ==========================================
  
  Future<void> deleteUser(int idUser) async {
    await _usersApi.deleteUser(idUser);
  }

  Future<void> restoreUser(int idUser) async {
    await _usersApi.restoreUser(idUser);
  }

  // ==========================================
  // 🔄 MÉTODOS AUXILIARES
  // ==========================================
  
  /// Toggle estado del usuario (eliminar o restaurar)
  Future<void> toggleUserStatus(UserModel user) async {
    if (user.isActive) {
      await deleteUser(user.idUser);
    } else {
      await restoreUser(user.idUser);
    }
  }
}