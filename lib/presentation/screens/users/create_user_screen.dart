// lib/presentation/screens/users/create_user_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/presentation/providers/users_provider.dart';
import 'widgets/user_form_widget.dart';

class CreateUserScreen extends StatefulWidget {
  final bool isAdminCreation;

  const CreateUserScreen({super.key, this.isAdminCreation = true});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(widget.isAdminCreation ? 'Nuevo Usuario' : 'Registro'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: UserFormWidget(
        isLoading: _isLoading,
        onSubmit: _handleCreateUser,
      ),
    );
  }

  Future<void> _handleCreateUser(Map<String, dynamic> userData) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<UsersProvider>(context, listen: false);
      bool success;

      if (widget.isAdminCreation) {
        // ⭐ Creación desde admin
        success = await provider.createUserByAdmin(userData);
      } else {
        // Registro público
        success = await provider.registerUser(userData);
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(child: Text('Usuario creado exitosamente')),
                ],
              ),
              backgroundColor: Color(0xFF4CAF50),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
          Navigator.pop(context, true); // ⭐ Devuelve true
        } else {
          _showErrorSnackBar(provider.errorMessage ?? 'Error al crear el usuario');
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
            const Icon(Icons.error_outline_rounded, color: Colors.white),
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