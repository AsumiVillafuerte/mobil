// lib/presentation/screens/users/widgets/user_card_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/data/models/auth/user_model.dart';
import '../../../providers/auth_provider.dart';

class UserCardWidget extends StatefulWidget {
  final UserModel user;
  final VoidCallback onToggleStatus;
  final VoidCallback onViewProfile;
  final VoidCallback onEdit;

  const UserCardWidget({
    super.key,
    required this.user,
    required this.onToggleStatus,
    required this.onViewProfile,
    required this.onEdit,
  });

  @override
  State<UserCardWidget> createState() => _UserCardWidgetState();
}

class _UserCardWidgetState extends State<UserCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isSwipedOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.4, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSwipe() {
    if (_isSwipedOpen) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      _isSwipedOpen = !_isSwipedOpen;
    });
  }

  void _closeSwipe() {
    if (_isSwipedOpen) {
      _animationController.reverse();
      setState(() {
        _isSwipedOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _closeSwipe,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Stack(
          children: [
            _buildActionBackground(),
            SlideTransition(
              position: _slideAnimation,
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! < -500) {
                    if (!_isSwipedOpen) _toggleSwipe();
                  } else if (details.primaryVelocity! > 500) {
                    if (_isSwipedOpen) _toggleSwipe();
                  }
                },
                child: _buildMainCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBackground() {
    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Botón Editar
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    _closeSwipe();
                    
                    // ✅ Validar permisos antes de editar
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    final currentUser = authProvider.user;
                    
                    if (currentUser == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error: Usuario no autenticado'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    
                    // Permitir si es ADMIN o es su propio perfil
                    bool isAdmin = currentUser.role.name == 'ADMIN';
                    bool isOwnProfile = currentUser.idUser == widget.user.idUser;
                    
                    if (isAdmin || isOwnProfile) {
                      widget.onEdit();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Solo puedes editar tu propio perfil'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Center(
                    child: Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            // Botón Eliminar/Restaurar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: widget.user.isActive 
                    ? const Color(0xFFF44336) 
                    : const Color(0xFF2196F3),
                shape: BoxShape.circle,
              ),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    _closeSwipe();
                    widget.onToggleStatus();
                  },
                  child: Center(
                    child: Icon(
                      widget.user.isActive ? Icons.delete_rounded : Icons.restore_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return GestureDetector(
      onTap: widget.onViewProfile,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildContactInfo(),
            const SizedBox(height: 12),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _getRoleColor(widget.user.role.name),
                _getRoleColor(widget.user.role.name).withOpacity(0.7),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              _getInitials(widget.user.fullName),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.fullName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildRoleBadge(),
                  const SizedBox(width: 8),
                  _buildStatusBadge(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getRoleColor(widget.user.role.name).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _getRoleDisplayName(widget.user.role.name),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: _getRoleColor(widget.user.role.name),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: widget.user.isActive
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        widget.user.isActive ? 'Activo' : 'Inactivo',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: widget.user.isActive
              ? const Color(0xFF4CAF50)
              : const Color(0xFFE57373),
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.email_rounded,
                size: 16,
                color: Color(0xFF2196F3),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.user.email,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF424242),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (widget.user.phone != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.phone_rounded,
                  size: 16,
                  color: Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.user.phone!,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF424242),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.badge_rounded,
            size: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${widget.user.documentType}: ${widget.user.documentNumber}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const Spacer(),
        if (widget.user.shift != null) _buildShiftBadge(),
      ],
    );
  }

  Widget _buildShiftBadge() {
    Color backgroundColor;
    Color textColor;

    switch (widget.user.shift) {
      case 'Mañana':
        backgroundColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1976D2);
        break;
      case 'Tarde':
        backgroundColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFFF9800);
        break;
      case 'Noche':
        backgroundColor = const Color(0xFFF3E5F5);
        textColor = const Color(0xFF7B1FA2);
        break;
      default:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        widget.user.shift!,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Color _getRoleColor(String role) {
    const roleColors = {
      'ADMIN': Color(0xFF9C27B0),
      'RECEPCIONIST': Color(0xFF2196F3),
      'CLEANING': Color(0xFF4CAF50),
      'CUSTOMER': Color(0xFFFF9800),
    };
    return roleColors[role] ?? Colors.grey;
  }

  String _getRoleDisplayName(String role) {
    const roleNames = {
      'ADMIN': 'Admin',
      'RECEPCIONIST': 'Recepcionista',
      'CLEANING': 'Limpieza',
      'CUSTOMER': 'Cliente',
    };
    return roleNames[role] ?? role;
  }
}