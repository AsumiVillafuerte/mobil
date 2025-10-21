// lib/presentation/screens/bills/bills_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/data/models/auth/user_model.dart';

class BillsScreen extends StatelessWidget {
  final UserModel? user;

  const BillsScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boletas'),
        backgroundColor: const Color(0xFF00BCD4),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.receipt_long_rounded,
              size: 80,
              color: Color(0xFF00BCD4),
            ),
            const SizedBox(height: 16),
            const Text(
              'Gestión de Boletas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text('Próximamente...'),
          ],
        ),
      ),
    );
  }
}