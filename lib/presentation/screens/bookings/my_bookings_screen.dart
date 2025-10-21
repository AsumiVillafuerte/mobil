import 'package:flutter/material.dart';
import '../../../data/models/auth/user_model.dart';

class MyBookingsScreen extends StatelessWidget {
  final UserModel? user;

  const MyBookingsScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reservas'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.book_online_rounded, size: 80, color: Color(0xFF2196F3)),
            const SizedBox(height: 16),
            const Text(
              'Mis Reservas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Cliente: ${user?.fullName ?? "Sin cliente"}'),
          ],
        ),
      ),
    );
  }
}