import 'package:flutter/material.dart';
import '../../../data/models/auth/user_model.dart';

class BookingsListScreen extends StatelessWidget {
  final UserModel? user;

  const BookingsListScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_note_rounded, size: 80, color: Color(0xFF2196F3)),
            const SizedBox(height: 16),
            const Text(
              'Lista de Reservas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Usuario: ${user?.fullName ?? "Sin usuario"}'),
          ],
        ),
      ),
    );
  }
}
