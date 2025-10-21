// lib/presentation/screens/payments/payments_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/data/models/auth/user_model.dart';

class PaymentsScreen extends StatelessWidget {
  final UserModel? user;

  const PaymentsScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagos'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.payment_rounded,
              size: 80,
              color: Color(0xFF9C27B0),
            ),
            const SizedBox(height: 16),
            const Text(
              'Gestión de Pagos',
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