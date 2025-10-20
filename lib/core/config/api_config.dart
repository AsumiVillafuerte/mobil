// lib/core/config/api_config.dart
class ApiConfig {
  // ⭐ URL BASE DEL BACKEND
  static const String baseUrl = 'http://localhost:8085';
  
  // Timeouts
  static const int connectionTimeout = 30000; // 30 segundos
  static const int receiveTimeout = 30000; // 30 segundos
  
  // Headers comunes
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}