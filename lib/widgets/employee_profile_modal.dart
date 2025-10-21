import 'package:flutter/material.dart';
import '../models/employee.dart';

class EmployeeProfileModal extends StatelessWidget {
  final Employee employee;

  const EmployeeProfileModal({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C6BC0), // Fondo morado como en la imagen
      appBar: AppBar(
        backgroundColor: const Color(0xFF5C6BC0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perfil del Empleado',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Información completa del empleado de limpieza',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildDetailItem(
                icon: Icons.badge_outlined,
                iconColor: const Color(0xFF9C27B0),
                label: 'ID Empleado',
                value: employee.id,
              ),
              _buildDetailItem(
                icon: Icons.person_outline,
                iconColor: const Color(0xFF2196F3),
                label: 'Nombre Completo',
                value: employee.name,
              ),
              _buildDetailItem(
                icon: Icons.person_outline,
                iconColor: const Color(0xFF2196F3),
                label: 'Apellido Completo',
                value: employee.lastName,
              ),
              _buildDetailItem(
                icon: Icons.description_outlined,
                iconColor: const Color(0xFF2196F3),
                label: 'Tipo de Documento',
                value: employee.documentType,
              ),
              _buildDetailItem(
                icon: Icons.credit_card_outlined,
                iconColor: const Color(0xFF4CAF50),
                label: 'Número de Documento',
                value: employee.documentNumber,
              ),
              _buildDetailItem(
                icon: Icons.access_time,
                iconColor: const Color(0xFFFF9800),
                label: 'Turno de Trabajo',
                value: employee.shift,
                valueWidget: _buildShiftBadge(employee.shift),
              ),
              _buildDetailItem(
                icon: Icons.calendar_today_outlined,
                iconColor: const Color(0xFF4CAF50),
                label: 'Fecha de Registro',
                value: employee.registrationDate,
              ),
              _buildDetailItem(
                icon: Icons.check_circle_outline,
                iconColor: const Color(0xFF4CAF50),
                label: 'Estado Actual',
                value: employee.isActive ? 'Activo' : 'Inactivo',
                valueWidget: _buildStatusBadge(employee.isActive),
              ),
            ],
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
    Widget? valueWidget,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                valueWidget ??
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF212121),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Badge para el turno de trabajo
  Widget _buildShiftBadge(String shift) {
    Color backgroundColor;
    Color textColor;

    if (shift == 'Mañana') {
      backgroundColor = const Color(0xFFE3F2FD); // azul claro
      textColor = const Color(0xFF1976D2); // azul fuerte
    } else if (shift == 'Tarde') {
      backgroundColor = const Color(0xFFFFF3E0); // naranja claro
      textColor = const Color(0xFFFF9800); // naranja
    } else if (shift == 'Noche') {
      backgroundColor = const Color(0xFFF3E5F5); // morado claro
      textColor = const Color(0xFF7B1FA2); // morado
    } else {
      backgroundColor = Colors.grey.shade200;
      textColor = Colors.grey.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        shift,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Badge para el estado (Activo / Inactivo)
  Widget _buildStatusBadge(bool isActive) {
    Color backgroundColor;
    Color textColor;

    if (isActive) {
      backgroundColor = const Color(0xFFE8F5E9); // verde claro
      textColor = const Color(0xFF388E3C); // verde fuerte
    } else {
      backgroundColor = const Color(0xFFFFEBEE); // rojo claro
      textColor = const Color(0xFFD32F2F); // rojo fuerte
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? 'Activo' : 'Inactivo',
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static void show(BuildContext context, Employee employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeProfileModal(employee: employee),
      ),
    );
  }
}
