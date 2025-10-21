import 'package:flutter/material.dart';
import '../../../data/models/auth/user_model.dart';

class ReportCleaningScreen extends StatelessWidget {
  final UserModel? user;

  const ReportCleaningScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar Limpieza'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add_task_rounded, size: 80, color: Color(0xFF4CAF50)),
            SizedBox(height: 16),
            Text(
              'Reportar Limpieza',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
