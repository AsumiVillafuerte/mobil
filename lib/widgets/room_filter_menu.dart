import 'package:flutter/material.dart';

class RoomFilterMenu extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onStatusSelected;

  const RoomFilterMenu({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        onStatusSelected(result);
      },
      offset: const Offset(0, 50),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Activo',
          child: Row(
            children: [
              Icon(Icons.person_outline, color: Colors.black54),
              SizedBox(width: 8),
              Text('Activo'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Inactivo',
          child: Row(
            children: [
              Icon(Icons.person_outline, color: Colors.black54),
              SizedBox(width: 8),
              Text('Inactivo'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Todos',
          child: Row(
            children: [
              Icon(Icons.person_outline, color: Colors.black54),
              SizedBox(width: 8),
              Text('Todos'),
            ],
          ),
        ),
      ],
      child: OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.filter_list, color: Colors.black54),
        label: const Text('Filtros', style: TextStyle(color: Colors.black54, fontSize: 16)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(color: Colors.black12),
        ),
      ),
    );
  }
}