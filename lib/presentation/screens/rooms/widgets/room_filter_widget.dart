import 'package:flutter/material.dart';

class RoomFilterWidget extends StatelessWidget {
  final Function(String) onSearch;
  final Function(String?)? onFilterType;
  final Function(String?)? onFilterState;
  final List<String> roomTypes;

  const RoomFilterWidget({
    Key? key,
    required this.onSearch,
    this.onFilterType,
    this.onFilterState,
    this.roomTypes = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Barra de búsqueda
          TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: 'Buscar por número, tipo o descripción...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Filtros
          Row(
            children: [
              // Filtro por tipo
              if (onFilterType != null && roomTypes.isNotEmpty)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: const SizedBox(),
                      hint: const Text('Tipo'),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Todos los tipos'),
                        ),
                        ...roomTypes.map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            )),
                      ],
                      onChanged: onFilterType,
                    ),
                  ),
                ),
              if (onFilterType != null && onFilterState != null)
                const SizedBox(width: 8),
              // Filtro por estado
              if (onFilterState != null)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: const SizedBox(),
                      hint: const Text('Estado'),
                      items: const [
                        DropdownMenuItem(
                          value: null,
                          child: Text('Todos'),
                        ),
                        DropdownMenuItem(
                          value: 'A',
                          child: Text('Disponible'),
                        ),
                        DropdownMenuItem(
                          value: 'I',
                          child: Text('Ocupada'),
                        ),
                      ],
                      onChanged: onFilterState,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}