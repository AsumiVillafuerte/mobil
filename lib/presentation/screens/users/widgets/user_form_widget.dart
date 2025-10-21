// lib/presentation/screens/users/widgets/user_form_widget.dart
import 'package:flutter/material.dart';
import 'package:myapp/data/models/auth/user_model.dart';

class UserFormWidget extends StatefulWidget {
  final UserModel? user; // null = crear, con datos = editar
  final Function(Map<String, dynamic>) onSubmit;
  final bool isLoading;

  const UserFormWidget({
    super.key,
    this.user,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<UserFormWidget> createState() => _UserFormWidgetState();
}

class _UserFormWidgetState extends State<UserFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _documentNumberController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  late String _selectedDocumentType;
  String? _selectedGender;
  late int _selectedRoleId;
  String? _selectedShift;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final List<String> _documentTypes = ['DNI', 'Carnet de Extranjería'];
  final List<String> _shifts = ['Mañana', 'Tarde', 'Noche'];

  bool get isEditing => widget.user != null;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (isEditing) {
      // Modo edición: cargar datos existentes
      _nameController = TextEditingController(text: widget.user!.names);
      _surnameController = TextEditingController(text: widget.user!.surnames);
      _emailController = TextEditingController(text: widget.user!.email);
      _phoneController = TextEditingController(text: widget.user!.phone ?? '');
      _documentNumberController = TextEditingController(text: widget.user!.documentNumber);
      _passwordController = TextEditingController();
      _confirmPasswordController = TextEditingController();
      
      _selectedDocumentType = widget.user!.documentType;
      _selectedGender = widget.user!.gender;
      _selectedRoleId = widget.user!.role.idRole;
      _selectedShift = widget.user!.shift;
    } else {
      // Modo crear: controladores vacíos
      _nameController = TextEditingController();
      _surnameController = TextEditingController();
      _emailController = TextEditingController();
      _phoneController = TextEditingController();
      _documentNumberController = TextEditingController();
      _passwordController = TextEditingController();
      _confirmPasswordController = TextEditingController();
      
      _selectedDocumentType = 'DNI';
      _selectedRoleId = 4; // Cliente por defecto
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _documentNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),

            _buildSectionTitle('Información Personal', Icons.person_outline_rounded),
            const SizedBox(height: 16),
            
            _buildTextField(
              controller: _nameController,
              label: 'Nombres',
              hint: 'Ingrese los nombres',
              icon: Icons.person_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Los nombres son obligatorios';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _surnameController,
              label: 'Apellidos',
              hint: 'Ingrese los apellidos',
              icon: Icons.person_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Los apellidos son obligatorios';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            _buildGenderSelector(),
            const SizedBox(height: 32),

            _buildSectionTitle('Documento de Identidad', Icons.badge_rounded),
            const SizedBox(height: 16),

            _buildDocumentTypeDropdown(),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _documentNumberController,
              label: 'Número de Documento',
              hint: 'Ingrese el número',
              icon: Icons.credit_card_rounded,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El número de documento es obligatorio';
                }
                if (_selectedDocumentType == 'DNI' && value.length != 8) {
                  return 'El DNI debe tener 8 dígitos';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            _buildSectionTitle('Información de Contacto', Icons.contact_mail_rounded),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _emailController,
              label: 'Correo Electrónico',
              hint: 'ejemplo@correo.com',
              icon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
              enabled: !isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El correo es obligatorio';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Ingrese un correo válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _phoneController,
              label: 'Teléfono (Opcional)',
              hint: '999999999',
              icon: Icons.phone_rounded,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 32),

            _buildSectionTitle('Rol en el Sistema', Icons.work_rounded),
            const SizedBox(height: 16),

            _buildRoleSelector(),
            const SizedBox(height: 16),

            if (_selectedRoleId == 3) ...[
              _buildShiftDropdown(),
              const SizedBox(height: 32),
            ] else
              const SizedBox(height: 16),

            if (!isEditing) ...[
              _buildSectionTitle('Credenciales de Acceso', Icons.lock_rounded),
              const SizedBox(height: 16),

              _buildPasswordField(
                controller: _passwordController,
                label: 'Contraseña',
                hint: 'Mínimo 6 caracteres',
                isVisible: _isPasswordVisible,
                onToggle: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La contraseña es obligatoria';
                  }
                  if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildPasswordField(
                controller: _confirmPasswordController,
                label: 'Confirmar Contraseña',
                hint: 'Repita la contraseña',
                isVisible: _isConfirmPasswordVisible,
                onToggle: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Debe confirmar la contraseña';
                  }
                  if (value != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
            ],

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.isLoading ? null : () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Cancelar'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Color(0xFF1565C0)),
                      foregroundColor: const Color(0xFF1565C0),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: widget.isLoading ? null : _handleSubmit,
                    icon: widget.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_rounded),
                    label: Text(
                      widget.isLoading
                          ? 'Guardando...'
                          : isEditing
                              ? 'Actualizar Usuario'
                              : 'Guardar Usuario',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1565C0).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              isEditing ? Icons.edit_rounded : Icons.person_add_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isEditing ? 'Editar Usuario' : 'Registrar Nuevo Usuario',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEditing
                ? 'Actualice los datos del usuario'
                : 'Complete los datos del nuevo usuario',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF1565C0), size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(Icons.lock_rounded, color: Color(0xFF1565C0)),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                color: const Color(0xFF757575),
              ),
              onPressed: onToggle,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Género',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption('M', 'Masculino', Icons.male_rounded),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGenderOption('F', 'Femenino', Icons.female_rounded),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(String value, String label, IconData icon) {
    final isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1565C0).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1565C0) : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF1565C0) : const Color(0xFF757575),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? const Color(0xFF1565C0) : const Color(0xFF757575),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de Documento',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedDocumentType,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.description_rounded, color: Color(0xFF1565C0)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'DNI', child: Text('DNI - Documento Nacional de Identidad')),
            DropdownMenuItem(value: 'CNE', child: Text('CNE - Carnet de Extranjería')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedDocumentType = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rol del Usuario',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildRoleChip(1, 'Admin', Icons.admin_panel_settings_rounded, const Color(0xFF9C27B0)),
            _buildRoleChip(2, 'Recepcionista', Icons.support_agent_rounded, const Color(0xFF2196F3)),
            _buildRoleChip(3, 'Limpieza', Icons.cleaning_services_rounded, const Color(0xFF4CAF50)),
            _buildRoleChip(4, 'Cliente', Icons.person_rounded, const Color(0xFFFF9800)),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleChip(int roleId, String label, IconData icon, Color color) {
    final isSelected = _selectedRoleId == roleId;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: isSelected ? Colors.white : color),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        setState(() {
          _selectedRoleId = roleId;
          if (roleId != 3) {
            _selectedShift = null;
          }
        });
      },
      selectedColor: color,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : color,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildShiftDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Turno de Trabajo',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedShift,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.access_time_rounded, color: Color(0xFF1565C0)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
            ),
          ),
          hint: const Text('Seleccione un turno'),
          items: _shifts.map((shift) {
            return DropdownMenuItem(value: shift, child: Text(shift));
          }).toList(),
          validator: (value) {
            if (_selectedRoleId == 3 && (value == null || value.isEmpty)) {
              return 'El turno es obligatorio para empleados de limpieza';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _selectedShift = value;
            });
          },
        ),
      ],
    );
  }

  // ✅ MÉTODO ACTUALIZADO
  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userData = <String, dynamic>{
      'names': _nameController.text.trim(),
      'surnames': _surnameController.text.trim(),
      'email': _emailController.text.trim(),
      'documentType': _selectedDocumentType,
      'documentNumber': _documentNumberController.text.trim(),
      'state': 'A',
    };

    // ✅ MODO EDICIÓN
    if (isEditing) {
      userData['idUser'] = widget.user!.idUser;
      
      // ✅ ENVIAR ROL COMPLETO
      userData['role'] = {
        'idRole': _selectedRoleId,
        'name': _getRoleName(_selectedRoleId),
        'state': 'A',
      };
      
      // ✅ CRÍTICO: Mantener fecha de registro original
      userData['registrationDate'] = widget.user!.registrationDate;
      
    } else {
      // ✅ MODO CREAR
      userData['role'] = {'idRole': _selectedRoleId};
      userData['password'] = _passwordController.text;
    }

    // Campos opcionales
    if (_phoneController.text.trim().isNotEmpty) {
      userData['phone'] = _phoneController.text.trim();
    }
    
    if (_selectedGender != null) {
      userData['gender'] = _selectedGender;
    }
    
    if (_selectedShift != null) {
      userData['shift'] = _selectedShift;
    }

    // 🔍 DEBUG
    print('═══════════════════════════════');
    print('📤 DATOS (${isEditing ? "UPDATE" : "CREATE"}):');
    print('═══════════════════════════════');
    userData.forEach((key, value) {
      print('$key: $value');
    });
    print('═══════════════════════════════\n');

    widget.onSubmit(userData);
  }

  // ✅ HELPER AGREGADO
  String _getRoleName(int roleId) {
    const roleNames = {
      1: 'ADMIN',
      2: 'RECEPCIONIST',
      3: 'CLEANING',
      4: 'CUSTOMER',
    };
    return roleNames[roleId] ?? 'CUSTOMER';
  }
}