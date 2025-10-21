// lib/data/repositories/rooms_repository.dart

import '../datasources/remote/rooms_api.dart';
import '../models/auth/room_model.dart';

class RoomsRepository {
  final RoomsApi _roomsApi;

  RoomsRepository(this._roomsApi);

  Future<List<RoomModel>> getAllRooms() async {
    return await _roomsApi.getAllRooms();
  }

  Future<RoomModel> getRoomById(int id) async {
    return await _roomsApi.getRoomById(id);
  }

  // ... otros métodos
}