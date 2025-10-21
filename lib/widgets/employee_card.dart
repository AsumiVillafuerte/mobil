import 'package:flutter/material.dart';
import '../models/employee.dart';

class EmployeeCard extends StatefulWidget {
  final Employee employee;
  final VoidCallback onToggleStatus;
  final VoidCallback onViewProfile;
  final VoidCallback onEdit;

  const EmployeeCard({
    Key? key,
    required this.employee,
    required this.onToggleStatus,
    required this.onViewProfile,
    required this.onEdit,
  }) : super(key: key);

  @override
  State<EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard>
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
      end: const Offset(-0.4, 0), // Desplazamiento reducido hacia la izquierda
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
            // Background actions (solo iconos)
            _buildActionBackground(),
            // Main card content
            SlideTransition(
              position: _slideAnimation,
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! < -500) {
                    // Swipe left
                    if (!_isSwipedOpen) _toggleSwipe();
                  } else if (details.primaryVelocity! > 500) {
                    // Swipe right
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
        width: 140, // Ancho ajustado para los dos círculos
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // Mismo radio que la tarjeta
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Edit action - círculo perfecto
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50), // Verde como en tu imagen
                shape: BoxShape.circle,
              ),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    _closeSwipe();
                    widget.onEdit();
                  },
                  child: const Center(
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            // Delete action - círculo perfecto
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFFF44336), // Rojo como en tu imagen
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
                      widget.employee.isActive ? Icons.delete : Icons.restore,
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
      onTap: widget.onViewProfile, // Al hacer tap en toda la tarjeta, abre el perfil
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
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
            const SizedBox(height: 8),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          backgroundColor: Color(0xFFE8F5E8),
          child: Icon(Icons.person, color: Color(0xFF4CAF50)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.employee.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  _buildStatusBadge(),
                ],
              ),
              Text(
                'ID: ${widget.employee.id}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: widget.employee.isActive 
            ? const Color(0xFFE8F5E8) 
            : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        widget.employee.isActive ? 'Activo' : 'Inactivo',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: widget.employee.isActive 
              ? const Color(0xFF4CAF50) 
              : const Color(0xFFE57373),
        ),
      ),
    );
  }

  Widget _buildEyeButton() {
    return IconButton(
      icon: const Icon(Icons.visibility, color: Colors.grey),
      onPressed: widget.onViewProfile,
      iconSize: 20,
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(
        minWidth: 32,
        minHeight: 32,
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.phone, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              widget.employee.phone,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Image.network(
              'https://cdn.cdnlogo.com/logos/g/24/gmail.svg',
              height: 16,
              width: 16,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.email, size: 16, color: Colors.grey);
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.employee.email,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        const Icon(Icons.schedule, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          'Desde ${widget.employee.registrationDate}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const Spacer(),
        _buildShiftBadge(),
      ],
    );
  }

  Widget _buildShiftBadge() {
  Color backgroundColor;
  Color textColor;

  if (widget.employee.shift == 'Mañana') {
    backgroundColor = const Color(0xFFE3F2FD); // azul claro
    textColor = const Color(0xFF1976D2);       // azul fuerte
  } else if (widget.employee.shift == 'Tarde') {
    backgroundColor = const Color(0xFFFFF3E0); // naranja claro
    textColor = const Color(0xFFFF9800);       // naranja
  } else if (widget.employee.shift == 'Noche') {
    backgroundColor = const Color(0xFFF3E5F5); // morado claro
    textColor = const Color(0xFF7B1FA2);       // morado
  } else {
    backgroundColor = Colors.grey.shade200;
    textColor = Colors.grey.shade600;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      widget.employee.shift,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    ),
  );
}

}