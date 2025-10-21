// lib/presentation/providers/rooms_provider.dart

import 'package:flutter/material.dart';
import '../../data/models/auth/room_model.dart';
import '../../data/repositories/rooms_repository.dart';

class RoomsProvider with ChangeNotifier {
  final RoomsRepository _repository;

  RoomsProvider(this._repository);

  // ✅ Lista de habitaciones cargadas
  List<RoomModel> _rooms = [];
  List<RoomModel> get rooms => _rooms;

  // ✅ Estado de carga
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ✅ Mensajes de error
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ✅ Método principal para cargar habitaciones
  Future<void> fetchRooms() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();  // Notificar a la UI para que muestre el estado de carga.

    try {
      print('🔄 Cargando habitaciones...');
      
      // Llamamos al repositorio para obtener todas las habitaciones.
      _rooms = await _repository.getAllRooms();
      
      print('✅ ${_rooms.length} habitaciones cargadas');
      _errorMessage = null;
      
    } catch (e) {
      // En caso de error, asignamos un mensaje y limpiamos la lista de habitaciones.
      _errorMessage = 'Error al cargar habitaciones: $e';
      print('❌ Error en fetchRooms: $e');
      _rooms = [];
    } finally {
      _isLoading = false;
      notifyListeners();  // Notificamos a la UI para que oculte el estado de carga.
    }
  }

  // ✅ Filtrar habitaciones por estado
  List<RoomModel> getRoomsByState(String state) {
    return _rooms.where((room) => room.state == state).toList();
  }

  // ✅ Obtener habitaciones disponibles
  List<RoomModel> get availableRooms {
    return _rooms.where((room) => room.isAvailable).toList();
  }

  // ✅ Limpiar error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}