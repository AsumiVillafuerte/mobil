// lib/presentation/screens/rooms/rooms_list_screen.dart

import 'package:flutter/material.dart';
import 'package:myapp/data/models/auth/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../providers/rooms_provider.dart';
import '../../../../data/models/auth/room_model.dart';
import 'room_detail_screen.dart';
import 'create_room_screen.dart';
import 'edit_room_screen.dart';

class RoomsListScreen extends StatefulWidget {
  final UserModel? user;
  
  const RoomsListScreen({super.key, this.user});

  @override
  State<RoomsListScreen> createState() => _RoomsListScreenState();
}

class _RoomsListScreenState extends State<RoomsListScreen> {
  String _searchQuery = '';
  String? _selectedState; // null = Todos, 'Disponible', 'Ocupada'
  String? _selectedType; // null = Todos, 'Simple', 'Doble', etc.
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoomsProvider>().fetchRooms();
    });
  }

  List<RoomModel> _applyFilters(List<RoomModel> rooms) {
    var filtered = rooms;

    // Filtro de búsqueda
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((room) {
        return room.number.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            room.type.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            room.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Filtro de estado
    if (_selectedState != null) {
      filtered = filtered.where((room) {
        if (_selectedState == 'Disponible') {
          return room.isAvailable;
        } else if (_selectedState == 'Ocupada') {
          return !room.isAvailable;
        }
        return true;
      }).toList();
    }

    // Filtro de tipo
    if (_selectedType != null) {
      filtered = filtered.where((room) {
        return room.type.toLowerCase() == _selectedType!.toLowerCase();
      }).toList();
    }

    return filtered;
  }

  List<String> _getAvailableTypes(List<RoomModel> rooms) {
    return rooms.map((room) => room.type).toSet().toList()..sort();
  }

  void _showFilterModal() {
    String? tempState = _selectedState;
    String? tempType = _selectedType;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final provider = context.read<RoomsProvider>();
            final availableTypes = _getAvailableTypes(provider.rooms);

            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.filter_list,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Filtrar Habitaciones',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Filtro de Estado
                  const Text(
                    'Estado',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FilterChip(
                        label: 'Todos',
                        selected: tempState == null,
                        onTap: () {
                          setModalState(() => tempState = null);
                        },
                      ),
                      _FilterChip(
                        label: 'Disponible',
                        selected: tempState == 'Disponible',
                        onTap: () {
                          setModalState(() => tempState = 'Disponible');
                        },
                      ),
                      _FilterChip(
                        label: 'Ocupada',
                        selected: tempState == 'Ocupada',
                        onTap: () {
                          setModalState(() => tempState = 'Ocupada');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Filtro de Tipo
                  const Text(
                    'Tipo de Habitación',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FilterChip(
                        label: 'Todos',
                        selected: tempType == null,
                        onTap: () {
                          setModalState(() => tempType = null);
                        },
                      ),
                      ...availableTypes.map((type) => _FilterChip(
                            label: type,
                            selected: tempType == type,
                            onTap: () {
                              setModalState(() => tempType = type);
                            },
                          )),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Botones
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              tempState = null;
                              tempType = null;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: Color(0xFF1565C0)),
                          ),
                          child: const Text(
                            'Limpiar Filtros',
                            style: TextStyle(
                              color: Color(0xFF1565C0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedState = tempState;
                              _selectedType = tempType;
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Aplicar',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handleDelete(RoomModel room) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Está seguro de eliminar la habitación ${room.number}?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) { 
      // await context.read<RoomsProvider>().deleteRoom(room.id);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Habitación ${room.number} eliminada'),
          backgroundColor: Colors.green,
        ),
      );
      if (mounted) {
        context.read<RoomsProvider>().fetchRooms();
      }
    }
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_selectedState != null) count++;
    if (_selectedType != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Habitaciones',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.white),
                onPressed: _showFilterModal,
              ),
              if (_getActiveFilterCount() > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_getActiveFilterCount()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Consumer<RoomsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchRooms(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (provider.rooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.meeting_room_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No hay habitaciones registradas',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          final filteredRooms = _applyFilters(provider.rooms);

          return Column(
            children: [
              // Barra de búsqueda
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar por número, tipo o descripción...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),

              // Chips de filtros activos
              if (_getActiveFilterCount() > 0)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (_selectedState != null)
                        Chip(
                          label: Text(_selectedState!),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () {
                            setState(() => _selectedState = null);
                          },
                          backgroundColor: Colors.blue.shade50,
                          labelStyle: const TextStyle(
                            color: Color(0xFF1565C0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      if (_selectedType != null)
                        Chip(
                          label: Text(_selectedType!),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () {
                            setState(() => _selectedType = null);
                          },
                          backgroundColor: Colors.orange.shade50,
                          labelStyle: TextStyle(
                            color: Colors.orange.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              
              // Lista de habitaciones
              Expanded(
                child: filteredRooms.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'No se encontraron habitaciones',
                              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => provider.fetchRooms(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredRooms.length,
                          itemBuilder: (context, index) {
                            final room = filteredRooms[index];
                            return _SlidableRoomCard( 
                              key: ValueKey(room.number),
                              room: room,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RoomDetailScreen(room: room),
                                  ),
                                );
                              },
                              onEdit: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditRoomScreen(room: room),
                                  ),
                                ).then((_) => provider.fetchRooms());
                              },
                              onDelete: () => _handleDelete(room),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateRoomScreen()),
          ).then((_) => context.read<RoomsProvider>().fetchRooms());
        },
        backgroundColor: const Color(0xFF1565C0),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nueva Habitación',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

// ============================================================================
// Widget para chips de filtro
// ============================================================================

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1565C0) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? const Color(0xFF1565C0) : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// 🎯 WIDGET AGREGADO: Implementación de la acción circular (Verde/Rojo)
class _CircleSlidableAction extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final String label; 

  const _CircleSlidableAction({
    required this.icon,
    required this.backgroundColor,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.transparent, // Fondo transparente
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50, // Tamaño del círculo
              height: 50, // Tamaño del círculo
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            // Si quieres la etiqueta, descomenta esta parte:
            // const SizedBox(height: 4), 
            // Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// WIDGET MODIFICADO PARA EL DESLIZAMIENTO CON SLIDABLE Y BOTONES CIRCULARES
// ============================================================================

class _SlidableRoomCard extends StatelessWidget {
  final RoomModel room;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SlidableRoomCard({
    super.key,
    required this.room,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    const double cardRadius = 16.0; 

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardRadius),
        child: Slidable(
          key: ValueKey(room.number),
          
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            // 🎯 CORRECCIÓN: Aumentamos ligeramente el extentRatio para dar más espacio.
            // Esto debería eliminar el desbordamiento. Si aún persiste, aumenta un poco más.
            extentRatio: 0.35, 
            children: [
              CustomSlidableAction(
                flex: 1, 
                backgroundColor: Colors.transparent, 
                onPressed: (context) { /* No action on the CustomSlidableAction itself */ },
                child: Align( 
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min, 
                    children: [
                      _CircleSlidableAction(
                        icon: Icons.edit_outlined, 
                        backgroundColor: const Color(0xFF4CAF50), 
                        onPressed: onEdit,
                        label: 'Editar',
                      ),
                      const SizedBox(width: 8), // 🎯 CORRECCIÓN: Espacio reducido a 8
                      _CircleSlidableAction(
                        icon: Icons.delete_outline, 
                        backgroundColor: const Color(0xFFF44336), 
                        onPressed: onDelete,
                        label: 'Eliminar',
                      ),
                      const SizedBox(width: 8), // 🎯 CORRECCIÓN: Espacio final reducido a 8
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          child: _RoomCard(
            room: room,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Widget para cada tarjeta de habitación (Mantener el borde redondeado)
// ============================================================================

class _RoomCard extends StatelessWidget {
  final RoomModel room;
  final VoidCallback onTap;

  const _RoomCard({
    required this.room,
    required this.onTap,
  });

  Color _getAvatarColor() {
    switch (room.type.toLowerCase()) {
      case 'simple':
        return Colors.blue;
      case 'doble':
        return Colors.purple;
      case 'matrimonial':
      case 'matrimonial_vip': 
        return Colors.pink;
      case 'suite':
        return Colors.orange;
      case 'suite presidencial':
        return Colors.red;
      default:
        return Colors.teal;
    }
  }

  String _getInitials() {
    return room.number.substring(0, room.number.length > 2 ? 2 : room.number.length);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero, 
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: _getAvatarColor(),
                    child: Text(
                      _getInitials(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                room.type,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange.shade800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: room.isAvailable 
                                    ? Colors.green.shade100 
                                    : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                room.isAvailable ? 'Disponible' : 'Ocupada',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: room.isAvailable 
                                      ? Colors.green.shade800 
                                      : Colors.red.shade800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_left,
                    color: Colors.grey.shade400,
                    size: 32,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.email_outlined, size: 18, color: Color(0xFF1976D2)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      room.description,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.people_outline, size: 18, color: Color(0xFF4CAF50)),
                  const SizedBox(width: 8),
                  Text(
                    'Capacidad: ${room.capacity} personas',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.attach_money, size: 18, color: Color(0xFF9C27B0)),
                  const SizedBox(width: 8),
                  Text(
                    'S/. ${room.pricePerNight.toStringAsFixed(2)} por noche',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9C27B0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}