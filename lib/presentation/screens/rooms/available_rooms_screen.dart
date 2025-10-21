import 'package:flutter/material.dart';
import '../../../../data/models/auth/room_model.dart';
import '../../../../data/models/auth/user_model.dart';
import 'widgets/room_card_widget.dart';
import 'widgets/room_filter_widget.dart';
import 'room_detail_screen.dart';

class AvailableRoomsScreen extends StatefulWidget {
  final UserModel? user;

  const AvailableRoomsScreen({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  State<AvailableRoomsScreen> createState() => _AvailableRoomsScreenState();
}

class _AvailableRoomsScreenState extends State<AvailableRoomsScreen> {
  List<RoomModel> _allRooms = [];
  List<RoomModel> _filteredRooms = [];
  String _searchQuery = '';
  String? _selectedType;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAvailableRooms();
  }

  Future<void> _loadAvailableRooms() async {
    setState(() => _isLoading = true);
    
    // TODO: Reemplazar con llamada real al servicio
    await Future.delayed(const Duration(seconds: 1));
    
    // Datos de ejemplo (solo habitaciones disponibles)
    _allRooms = [
      RoomModel(
        idRoom: 1,
        number: '101',
        type: 'Simple',
        description: 'Habitación simple con vista a la ciudad, ideal para viajeros solos',
        pricePerNight: 80.00,
        capacity: 1,
        state: 'A',
      ),
      RoomModel(
        idRoom: 3,
        number: '201',
        type: 'Suite',
        description: 'Suite con sala de estar, balcón privado y vista panorámica',
        pricePerNight: 250.00,
        capacity: 3,
        state: 'A',
      ),
      RoomModel(
        idRoom: 4,
        number: '202',
        type: 'Doble',
        description: 'Habitación doble con dos camas individuales',
        pricePerNight: 120.00,
        capacity: 2,
        state: 'A',
      ),
      RoomModel(
        idRoom: 5,
        number: '301',
        type: 'Matrimonial',
        description: 'Habitación matrimonial con cama king size',
        pricePerNight: 180.00,
        capacity: 2,
        state: 'A',
      ),
    ];
    
    _filteredRooms = List.from(_allRooms);
    setState(() => _isLoading = false);
  }

  void _applyFilters() {
    setState(() {
      _filteredRooms = _allRooms.where((room) {
        bool matchesSearch = _searchQuery.isEmpty ||
            room.number.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            room.type.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            room.description.toLowerCase().contains(_searchQuery.toLowerCase());
        
        bool matchesType = _selectedType == null || room.type == _selectedType;
        
        return matchesSearch && matchesType;
      }).toList();
    });
  }

  void _handleSearch(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _handleFilterType(String? type) {
    _selectedType = type;
    _applyFilters();
  }

  void _handleBookRoom(RoomModel room) {
    // TODO: Navegar a pantalla de crear reserva
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reservar habitación ${room.number}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roomTypes = _allRooms.map((r) => r.type).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Habitaciones Disponibles',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadAvailableRooms,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner informativo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.green.shade300],
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Habitaciones Listas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Selecciona una habitación para hacer tu reserva',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Filtros
          RoomFilterWidget(
            onSearch: _handleSearch,
            onFilterType: _handleFilterType,
            roomTypes: roomTypes,
          ),
          
          // Contador de resultados
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredRooms.length} habitación${_filteredRooms.length != 1 ? 'es' : ''} disponible${_filteredRooms.length != 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (_searchQuery.isNotEmpty || _selectedType != null)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                        _selectedType = null;
                        _filteredRooms = List.from(_allRooms);
                      });
                    },
                    icon: const Icon(Icons.clear, size: 18),
                    label: const Text('Limpiar filtros'),
                  ),
              ],
            ),
          ),
          
          // Lista de habitaciones
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredRooms.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No hay habitaciones disponibles',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Intenta con otros filtros',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadAvailableRooms,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _filteredRooms.length,
                          itemBuilder: (context, index) {
                            final room = _filteredRooms[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RoomDetailScreen(room: room),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.green
                                                .withOpacity(0.2),
                                            child: Text(
                                              room.number,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Habitación ${room.number}',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .blue.shade50,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Text(
                                                        room.type,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .blue.shade700,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    const Icon(Icons.people,
                                                        size: 14,
                                                        color: Colors.grey),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '${room.capacity} personas',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.green
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        room.description,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          height: 1.4,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Precio por noche',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'S/. ${room.pricePerNight.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () =>
                                                _handleBookRoom(room),
                                            icon: const Icon(Icons.book_online,
                                                size: 20),
                                            label: const Text('Reservar'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                horizontal: 20,
                                                vertical: 12,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}