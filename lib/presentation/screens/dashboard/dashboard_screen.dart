// lib/presentation/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/data/models/auth/user_model.dart';
import 'package:myapp/presentation/providers/auth_provider.dart';
import 'widgets/header_widget.dart';
import 'widgets/stats_card_widget.dart';
import 'widgets/nav_card_widget.dart';
import 'widgets/nav_card_data.dart';
import 'widgets/activity_item_widget.dart';

// IMPORTS DE LAS PANTALLAS
import 'package:myapp/presentation/screens/users/users_list_screen.dart';
import 'package:myapp/presentation/screens/rooms/rooms_list_screen.dart';
import 'package:myapp/presentation/screens/bookings/bookings_list_screen.dart';
import 'package:myapp/presentation/screens/bookings/my_bookings_screen.dart';
import 'package:myapp/presentation/screens/bookings/create_booking_screen.dart';
import 'package:myapp/presentation/screens/rooms/available_rooms_screen.dart';
import 'package:myapp/presentation/screens/payments/payments_list_screen.dart';
import 'package:myapp/presentation/screens/bills/bills_list_screen.dart';
import 'package:myapp/presentation/screens/cleaning/cleaning_list_screen.dart';
import 'package:myapp/presentation/screens/cleaning/my_tasks_screen.dart';
import 'package:myapp/presentation/screens/cleaning/report_cleaning_screen.dart';
import 'package:myapp/presentation/screens/profile/profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Panel Principal', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: _buildDrawer(context, user),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              HeaderWidget(user: user, onLogout: () => _showLogoutDialog(context)),
              const SizedBox(height: 24),
              _buildStatsSection(),
              const SizedBox(height: 24),
              _buildRecentActivitySection(),
              const SizedBox(height: 24),
              const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
              const SizedBox(height: 16),
              _buildNavigationSection(context, user),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context, UserModel? currentUser) {
    final role = currentUser?.role.name ?? 'GUEST';
    final displayRole = _getRoleDisplayName(role);
    final sections = _getDrawerSections(currentUser);

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // ✅ Header del Drawer
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              currentUser?.fullName ?? 'Usuario',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(
              displayRole,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _getInitials(currentUser?.fullName ?? ''),
                style: const TextStyle(
                  color: Color(0xFF1565C0),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // ✅ Contenido del Drawer
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Dashboard
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1565C0).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.dashboard_rounded, color: Color(0xFF1565C0), size: 20),
                  ),
                  title: const Text(
                    'Dashboard',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  onTap: () => Navigator.of(context).pop(), // ✅ Solo cierra el drawer
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(thickness: 1, height: 1),
                ),
                
                // Secciones dinámicas
                ...sections.entries.map((entry) {
                  return _buildDrawerSection(
                    context,
                    sectionTitle: entry.key,
                    items: entry.value,
                    currentUser: currentUser,
                  );
                }).toList(),
              ],
            ),
          ),
          
          // ✅ Botón de logout al final
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(thickness: 1, height: 1),
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
            ),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop(); // Cerrar drawer
              _showLogoutDialog(context); // Mostrar diálogo
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildDrawerSection(
    BuildContext context, {
    required String sectionTitle,
    required List<NavCardData> items,
    required UserModel? currentUser,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                sectionTitle.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF757575),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        ...items.map((item) {
          return ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(item.icon, color: item.color, size: 18),
            ),
            title: Text(
              item.title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).pop(); // ✅ Cerrar drawer primero
              _navigateTo(context, item.route, currentUser); // ✅ Luego navegar
            },
          );
        }).toList(),
        const SizedBox(height: 8),
      ],
    );
  }

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

  Map<String, List<NavCardData>> _getDrawerSections(UserModel? currentUser) {
    final role = currentUser?.role.name ?? 'GUEST';
    
    switch (role) {
      case 'ADMIN':
        return {
          'Gestión General': [
            NavCardData(
              title: 'Usuarios',
              icon: Icons.people_rounded,
              color: const Color(0xFF4CAF50),
              route: '/users',
            ),
            NavCardData(
              title: 'Personal',
              icon: Icons.badge_rounded,
              color: const Color(0xFF9C27B0),
              route: '/employees',
            ),
          ],
          'Operaciones': [
            NavCardData(
              title: 'Habitaciones',
              icon: Icons.hotel_rounded,
              color: const Color(0xFFFF9800),
              route: '/rooms',
            ),
            NavCardData(
              title: 'Reservas',
              icon: Icons.event_note_rounded,
              color: const Color(0xFF2196F3),
              route: '/bookings',
            ),
            NavCardData(
              title: 'Pagos',
              icon: Icons.payment_rounded,
              color: const Color(0xFF9C27B0),
              route: '/payments',
            ),
            NavCardData(
              title: 'Boletas',
              icon: Icons.receipt_long_rounded,
              color: const Color(0xFF00BCD4),
              route: '/bills',
            ),
            NavCardData(
              title: 'Limpieza',
              icon: Icons.cleaning_services_rounded,
              color: const Color(0xFF3F51B5),
              route: '/cleaning',
            ),
          ],
        };
      
      case 'RECEPCIONIST':
        return {
          'Operaciones': [
            NavCardData(title: 'Habitaciones', icon: Icons.hotel_rounded, color: const Color(0xFFFF9800), route: '/rooms'),
            NavCardData(title: 'Reservas', icon: Icons.event_note_rounded, color: const Color(0xFF2196F3), route: '/bookings'),
            NavCardData(title: 'Pagos', icon: Icons.payment_rounded, color: const Color(0xFF9C27B0), route: '/payments'),
            NavCardData(title: 'Boletas', icon: Icons.receipt_long_rounded, color: const Color(0xFF00BCD4), route: '/bills'),
            NavCardData(title: 'Limpieza', icon: Icons.cleaning_services_rounded, color: const Color(0xFF3F51B5), route: '/cleaning'),
          ],
        };
      
      case 'CLEANING':
        return {
          'Mis Tareas': [
            NavCardData(title: 'Tareas Asignadas', icon: Icons.task_rounded, color: const Color(0xFF2196F3), route: '/my-tasks'),
            NavCardData(title: 'Reportar Limpieza', icon: Icons.add_task_rounded, color: const Color(0xFF4CAF50), route: '/report-cleaning'),
          ],
        };
      
      case 'CUSTOMER':
        return {
          'Reservas': [
            NavCardData(title: 'Mis Reservas', icon: Icons.event_note_rounded, color: const Color(0xFF2196F3), route: '/my-bookings'),
            NavCardData(title: 'Nueva Reserva', icon: Icons.add_circle_rounded, color: const Color(0xFF4CAF50), route: '/create-booking'),
            NavCardData(title: 'Habitaciones Disponibles', icon: Icons.hotel_rounded, color: const Color(0xFFFF9800), route: '/available-rooms'),
          ],
          'Mi Cuenta': [
            NavCardData(title: 'Mi Perfil', icon: Icons.person_rounded, color: const Color(0xFF9C27B0), route: '/profile'),
          ],
        };
      
      case 'GUEST':
      default:
        return {
          'Acceso': [
            NavCardData(title: 'Iniciar Sesión', icon: Icons.login_rounded, color: const Color(0xFF1565C0), route: '/login'),
            NavCardData(title: 'Registrarse', icon: Icons.person_add_rounded, color: const Color(0xFF4CAF50), route: '/register'),
          ],
        };
    }
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen General',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: StatsCardWidget(value: '120', label: 'Clientes', icon: Icons.people_rounded, color: const Color(0xFF4CAF50))),
              const SizedBox(width: 12),
              Expanded(child: StatsCardWidget(value: '45', label: 'Reservas', icon: Icons.event_note_rounded, color: const Color(0xFF2196F3))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: StatsCardWidget(value: '32', label: 'Habitaciones', icon: Icons.hotel_rounded, color: const Color(0xFFFF9800))),
              const SizedBox(width: 12),
              Expanded(child: StatsCardWidget(value: '9', label: 'Personal', icon: Icons.badge_rounded, color: const Color(0xFF9C27B0))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF1565C0), Color(0xFF42A5F5)]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.history_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Actividad Reciente',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Column(
              children: [
                ActivityItemWidget(
                  title: 'Nueva reserva registrada',
                  subtitle: 'Habitación 201 - Check-in hoy',
                  icon: Icons.event_available_rounded,
                  color: Color(0xFF4CAF50),
                  time: 'Hace 2h',
                ),
                Divider(height: 24, color: Color(0xFFE0E0E0)),
                ActivityItemWidget(
                  title: 'Limpieza completada',
                  subtitle: 'Habitación 305 lista para uso',
                  icon: Icons.cleaning_services_rounded,
                  color: Color(0xFF2196F3),
                  time: 'Hace 4h',
                ),
                Divider(height: 24, color: Color(0xFFE0E0E0)),
                ActivityItemWidget(
                  title: 'Pago registrado',
                  subtitle: 'Boleta #0001 - S/. 450.00',
                  icon: Icons.payment_rounded,
                  color: Color(0xFFFF9800),
                  time: 'Hace 5h',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationSection(BuildContext context, UserModel? currentUser) {
    final sections = _getNavigationSections(currentUser);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sections.entries.map<Widget>((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1565C0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 35,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: entry.value.length,
                    itemBuilder: (context, index) {
                      final navCard = entry.value[index];
                      return NavCardWidget(
                        data: navCard,
                        onTap: () => _navigateTo(context, navCard.route, currentUser),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ✅ NAVEGACIÓN CORREGIDA
  void _navigateTo(BuildContext context, String route, UserModel? currentUser) {
    switch (route) {
      case '/users':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => UsersListScreen(user: currentUser),
        ));
        break;
      case '/employees':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => UsersListScreen(user: currentUser, employeesOnly: true),
        ));
        break;
      case '/rooms':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => RoomsListScreen(user: currentUser),
        ));
        break;
      case '/bookings':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => BookingsListScreen(user: currentUser),
        ));
        break;
      case '/my-bookings':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => MyBookingsScreen(user: currentUser),
        ));
        break;
      case '/create-booking':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CreateBookingScreen(user: currentUser),
        ));
        break;
      case '/available-rooms':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => AvailableRoomsScreen(user: currentUser),
        ));
        break;
      case '/payments':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => PaymentsListScreen(user: currentUser),
        ));
        break;
      case '/bills':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => BillsListScreen(user: currentUser),
        ));
        break;
      case '/cleaning':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CleaningListScreen(user: currentUser),
        ));
        break;
      case '/my-tasks':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => MyTasksScreen(user: currentUser),
        ));
        break;
      case '/report-cleaning':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ReportCleaningScreen(user: currentUser),
        ));
        break;
      case '/profile':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ProfileScreen(user: currentUser),
        ));
        break;
      case '/login':
        Navigator.of(context).pushNamed('/login');
        break;
      case '/register':
        Navigator.of(context).pushNamed('/register');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ruta no disponible: $route'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  // ✅ DIÁLOGO DE LOGOUT CORREGIDO
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Color(0xFF1565C0)),
            SizedBox(width: 12),
            Text('Cerrar Sesión'),
          ],
        ),
        content: const Text('¿Estás seguro de que deseas salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              // ✅ Cerrar el diálogo
              Navigator.of(dialogContext).pop();
              
              // ✅ Hacer logout
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              
              // ✅ Navegar a login y limpiar stack
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  Map<String, List<NavCardData>> _getNavigationSections(UserModel? currentUser) {
    return _getDrawerSections(currentUser);
  }
}