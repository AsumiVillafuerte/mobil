import 'package:flutter/material.dart';
import '../../../data/models/auth/user_model.dart';

class BillsListScreen extends StatelessWidget {
  final UserModel? user;

  const BillsListScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boletas'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.receipt_long_rounded, size: 80, color: Color(0xFF00BCD4)),
            SizedBox(height: 16),
            Text(
              'Lista de Boletas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
