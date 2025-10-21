import 'package:flutter/material.dart';
import '../../../data/models/auth/user_model.dart';

class MyTasksScreen extends StatelessWidget {
  final UserModel? user;

  const MyTasksScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.task_rounded, size: 80, color: Color(0xFF2196F3)),
            const SizedBox(height: 16),
            const Text(
              'Mis Tareas de Limpieza',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Personal: ${user?.fullName ?? "Sin personal"}'),
          ],
        ),
      ),
    );
  }
}