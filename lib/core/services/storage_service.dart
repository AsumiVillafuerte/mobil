// lib/core/services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  SharedPreferences? _prefs;

  // Inicializar SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Guardar String
  Future<bool> setString(String key, String value) async {
    if (_prefs == null) await init();
    return await _prefs!.setString(key, value);
  }

  // Obtener String
  String? getString(String key) {
    return _prefs?.getString(key);
  }

  // Guardar Int
  Future<bool> setInt(String key, int value) async {
    if (_prefs == null) await init();
    return await _prefs!.setInt(key, value);
  }

  // Obtener Int
  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  // Guardar Bool
  Future<bool> setBool(String key, bool value) async {
    if (_prefs == null) await init();
    return await _prefs!.setBool(key, value);
  }

  // Obtener Bool
  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  // Guardar Double
  Future<bool> setDouble(String key, double value) async {
    if (_prefs == null) await init();
    return await _prefs!.setDouble(key, value);
  }

  // Obtener Double
  double? getDouble(String key) {
    return _prefs?.getDouble(key);
  }

  // Guardar List<String>
  Future<bool> setStringList(String key, List<String> value) async {
    if (_prefs == null) await init();
    return await _prefs!.setStringList(key, value);
  }

  // Obtener List<String>
  List<String>? getStringList(String key) {
    return _prefs?.getStringList(key);
  }

  // Eliminar un valor
  Future<bool> remove(String key) async {
    if (_prefs == null) await init();
    return await _prefs!.remove(key);
  }

  // Verificar si existe una key
  bool containsKey(String key) {
    return _prefs?.containsKey(key) ?? false;
  }

  // Limpiar todo el storage
  Future<bool> clear() async {
    if (_prefs == null) await init();
    return await _prefs!.clear();
  }

  // Obtener todas las keys
  Set<String> getKeys() {
    return _prefs?.getKeys() ?? {};
  }
}