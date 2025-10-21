// lib/data/models/auth/user_model.dart
import 'role_model.dart';

class UserModel {
  final int idUser;
  final String names;
  final String surnames;
  final String? gender;
  final String email;
  final String? phone;
  final String documentType;
  final String documentNumber;
  final RoleModel role;
  final String? shift;
  final String? registrationDate;
  final String state;

  UserModel({
    required this.idUser,
    required this.names,
    required this.surnames,
    this.gender,
    required this.email,
    this.phone,
    required this.documentType,
    required this.documentNumber,
    required this.role,
    this.shift,
    this.registrationDate,
    required this.state,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Parseando UserModel desde JSON:');
      print('Raw JSON: $json');
      
      return UserModel(
        // ✅ Parsing robusto de idUser (puede venir como String o int)
        idUser: parseInt(json['idUser']) ?? 0,
        
        names: json['names']?.toString() ?? '',
        surnames: json['surnames']?.toString() ?? '',
        gender: json['gender']?.toString(),
        email: json['email']?.toString() ?? '',
        phone: json['phone']?.toString(),
        documentType: json['documentType']?.toString() ?? '',
        documentNumber: json['documentNumber']?.toString() ?? '',
        
        // ✅ Parsing robusto del role
        role: json['role'] != null 
            ? RoleModel.fromJson(json['role'] is Map<String, dynamic> 
                ? json['role'] 
                : {'idRole': json['role'], 'name': 'Unknown'})
            : RoleModel(idRole: 0, name: 'Sin rol', state: 'A'),
        
        shift: json['shift']?.toString(),
        registrationDate: json['registrationDate']?.toString(),
        state: json['state']?.toString() ?? 'A',
      );
    } catch (e, stackTrace) {
      print('❌ Error parseando UserModel:');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      print('JSON recibido: $json');
      rethrow;
    }
  }

  // Helper para parsear int de manera segura
  static int? parseInt(dynamic value) {
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
      'idUser': idUser,
      'names': names,
      'surnames': surnames,
      'gender': gender,
      'email': email,
      'phone': phone,
      'documentType': documentType,
      'documentNumber': documentNumber,
      'role': role.toJson(),
      'shift': shift,
      // ✅ Asegurar que registrationDate siempre tenga un valor
      'registrationDate': registrationDate ?? DateTime.now().toIso8601String(),
      'state': state,
    };
  }

  String get fullName => '$names $surnames';
  bool get isActive => state == 'A';

  // Helper para debugging
  @override
  String toString() {
    return 'UserModel(idUser: $idUser, names: $names, surnames: $surnames, email: $email, role: ${role.name})';
  }
}