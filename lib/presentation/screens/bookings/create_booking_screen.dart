import 'package:flutter/material.dart';
import '../../../data/models/auth/user_model.dart';

class CreateBookingScreen extends StatelessWidget {
  final UserModel? user;

  const CreateBookingScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Reserva'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add_circle_rounded, size: 80, color: Color(0xFF4CAF50)),
            SizedBox(height: 16),
            Text(
              'Crear Nueva Reserva',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}