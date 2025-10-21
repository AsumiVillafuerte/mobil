// lib/data/models/auth/role_model.dart

class RoleModel {
  final int idRole;
  final String name;
  final String state;

  RoleModel({
    required this.idRole,
    required this.name,
    this.state = 'A', // ✅ Valor por defecto
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Parseando RoleModel desde JSON:');
      print('Raw JSON: $json');
      
      return RoleModel(
        // ✅ Parsing robusto de idRole (puede venir como String o int)
        idRole: _parseInt(json['idRole']) ?? 0,
        name: json['name']?.toString() ?? 'Sin rol',
        state: json['state']?.toString() ?? 'A',
      );
    } catch (e) {
      print('❌ Error parseando RoleModel:');
      print('Error: $e');
      print('JSON recibido: $json');
      
      // Retornar un rol por defecto en caso de error
      return RoleModel(idRole: 0, name: 'Error al cargar rol', state: 'A');
    }
  }

  // Helper para parsear int de manera segura
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is double) return value.toInt();
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'idRole': idRole,
      'name': name,
      'state': state,
    };
  }

  bool get isActive => state == 'A';

  // Helper para debugging
  @override
  String toString() {
    return 'RoleModel(idRole: $idRole, name: $name, state: $state)';
  }

  // Roles predefinidos para facilitar comparaciones
  static const int ADMIN = 1;
  static const int RECEPTIONIST = 2;
  static const int CLEANING = 3;
  static const int CLIENT = 4;

  bool get isAdmin => idRole == ADMIN;
  bool get isReceptionist => idRole == RECEPTIONIST;
  bool get isCleaning => idRole == CLEANING;
  bool get isClient => idRole == CLIENT;
}