// lib/presentation/screens/dashboard/widgets/header_widget.dart
import 'package:flutter/material.dart';
import 'package:myapp/data/models/auth/user_model.dart';

class HeaderWidget extends StatelessWidget {
  final UserModel? user;
  final VoidCallback onLogout;

  const HeaderWidget({
    super.key,
    required this.user,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    // 🔍 DEBUG
    print('🎨 HeaderWidget - User: ${user?.fullName ?? "null"}');
    print('🎨 HeaderWidget - Role: ${user?.role.name ?? "null"}');

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar con iniciales
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              _getInitials(user?.fullName ?? ''),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Información del usuario
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Saludo
                Text(
                  _getGreeting(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // Nombre del usuario
                Text(
                  user?.fullName ?? 'Usuario',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // Rol del usuario con badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getRoleIcon(user?.role.name ?? 'GUEST'),
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getRoleDisplayName(user?.role.name ?? 'GUEST'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Botón de logout
          IconButton(
            onPressed: onLogout,
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
              size: 24,
            ),
            tooltip: 'Cerrar sesión',
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  // 🔤 Obtener iniciales del nombre (versión segura)
  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'U';
    
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : 'U';
    }
    
    final first = parts[0].isNotEmpty ? parts[0][0] : '';
    final last = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    
    if (first.isEmpty && last.isEmpty) return 'U';
    if (last.isEmpty) return first.toUpperCase();
    
    return '$first$last'.toUpperCase();
  }

  // 👋 Obtener saludo según la hora
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '¡Buenos días!';
    if (hour < 18) return '¡Buenas tardes!';
    return '¡Buenas noches!';
  }

  // 🏷️ Obtener nombre legible del rol
  String _getRoleDisplayName(String role) {
    const roleNames = {
      'ADMIN': 'Administrador',
      'RECEPCIONIST': 'Recepcionista',
      'CLEANING': 'Personal de Limpieza',
      'CUSTOMER': 'Cliente',
      'GUEST': 'Invitado',
    };
    return roleNames[role] ?? role;
  }

  // 🎨 Obtener icono según el rol
  IconData _getRoleIcon(String role) {
    const roleIcons = {
      'ADMIN': Icons.admin_panel_settings_rounded,
      'RECEPCIONIST': Icons.desk_rounded,
      'CLEANING': Icons.cleaning_services_rounded,
      'CUSTOMER': Icons.person_rounded,
      'GUEST': Icons.account_circle_outlined,
    };
    return roleIcons[role] ?? Icons.person_outline_rounded;
  }
}