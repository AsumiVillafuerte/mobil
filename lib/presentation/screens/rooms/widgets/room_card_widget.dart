import 'package:flutter/material.dart';
import '../../../../data/models/auth/room_model.dart';

class RoomCardWidget extends StatelessWidget {
  final RoomModel room;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const RoomCardWidget({
    Key? key,
    required this.room,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  Color _getTypeColor() {
    switch (room.type.toLowerCase()) {
      case 'corporativa':
        return const Color(0xFFBBDEFB);
      case 'familiar':
        return const Color(0xFFE1BEE7);
      case 'individual':
        return const Color(0xFFFFE0B2);
      case 'matrimonial':
        return const Color(0xFFF8BBD0);
      default:
        return const Color(0xFFB2DFDB);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Título y Estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Habitación ${room.number}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: room.isAvailable 
                          ? const Color(0xFFC8E6C9) 
                          : const Color(0xFFFFCDD2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      room.isAvailable ? 'Disponible' : 'Ocupada',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: room.isAvailable 
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFC62828),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Contenido principal
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icono de cama
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFBBDEFB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.bed_outlined,
                      size: 48,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  
                  const SizedBox(width: 24),
                  
                  // Información
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge de tipo
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            room.type,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1976D2),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Descripción
                        Text(
                          room.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF616161),
                            height: 1.5,
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Piso
                        Row(
                          children: [
                            const Icon(
                              Icons.layers_outlined,
                              size: 20,
                              color: Color(0xFF757575),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Piso ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF757575),
                              ),
                            ),
                            Text(
                              room.number.substring(0, 1),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1976D2),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Precio
                        Row(
                          children: [
                            const Icon(
                              Icons.attach_money,
                              size: 20,
                              color: Color(0xFF757575),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'S/. ${room.pricePerNight.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Capacidad y estado
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 20,
                            color: Color(0xFFFF9800),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${room.capacity}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF9800),
                            ),
                          ),
                          const Text(
                            ' personas',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Badge Activo
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC8E6C9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Activo',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                    ],
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