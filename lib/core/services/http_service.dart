// lib/core/services/http_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'token_service.dart';

class HttpService {
  final TokenService tokenService;

  HttpService(this.tokenService);

  Future<Map<String, String>> _getHeaders({bool needsAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (needsAuth) {
      final token = await tokenService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // GET
  Future<dynamic> get(String endpoint, {bool needsAuth = true}) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders(needsAuth: needsAuth);

      final response = await http.get(url, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return {};
        return jsonDecode(response.body);
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // POST
  Future<dynamic> post(String endpoint, dynamic body, {bool needsAuth = true}) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders(needsAuth: needsAuth);

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return {};
        return jsonDecode(response.body);
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // PUT - Para users_api
  Future<http.Response> put(String endpoint, dynamic body, {bool needsAuth = true}) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders(needsAuth: needsAuth);

      return await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
    } catch (e) {
      rethrow;
    }
  }

  // PATCH - ✅ CORREGIDO: No parsea, solo valida status
  Future<void> patch(String endpoint, dynamic body, {bool needsAuth = true}) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders(needsAuth: needsAuth);

      print('🚀 PATCH: $url');

      final response = await http.patch(
        url,
        headers: headers,
        body: body != null && body.toString() != '{}' ? jsonEncode(body) : '{}',
      );

      print('📊 Status: ${response.statusCode}, Body: ${response.body}');

      // ✅ Solo validar status, NO parsear el body
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('✅ PATCH exitoso');
        return; // ✅ Éxito sin parsear
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ PATCH Error: $e');
      rethrow;
    }
  }

  // DELETE
  Future<dynamic> delete(String endpoint, {bool needsAuth = true}) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders(needsAuth: needsAuth);

      final response = await http.delete(url, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return {};
        return jsonDecode(response.body);
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}