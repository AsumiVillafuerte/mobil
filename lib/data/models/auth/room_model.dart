// lib/data/models/room/room_model.dart

class RoomModel {
  final int idRoom;
  final String number;
  final String type;
  final String description;
  final double pricePerNight;
  final int capacity;
  final String state;

  RoomModel({
    required this.idRoom,
    required this.number,
    required this.type,
    required this.description,
    required this.pricePerNight,
    required this.capacity,
    required this.state,
  });

  // ✅ fromJson CORREGIDO con los nombres reales del backend
  factory RoomModel.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Parseando RoomModel desde JSON:');
      print('Raw JSON: $json');
      
      return RoomModel(
        idRoom: parseInt(json['idRoom']) ?? 0,
        // ✅ El backend envía 'roomNumber', no 'number'
        number: json['roomNumber']?.toString() ?? '',
        // ✅ El backend envía 'roomType', no 'type'
        type: json['roomType']?.toString() ?? '',
        // ✅ El backend envía 'roomDescription', no 'description'
        description: json['roomDescription']?.toString() ?? '',
        // ✅ El backend envía 'costPerDay', no 'pricePerNight'
        pricePerNight: parseDouble(json['costPerDay']) ?? 0.0,
        // ✅ El backend envía 'roomCapacity', no 'capacity'
        capacity: parseInt(json['roomCapacity']) ?? 1,
        // ✅ El backend envía 'roomState', no 'state'
        state: json['roomState']?.toString() ?? 'A',
      );
    } catch (e, stackTrace) {
      print('❌ Error parseando RoomModel: $e');
      print('StackTrace: $stackTrace');
      rethrow;
    }
  }

  // ✅ Helpers para parsing seguro
  static int? parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  static double? parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'idRoom': idRoom,
      'roomNumber': number,        // Usar el nombre del backend
      'roomType': type,            // Usar el nombre del backend
      'roomDescription': description, // Usar el nombre del backend
      'costPerDay': pricePerNight, // Usar el nombre del backend
      'roomCapacity': capacity,    // Usar el nombre del backend
      'roomState': state,          // Usar el nombre del backend
    };
  }

  // ✅ Getters útiles
  bool get isAvailable => state == 'A' || state.toLowerCase() == 'disponible';
  bool get isOccupied => state == 'I' || state.toLowerCase() == 'Inactivo';

  @override
  String toString() {
    return 'RoomModel(idRoom: $idRoom, number: $number, type: $type, price: $pricePerNight)';
  }
}