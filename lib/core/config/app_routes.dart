// lib/core/config/app_routes.dart
import 'package:flutter/material.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/rooms/rooms_list_screen.dart';
import '../../presentation/screens/rooms/available_rooms_screen.dart';
import '../../presentation/screens/bookings/bookings_list_screen.dart';
import '../../presentation/screens/bookings/my_bookings_screen.dart';
import '../../presentation/screens/bookings/create_booking_screen.dart';
import '../../presentation/screens/bookings/admin_create_booking_screen.dart';
import '../../presentation/screens/users/users_list_screen.dart';
import '../../presentation/screens/payments/payments_list_screen.dart';
import '../../presentation/screens/bills/bills_list_screen.dart';
import '../../presentation/screens/cleaning/cleaning_list_screen.dart';
import '../../presentation/screens/cleaning/my_tasks_screen.dart';
import '../../presentation/screens/cleaning/report_cleaning_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../data/models/auth/user_model.dart';

class AppRoutes {
  // ==========================================
  // 🎯 NOMBRES DE RUTAS
  // ==========================================
  
  // Autenticación
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  
  // Dashboard
  static const String dashboard = '/dashboard';
  
  // Habitaciones
  static const String rooms = '/rooms';
  static const String availableRooms = '/available-rooms';
  
  // Reservas
  static const String bookings = '/bookings';
  static const String myBookings = '/my-bookings';
  static const String createBooking = '/create-booking';
  static const String adminCreateBooking = '/admin-create-booking';
  
  // Usuarios y Personal
  static const String users = '/users';
  static const String employees = '/employees';
  
  // Pagos y Boletas
  static const String payments = '/payments';
  static const String bills = '/bills';
  
  // Limpieza
  static const String cleaning = '/cleaning';
  static const String myTasks = '/my-tasks';
  static const String reportCleaning = '/report-cleaning';
  
  // Perfil
  static const String profile = '/profile';

  // ==========================================
  // 🗺️ GENERADOR DE RUTAS
  // ==========================================
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Obtener usuario de los argumentos (si existe)
    final args = settings.arguments;
    final UserModel? user = args is UserModel ? args : null;

    switch (settings.name) {
      // ==========================================
      // 🔐 AUTENTICACIÓN
      // ==========================================
      case splash:
        return _buildRoute(const SplashScreen());
      
      case login:
        return _buildRoute(const LoginScreen());
      
      case register:
        return _buildRoute(const RegisterScreen());
      
      // ==========================================
      // 📱 DASHBOARD
      // ==========================================
      case dashboard:
        return _buildRoute(const DashboardScreen());
      
      // ==========================================
      // 🏨 HABITACIONES
      // ==========================================
      case rooms:
        return _buildRoute(RoomsListScreen(user: user));
      
      case availableRooms:
        return _buildRoute(AvailableRoomsScreen(user: user));
      
      // ==========================================
      // 📅 RESERVAS
      // ==========================================
      case bookings:
        return _buildRoute(BookingsListScreen(user: user));
      
      case myBookings:
        return _buildRoute(MyBookingsScreen(user: user));
      
      case createBooking:
        return _buildRoute(CreateBookingScreen(user: user));
      
      case adminCreateBooking:
        return _buildRoute(AdminCreateBookingScreen(user: user));
      
      // ==========================================
      // 👥 USUARIOS Y PERSONAL
      // ==========================================
      case users:
        return _buildRoute(UsersListScreen(user: user));
      
      case employees:
        return _buildRoute(UsersListScreen(user: user, employeesOnly: true));
      
      // ==========================================
      // 💳 PAGOS Y BOLETAS
      // ==========================================
      case payments:
        return _buildRoute(PaymentsListScreen(user: user));
      
      case bills:
        return _buildRoute(BillsListScreen(user: user));
      
      // ==========================================
      // 🧹 LIMPIEZA
      // ==========================================
      case cleaning:
        return _buildRoute(CleaningListScreen(user: user));
      
      case myTasks:
        return _buildRoute(MyTasksScreen(user: user));
      
      case reportCleaning:
        return _buildRoute(ReportCleaningScreen(user: user));
      
      // ==========================================
      // 👤 PERFIL
      // ==========================================
      case profile:
        return _buildRoute(ProfileScreen(user: user));
      
      // ==========================================
      // ❌ RUTA NO ENCONTRADA
      // ==========================================
      default:
        return _buildRoute(_ErrorScreen(routeName: settings.name));
    }
  }

  // ==========================================
  // 🎨 CONSTRUCTOR DE RUTAS CON TRANSICIÓN
  // ==========================================
  
  static PageRoute _buildRoute(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }

  // Opción con animación personalizada (opcional)
  static PageRoute _buildRouteWithAnimation(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

// ==========================================
// ❌ PANTALLA DE ERROR 404
// ==========================================
class _ErrorScreen extends StatelessWidget {
  final String? routeName;

  const _ErrorScreen({this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Ruta no encontrada',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              routeName ?? 'Sin nombre',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
              },
              icon: const Icon(Icons.home_rounded),
              label: const Text('Volver al inicio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}