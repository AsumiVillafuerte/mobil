// lib/presentation/providers/users_provider.dart
import 'package:flutter/material.dart';
import 'package:myapp/data/models/auth/user_model.dart';
import 'package:myapp/data/repositories/users_repository.dart';

class UsersProvider with ChangeNotifier {
  final UsersRepository _repository;

  UsersProvider(this._repository);

  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _currentFilter = 'Todos';
  int? _selectedRoleId;

  // Getters
  List<UserModel> get users => _filteredUsers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentFilter => _currentFilter;
  int? get selectedRoleId => _selectedRoleId;

  // Cargar todos los usuarios
  Future<void> loadUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await _repository.getAllUsers();
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al cargar usuarios: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Crear usuario desde admin (puede asignar rol)
  Future<bool> createUserByAdmin(Map<String, dynamic> userData) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.createUserByAdmin(userData);
      await loadUsers(); // recargar lista de usuarios
      return true;
    } catch (e) {
      _errorMessage = 'Error al crear usuario: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Registro público (rol cliente automático)
  Future<bool> registerUser(Map<String, dynamic> userData) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.registerUser(userData);
      return true;
    } catch (e) {
      _errorMessage = 'Error al registrarse: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Actualizar usuario
  Future<bool> updateUser(Map<String, dynamic> userData) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.updateUser(userData);
      await loadUsers();
      return true;
    } catch (e) {
      _errorMessage = 'Error al actualizar usuario: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Eliminar usuario (soft delete)
  Future<bool> deleteUser(int idUser) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.deleteUser(idUser);
      await loadUsers();
      return true;
    } catch (e) {
      _errorMessage = 'Error al eliminar usuario: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Restaurar usuario
  Future<bool> restoreUser(int idUser) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.restoreUser(idUser);
      await loadUsers();
      return true;
    } catch (e) {
      _errorMessage = 'Error al restaurar usuario: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Toggle status (Eliminar o Restaurar)
  Future<bool> toggleUserStatus(UserModel user) async {
    if (user.isActive) {
      return await deleteUser(user.idUser);
    } else {
      return await restoreUser(user.idUser);
    }
  }

  // Filtrar por estado
  void filterByState(String filter) {
    _currentFilter = filter;
    _applyFilters();
    notifyListeners();
  }

  // Filtrar por rol
  void filterByRole(int? roleId) {
    _selectedRoleId = roleId;
    _applyFilters();
    notifyListeners();
  }

  // Limpiar filtros
  void clearFilters() {
    _currentFilter = 'Todos';
    _selectedRoleId = null;
    _applyFilters();
    notifyListeners();
  }

  // Aplicar filtros
  void _applyFilters() {
    _filteredUsers = _users.where((user) {
      // Filtro por estado
      bool matchesStatus = true;
      if (_currentFilter == 'Activos') {
        matchesStatus = user.isActive;
      } else if (_currentFilter == 'Inactivos') {
        matchesStatus = !user.isActive;
      }

      // Filtro por rol
      bool matchesRole = true;
      if (_selectedRoleId != null) {
        matchesRole = user.role.idRole == _selectedRoleId;
      }

      return matchesStatus && matchesRole;
    }).toList();
  }
}
