// lib/presentation/screens/users/widgets/user_profile_modal.dart
import 'package:flutter/material.dart';
import 'package:myapp/data/models/auth/user_model.dart';

class UserProfileModal extends StatelessWidget {
  final UserModel user;

  const UserProfileModal({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
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
                Icons.person_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Perfil de Usuario',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Información completa del usuario',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F7FA),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Avatar grande
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getRoleColor(user.role.name),
                        _getRoleColor(user.role.name).withOpacity(0.7),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _getRoleColor(user.role.name).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(user.fullName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              _buildRoleBadge(user.role.name),
              const SizedBox(height: 24),

              // Información detallada
              _buildDetailItem(
                icon: Icons.badge_outlined,
                iconColor: const Color(0xFF9C27B0),
                label: 'ID de Usuario',
                value: user.idUser.toString(),
              ),
              _buildDetailItem(
                icon: Icons.person_outline_rounded,
                iconColor: const Color(0xFF2196F3),
                label: 'Nombres',
                value: user.names,
              ),
              _buildDetailItem(
                icon: Icons.person_outline_rounded,
                iconColor: const Color(0xFF2196F3),
                label: 'Apellidos',
                value: user.surnames,
              ),
              if (user.gender != null)
                _buildDetailItem(
                  icon: Icons.wc_rounded,
                  iconColor: const Color(0xFFFF9800),
                  label: 'Género',
                  value: user.gender == 'M' ? 'Masculino' : 'Femenino',
                ),
              _buildDetailItem(
                icon: Icons.email_outlined,
                iconColor: const Color(0xFF2196F3),
                label: 'Correo Electrónico',
                value: user.email,
              ),
              if (user.phone != null)
                _buildDetailItem(
                  icon: Icons.phone_outlined,
                  iconColor: const Color(0xFF4CAF50),
                  label: 'Teléfono',
                  value: user.phone!,
                ),
              _buildDetailItem(
                icon: Icons.description_outlined,
                iconColor: const Color(0xFF00BCD4),
                label: 'Tipo de Documento',
                value: user.documentType,
              ),
              _buildDetailItem(
                icon: Icons.credit_card_outlined,
                iconColor: const Color(0xFF4CAF50),
                label: 'Número de Documento',
                value: user.documentNumber,
              ),
              if (user.shift != null)
                _buildDetailItem(
                  icon: Icons.access_time_rounded,
                  iconColor: const Color(0xFFFF9800),
                  label: 'Turno de Trabajo',
                  value: user.shift!,
                  valueWidget: _buildShiftBadge(user.shift!),
                ),
              if (user.registrationDate != null)
                _buildDetailItem(
                  icon: Icons.calendar_today_outlined,
                  iconColor: const Color(0xFF4CAF50),
                  label: 'Fecha de Registro',
                  value: user.registrationDate!,
                ),
              _buildDetailItem(
                icon: Icons.check_circle_outline_rounded,
                iconColor: user.isActive ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                label: 'Estado Actual',
                value: user.isActive ? 'Activo' : 'Inactivo',
                valueWidget: _buildStatusBadge(user.isActive),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
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
                    fontWeight: FontWeight.w500,
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

  Widget _buildRoleBadge(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getRoleColor(role).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getRoleColor(role),
          width: 2,
        ),
      ),
      child: Text(
        _getRoleDisplayName(role),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: _getRoleColor(role),
        ),
      ),
    );
  }

  Widget _buildShiftBadge(String shift) {
    Color backgroundColor;
    Color textColor;

    switch (shift) {
      case 'Mañana':
        backgroundColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1976D2);
        break;
      case 'Tarde':
        backgroundColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFFF9800);
        break;
      case 'Noche':
        backgroundColor = const Color(0xFFF3E5F5);
        textColor = const Color(0xFF7B1FA2);
        break;
      default:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        shift,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? 'Activo' : 'Inactivo',
        style: TextStyle(
          color: isActive ? const Color(0xFF388E3C) : const Color(0xFFD32F2F),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Helpers
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Color _getRoleColor(String role) {
    const roleColors = {
      'ADMIN': Color(0xFF9C27B0),
      'RECEPCIONIST': Color(0xFF2196F3),
      'CLEANING': Color(0xFF4CAF50),
      'CUSTOMER': Color(0xFFFF9800),
    };
    return roleColors[role] ?? Colors.grey;
  }

  String _getRoleDisplayName(String role) {
    const roleNames = {
      'ADMIN': 'Administrador',
      'RECEPCIONIST': 'Recepcionista',
      'CLEANING': 'Personal de Limpieza',
      'CUSTOMER': 'Cliente',
    };
    return roleNames[role] ?? role;
  }

  static void show(BuildContext context, UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileModal(user: user),
      ),
    );
  }
}