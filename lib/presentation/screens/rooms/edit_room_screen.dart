import 'package:flutter/material.dart';
import '../../../../data/models/auth/room_model.dart';
import 'widgets/room_form_widget.dart';

class EditRoomScreen extends StatelessWidget {
  final RoomModel room;

  const EditRoomScreen({
    super.key,
    required this.room,
  });

  Future<void> _handleSave(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    // Obtener la fecha y hora actual en zona horaria de Perú (UTC-5)
    final now = DateTime.now().toUtc().subtract(const Duration(hours: 5));
    
    // Agregar la fecha de modificación a los datos
    data['updatedAt'] = now.toIso8601String();
    data['modificationDate'] = _formatPeruvianDateTime(now);
    
    // Aquí deberías llamar a tu servicio/repositorio para guardar los datos
    await Future.delayed(const Duration(seconds: 1));
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Habitación ${data['roomNumber']} actualizada exitosamente'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.pop(context, true); // Retorna true para indicar que se guardó
    }
  }

  String _formatPeruvianDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final second = date.second.toString().padLeft(2, '0');
    
    return '$day/$month/$year $hour:$minute:$second';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Habitación ${room.number}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.orange.shade700,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Editar Información',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Modifica los datos de la habitación ${room.number}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            RoomFormWidget(
              room: room,
              onSave: (data) => _handleSave(context, data),
              onCancel: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}