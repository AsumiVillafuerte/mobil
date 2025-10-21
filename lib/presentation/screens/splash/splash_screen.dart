// lib/presentation/screens/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // ⏱️ Simular un pequeño delay para mostrar el splash
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 🔍 Verificar autenticación
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // ✅ Si está autenticado, ir al dashboard
    if (authProvider.isAuthenticated && authProvider.user != null) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // ❌ Si no está autenticado, ir al login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🏨 Logo/Icono
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.hotel_rounded,
                size: 80,
                color: Color(0xFF1565C0),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 📱 Título
            const Text(
              'Hotel Manager',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // 📝 Subtítulo
            const Text(
              'Gestión Hotelera',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                letterSpacing: 0.5,
              ),
            ),
            
            const SizedBox(height: 48),
            
            // ⏳ Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'Cargando...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}