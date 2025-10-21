import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/auth/user_model.dart';
import '../../data/models/auth/register_request.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider(this._authRepository) {
    _checkAuthStatus();
  }

  AuthState _state = AuthState.initial;
  UserModel? _user;
  String? _errorMessage;

  AuthState get state => _state;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == AuthState.loading;
  bool get isAuthenticated => _state == AuthState.authenticated;

  Future<void> _checkAuthStatus() async {
    if (_authRepository.isLoggedIn()) {
      _user = _authRepository.getCurrentUser();
      if (_user != null) {
        _state = AuthState.authenticated;
        notifyListeners();
      }
    } else {
      _state = AuthState.unauthenticated;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepository.login(email, password);
      _user = response.user;
      _state = AuthState.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _user = null;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(RegisterRequest request) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.register(request);
      _state = AuthState.unauthenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _user = null;
    _state = AuthState.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _state = AuthState.unauthenticated;
    }
    notifyListeners();
  }
}