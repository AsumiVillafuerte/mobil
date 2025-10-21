// lib/presentation/screens/cleaning/cleaning_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/data/models/auth/user_model.dart';

class CleaningScreen extends StatelessWidget {
  final UserModel? user;

  const CleaningScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Limpieza'),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cleaning_services_rounded,
              size: 80,
              color: Color(0xFF3F51B5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Gestión de Limpieza',
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