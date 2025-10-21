import 'package:flutter/material.dart';
import '../../../data/models/auth/user_model.dart';

class AdminCreateBookingScreen extends StatelessWidget {
  final UserModel? user;

  const AdminCreateBookingScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Reserva (Admin)'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.admin_panel_settings_rounded, size: 80, color: Color(0xFF9C27B0)),
            SizedBox(height: 16),
            Text(
              'Crear Reserva (Admin)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}