import 'package:flutter/material.dart';
import '../../../../data/models/auth/room_model.dart';
import 'edit_room_screen.dart';

class RoomDetailScreen extends StatelessWidget {
  final RoomModel room;

  const RoomDetailScreen({
    super.key,
    required this.room,
  });

  Color _getAvatarColor() {
    switch (room.type.toLowerCase()) {
      case 'simple':
        return Colors.blue;
      case 'doble':
        return Colors.purple;
      case 'matrimonial':
        return Colors.pink;
      case 'suite':
        return Colors.orange;
      case 'suite presidencial':
        return Colors.red;
      default:
        return const Color(0xFF1565C0);
    }
  }

  String _getInitials() {
    return room.number.length > 2 
        ? room.number.substring(0, 2).toUpperCase() 
        : room.number.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Detalles de Habitación',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRoomScreen(room: room),
                ),
              );
            },
            tooltip: 'Editar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con avatar y nombre
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Column(
                children: [
                  // Avatar circular
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: _getAvatarColor(),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _getAvatarColor().withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Nombre de la habitación
                  Text(
                    'Habitación ${room.number}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Badge de tipo
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF1565C0),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      room.type,
                      style: const TextStyle(
                        color: Color(0xFF1565C0),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Lista de detalles
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildDetailItem(
                    icon: Icons.meeting_room,
                    iconColor: const Color(0xFF1565C0),
                    label: 'N° Habitación',
                    value: room.number,
                  ),
                  _buildDivider(),
                  
                  _buildDetailItem(
                    icon: Icons.bed,
                    iconColor: Colors.purple,
                    label: 'Tipo de Habitación',
                    value: room.type,
                  ),
                  _buildDivider(),
                  
                  _buildDetailItem(
                    icon: Icons.people,
                    iconColor: Colors.orange,
                    label: 'Capacidad',
                    value: '${room.capacity} persona${room.capacity > 1 ? 's' : ''}',
                  ),
                  _buildDivider(),
                  
                  _buildDetailItem(
                    icon: Icons.attach_money,
                    iconColor: Colors.green,
                    label: 'Costo por Día',
                    value: '${room.pricePerNight.toStringAsFixed(0)} soles',
                  ),
                  _buildDivider(),
                  
                  _buildDetailItem(
                    icon: Icons.door_front_door,
                    iconColor: room.isAvailable ? Colors.green : Colors.red,
                    label: 'Actividad/Habitación',
                    value: room.isAvailable ? 'Disponible' : 'Ocupada',
                  ),
                  _buildDivider(),
                  
                  _buildDetailItem(
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                    label: 'Estado Actual',
                    value: 'Activo',
                  ),
                ],
              ),
            ),
            
            // Descripción
            if (room.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.description,
                            color: Color(0xFF1565C0),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Descripción',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      room.description,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRoomScreen(room: room),
                ),
              );
            },
            icon: const Icon(Icons.edit, size: 20),
            label: const Text(
              'Editar Habitación',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // Icono
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          
          // Contenido
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey.shade200,
      ),
    );
  }
}