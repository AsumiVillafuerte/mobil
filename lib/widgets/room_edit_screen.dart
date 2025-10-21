import 'package:flutter/material.dart';
import 'package:myapp/models/room.dart';
class RoomEditScreen extends StatefulWidget {
  final Room? room;

  const RoomEditScreen({super.key, this.room});

  @override
  State<RoomEditScreen> createState() => _RoomEditScreenState();
}

class _RoomEditScreenState extends State<RoomEditScreen> {
  late TextEditingController _roomNumberController;
  late TextEditingController _costPerDayController;
  late TextEditingController _descriptionController;

  late String _selectedActivity;
  late String _selectedRoomType;
  late String _selectedFloorLevel;
  final String _lastModifiedDate = '16/06/2025 08:43';

  @override
  void initState() {
    super.initState();
    if (widget.room != null) {
      _roomNumberController = TextEditingController(text: widget.room!.roomNumber);
      _costPerDayController = TextEditingController(text: widget.room!.price.toStringAsFixed(2));
      _descriptionController = TextEditingController(text: widget.room!.description);
      _selectedActivity = widget.room!.availability;
      _selectedRoomType = widget.room!.type;
      _selectedFloorLevel = widget.room!.floor;
    } else {
      // Valores por defecto para una nueva habitación
      _roomNumberController = TextEditingController(text: 'Habitación 101'); // Valor de ejemplo para nueva
      _costPerDayController = TextEditingController(text: '100.00'); // Valor de ejemplo para nueva
      _descriptionController = TextEditingController(text: 'Descripción de la habitación.'); // Valor de ejemplo
      _selectedActivity = 'Disponible';
      _selectedRoomType = 'Corporativa';
      _selectedFloorLevel = 'Piso 1';
    }
  }

  @override
  void dispose() {
    _roomNumberController.dispose();
    _costPerDayController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedRoom = Room(
      roomNumber: _roomNumberController.text,
      type: _selectedRoomType,
      description: _descriptionController.text,
      floor: _selectedFloorLevel,
      price: double.tryParse(_costPerDayController.text) ?? 0.0,
      status: widget.room?.status ?? 'Activo', // Asume un estado por defecto si es nueva
      statusBgColor: widget.room?.statusBgColor ?? const Color(0xFFE8F5E9),
      statusTextColor: widget.room?.statusTextColor ?? const Color(0xFF388E3C),
      availability: _selectedActivity,
      availabilityBgColor: _getAvailabilityBgColor(_selectedActivity),
      availabilityTextColor: _getAvailabilityTextColor(_selectedActivity),
      typeBgColor: _getRoomTypeBgColor(_selectedRoomType),
      typeTextColor: _getRoomTypeTextColor(_selectedRoomType),
    );
    Navigator.pop(context, updatedRoom);
  }

  // Métodos auxiliares para los colores (mantener como estaban)
  Color _getAvailabilityBgColor(String availability) {
    switch (availability) {
      case 'Disponible':
        return const Color(0xFFE8F5E9);
      case 'Ocupada':
        return const Color(0xFFFBE9E7);
      case 'Mantenimiento':
        return const Color(0xFFE3F2FD);
      default:
        return Colors.white;
    }
  }

  Color _getAvailabilityTextColor(String availability) {
    switch (availability) {
      case 'Disponible':
        return const Color(0xFF388E3C);
      case 'Ocupada':
        return const Color(0xFFD32F2F);
      case 'Mantenimiento':
        return const Color(0xFF1565C0);
      default:
        return Colors.black;
    }
  }

  Color _getRoomTypeBgColor(String type) {
    switch (type) {
      case 'Corporativa':
        return Colors.blue.shade100;
      case 'Familiar':
        return Colors.deepPurple.shade100;
      case 'Individual':
        return const Color(0xFFFFE0B2);
      default:
        return Colors.white;
    }
  }

  Color _getRoomTypeTextColor(String type) {
    switch (type) {
      case 'Corporativa':
        return Colors.blue.shade800;
      case 'Familiar':
        return Colors.deepPurple.shade900;
      case 'Individual':
        return Colors.orange.shade900;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Editar Habitación',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edite los datos de la habitación para actualizar su disponibilidad, estado o características.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            // La sección "INFORMACIÓN BÁSICA" con el borde verde redondeado
            _buildSection(
              title: 'INFORMACIÓN BÁSICA',
              children: [
                _buildTextField('N° de Habitación', _roomNumberController),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        'Actividad/Habitacion',
                        ['Disponible', 'Mantenimiento', 'Ocupada'],
                        _selectedActivity,
                        (newValue) {
                          setState(() {
                            _selectedActivity = newValue!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownField(
                        'Tipo de habitación',
                        ['Corporativa', 'Familiar', 'Individual'],
                        _selectedRoomType,
                        (newValue) {
                          setState(() {
                            _selectedRoomType = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'Detalles',
              children: [
                _buildTextField('Costo por Día', _costPerDayController),
                _buildDropdownField(
                  'Nivel / Piso',
                  ['Piso 1', 'Piso 2', 'Piso 3', 'Piso 4', 'Piso 5'],
                  _selectedFloorLevel,
                  (newValue) {
                    setState(() {
                      _selectedFloorLevel = newValue!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'Administración',
              children: [
                _buildDateField('Fecha de Modificación', _lastModifiedDate),
                _buildDescriptionField('Descripción', _descriptionController),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF62D696)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Color(0xFF62D696)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF62D696),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Guardar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para construir cada sección con borde verde y esquinas redondeadas
  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF62D696)), // Borde verde para la sección
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  // Widget para construir un campo de texto con borde verde redondeado
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
                borderSide: const BorderSide(color: Color(0xFF62D696)), // Borde verde
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), // Bordes redondeados cuando no está enfocado
                borderSide: const BorderSide(color: Color(0xFF62D696)), // Borde verde cuando no está enfocado
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF62D696), width: 2), // Borde verde más grueso cuando está enfocado
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para construir un campo de dropdown con borde verde redondeado
  Widget _buildDropdownField(String label, List<String> items, String value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
                borderSide: const BorderSide(color: Color(0xFF62D696)), // Borde verde
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), // Bordes redondeados cuando no está enfocado
                borderSide: const BorderSide(color: Color(0xFF62D696)), // Borde verde cuando no está enfocado
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF62D696), width: 2), // Borde verde más grueso cuando está enfocado
              ),
            ),
            items: items.map<DropdownMenuItem<String>>((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // Widget para el campo de fecha no editable con borde verde redondeado
  Widget _buildDateField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          TextFormField(
            readOnly: true,
            initialValue: hint,
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
                borderSide: const BorderSide(color: Color(0xFF62D696)), // Borde verde
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
                borderSide: const BorderSide(color: Color(0xFF62D696)), // Borde verde
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para el campo de descripción multilinea con borde verde redondeado
  Widget _buildDescriptionField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
                borderSide: const BorderSide(color: Color(0xFF62D696)), // Borde verde
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
                borderSide: const BorderSide(color: Color(0xFF62D696)), // Borde verde
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF62D696), width: 2), // Borde verde más grueso cuando está enfocado
              ),
            ),
          ),
        ],
      ),
    );
  }
}
