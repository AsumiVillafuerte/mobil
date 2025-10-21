import 'package:flutter/material.dart';
import '../../../data/models/auth/user_model.dart';

class CleaningListScreen extends StatelessWidget {
  final UserModel? user;

  const CleaningListScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Limpieza'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cleaning_services_rounded, size: 80, color: Color(0xFF3F51B5)),
            SizedBox(height: 16),
            Text(
              'Gestión de Limpieza',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
