// lib/presentation/screens/users/edit_user_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/data/models/auth/user_model.dart';
import 'package:myapp/presentation/providers/users_provider.dart';
import 'widgets/user_form_widget.dart';

class EditUserScreen extends StatefulWidget {
  final UserModel user;

  const EditUserScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Editar Usuario'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: UserFormWidget(
        user: widget.user,
        isLoading: _isLoading,
        onSubmit: _handleUpdateUser,
      ),
    );
  }

  Future<void> _handleUpdateUser(Map<String, dynamic> userData) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<UsersProvider>(context, listen: false);
      
      // 🔍 DEBUG: Ver qué datos llegan del formulario
      print('═══════════════════════════════');
      print('📥 DATOS RECIBIDOS DEL FORMULARIO:');
      print('═══════════════════════════════');
      userData.forEach((key, value) {
        print('$key: $value');
      });
      print('═══════════════════════════════\n');
      
      // ✅ NO agregues nada aquí, el formulario ya envía todo correcto
      final success = await provider.updateUser(userData);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(child: Text('Usuario actualizado exitosamente')),
                ],
              ),
              backgroundColor: Color(0xFF4CAF50),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
          Navigator.pop(context);
        } else {
          _showErrorSnackBar(
            provider.errorMessage ?? 'Error al actualizar el usuario'
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Error inesperado: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Cerrar',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}