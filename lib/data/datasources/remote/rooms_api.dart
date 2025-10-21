// lib/data/datasources/remote/rooms_api.dart
import '../../../core/services/http_service.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../models/auth/room_model.dart';
import 'package:logger/logger.dart';  // Logger para depuración

class RoomsApi {
  final HttpService _httpService;
  final logger = Logger(); // Logger para registrar los errores

  RoomsApi(this._httpService);

  /// 📋 MÉTODO PARA OBTENER TODAS LAS HABITACIONES
  Future<List<RoomModel>> getAllRooms() async {
    try {
      // Realizando la llamada a la API
      logger.i('📡 Llamando a: ${ApiEndpoints.rooms}');
      
      // Obteniendo la respuesta de la API
      final response = await _httpService.get(ApiEndpoints.rooms);

      if (response == null) {
        logger.w('⚠ Respuesta vacía o nula');
        return [];
      }

      if (response is List) {
        return response
            .map((json) => RoomModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      if (response is Map && response.containsKey('data')) {
        return (response['data'] as List)
            .map((json) => RoomModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      logger.w('⚠ Formato de respuesta inesperado');
      return [];

    } catch (e, stackTrace) {
      logger.e('❌ Error en getAllRooms: $e');
      logger.e('StackTrace: $stackTrace');
      rethrow;
    }
  }

  /// 📋 MÉTODO PARA OBTENER HABITACIÓN POR ID
  Future<RoomModel> getRoomById(int idRoom) async {
    try {
      // Realizando la llamada a la API para obtener una habitación por ID
      logger.i('📡 Llamando a: ${ApiEndpoints.getRoomById(idRoom)}');
      
      final response = await _httpService.get(ApiEndpoints.getRoomById(idRoom));

      // Verificando si la respuesta contiene la clave 'data'
      final data = response is Map && response.containsKey('data')
          ? response['data']
          : response;

      return RoomModel.fromJson(data);

    } catch (e, stackTrace) {
      logger.e('❌ Error en getRoomById: $e');
      logger.e('StackTrace: $stackTrace');
      rethrow;
    }
  }
}