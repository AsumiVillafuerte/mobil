// ==========================================
// 👥 USERS - lib/presentation/screens/users/users_list_screen.dart
// ==========================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/data/models/auth/user_model.dart';
import 'package:myapp/presentation/providers/users_provider.dart';
import 'widgets/user_card_widget.dart';
import 'widgets/user_profile_modal.dart';
import 'create_user_screen.dart';
import 'edit_user_screen.dart';

class UsersListScreen extends StatefulWidget {
  final UserModel? user;
  final bool employeesOnly;

  const UsersListScreen({
    super.key,
    this.user,
    this.employeesOnly = false,
  });

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UsersProvider>(context, listen: false);
      if (widget.employeesOnly) {
        provider.filterByRole(3);
      } else {
        provider.loadUsers();
      }
    });
    
    // ✅ Listener para búsqueda en tiempo real
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ✅ MÉTODO DE BÚSQUEDA
  List<UserModel> _filterUsers(List<UserModel> users) {
    if (_searchQuery.isEmpty) {
      return users;
    }

    return users.where((user) {
      final fullName = user.fullName.toLowerCase();
      final email = user.email.toLowerCase();
      final documentNumber = user.documentNumber.toLowerCase();
      final query = _searchQuery;

      return fullName.contains(query) ||
             email.contains(query) ||
             documentNumber.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(widget.employeesOnly ? 'Personal' : 'Usuarios'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => _showFilterModal(context),
            tooltip: 'Filtrar',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateUserScreen(),
            ),
          );
          
          if (result == true && context.mounted) {
            final provider = Provider.of<UsersProvider>(context, listen: false);
            provider.loadUsers();
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo Usuario'),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: Consumer<UsersProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1565C0),
              ),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      provider.errorMessage!,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => provider.loadUsers(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Reintentar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // ✅ APLICAR BÚSQUEDA A LA LISTA FILTRADA
          final filteredUsers = _filterUsers(provider.users);

          if (provider.users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline_rounded,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay usuarios',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Presiona el botón + para agregar uno',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // ✅ BARRA DE BÚSQUEDA
              _buildSearchBar(),
              
              // Filtros aplicados
              _buildFilterHeader(provider),
              
              // Lista de usuarios
              Expanded(
                child: filteredUsers.isEmpty
                    ? _buildEmptySearchResult()
                    : RefreshIndicator(
                        color: const Color(0xFF1565C0),
                        onRefresh: () => provider.loadUsers(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return UserCardWidget(
                              user: user,
                              onViewProfile: () {
                                UserProfileModal.show(context, user);
                              },
                              onEdit: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditUserScreen(user: user),
                                  ),
                                );
                                
                                if (result == true && context.mounted) {
                                  provider.loadUsers();
                                }
                              },
                              onToggleStatus: () {
                                _showToggleStatusDialog(context, provider, user);
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ✅ WIDGET BARRA DE BÚSQUEDA
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar por nombre, correo o documento...',
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF1565C0)),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: Color(0xFF757575)),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: const Color(0xFFF5F7FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  // ✅ WIDGET CUANDO NO HAY RESULTADOS
  Widget _buildEmptySearchResult() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No se encontraron resultados',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Intenta con otro término de búsqueda',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
              icon: const Icon(Icons.clear_rounded),
              label: const Text('Limpiar búsqueda'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1565C0),
                side: const BorderSide(color: Color(0xFF1565C0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterHeader(UsersProvider provider) {
    final hasFilters = provider.currentFilter != 'Todos' || 
                      provider.selectedRoleId != null || 
                      _searchQuery.isNotEmpty;

    if (!hasFilters) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF1565C0).withOpacity(0.1),
      child: Row(
        children: [
          const Icon(
            Icons.filter_alt_rounded,
            size: 20,
            color: Color(0xFF1565C0),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _buildFilterText(provider),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1565C0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (hasFilters)
            TextButton.icon(
              onPressed: () {
                provider.clearFilters();
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
              icon: const Icon(Icons.close_rounded, size: 18),
              label: const Text('Limpiar todo'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1565C0),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
        ],
      ),
    );
  }

  String _buildFilterText(UsersProvider provider) {
    final filters = <String>[];
    
    if (_searchQuery.isNotEmpty) {
      filters.add('Búsqueda: "$_searchQuery"');
    }
    
    if (provider.currentFilter != 'Todos') {
      filters.add(provider.currentFilter);
    }
    
    if (provider.selectedRoleId != null) {
      filters.add(_getRoleName(provider.selectedRoleId!));
    }
    
    return filters.isEmpty ? 'Todos' : filters.join(' · ');
  }

  void _showFilterModal(BuildContext context) {
    final provider = Provider.of<UsersProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1565C0).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.filter_list_rounded,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Filtrar Usuarios',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Estado',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF757575),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: ['Todos', 'Activos', 'Inactivos'].map((filter) {
                      final isSelected = provider.currentFilter == filter;
                      return ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          provider.filterByState(filter);
                          setState(() {});
                        },
                        selectedColor: const Color(0xFF1565C0),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Rol',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF757575),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildRoleChip(null, 'Todos', provider, setState),
                      _buildRoleChip(1, 'Admin', provider, setState),
                      _buildRoleChip(2, 'Recepcionista', provider, setState),
                      _buildRoleChip(3, 'Limpieza', provider, setState),
                      _buildRoleChip(4, 'Cliente', provider, setState),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            provider.clearFilters();
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1565C0),
                          ),
                          child: const Text('Limpiar Filtros'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Aplicar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRoleChip(int? roleId, String label, UsersProvider provider, StateSetter setState) {
    final isSelected = provider.selectedRoleId == roleId;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        provider.filterByRole(roleId);
        setState(() {});
      },
      selectedColor: const Color(0xFF1565C0),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  void _showToggleStatusDialog(BuildContext context, UsersProvider provider, UserModel user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              user.isActive ? Icons.delete_rounded : Icons.restore_rounded,
              color: user.isActive ? Colors.red : const Color(0xFF4CAF50),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                user.isActive ? 'Eliminar Usuario' : 'Restaurar Usuario',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(
          user.isActive
              ? '¿Estás seguro de que deseas eliminar a ${user.fullName}?'
              : '¿Estás seguro de que deseas restaurar a ${user.fullName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Procesando...'),
                      ],
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );
              }

              final success = await provider.toggleUserStatus(user);
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          success ? Icons.check_circle_rounded : Icons.error_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            success
                                ? user.isActive
                                    ? 'Usuario eliminado correctamente'
                                    : 'Usuario restaurado correctamente'
                                : 'Error al actualizar el usuario',
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: success ? const Color(0xFF4CAF50) : Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: user.isActive ? Colors.red : const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
            ),
            child: Text(user.isActive ? 'Eliminar' : 'Restaurar'),
          ),
        ],
      ),
    );
  }

  String _getRoleName(int roleId) {
    const roleNames = {
      1: 'Admin',
      2: 'Recepcionista',
      3: 'Limpieza',
      4: 'Cliente',
    };
    return roleNames[roleId] ?? 'Desconocido';
  }
}