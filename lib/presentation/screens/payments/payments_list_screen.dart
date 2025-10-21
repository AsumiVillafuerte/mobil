import 'package:flutter/material.dart';
import '../../../data/models/auth/user_model.dart';

class PaymentsListScreen extends StatelessWidget {
  final UserModel? user;

  const PaymentsListScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagos'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.payment_rounded, size: 80, color: Color(0xFF9C27B0)),
            SizedBox(height: 16),
            Text(
              'Lista de Pagos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
