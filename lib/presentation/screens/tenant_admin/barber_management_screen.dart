// lib/presentation/screens/tenant_admin/barber_management_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barberapp_yucatan/presentation/providers/tenant_admin_provider.dart';
import 'package:barberapp_yucatan/core/theme/colors.dart';
import 'package:image_picker/image_picker.dart';
// IMPORTANTE: Agregar la importación de la pantalla de crear
import 'package:barberapp_yucatan/presentation/screens/tenant_admin/barber_create_screen.dart';

class BarberManagementScreen extends StatefulWidget {
  const BarberManagementScreen({super.key});

  @override
  State<BarberManagementScreen> createState() => _BarberManagementScreenState();
}

class _BarberManagementScreenState extends State<BarberManagementScreen> {
  // Quitamos la variable _picker ya que no se usa en esta pantalla
  // final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = context.read<TenantAdminProvider>();
    await provider.loadBarbers();
  }

  // Método para navegar a la pantalla de crear
  Future<void> _navigateToCreateBarber() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const BarberCreateScreen()),
    );

    // Si la creación fue exitosa (retornó true), recargamos la lista
    if (result == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TenantAdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barberos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToCreateBarber, // Conectado
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.barbers.isEmpty
          ? _buildEmptyState()
          : _buildBarberList(provider),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: AppColors.textHint),
          const SizedBox(height: 16),
          const Text(
            'No tienes barberos registrados',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega tu primer barbero para empezar a recibir citas',
            style: TextStyle(color: AppColors.textHint),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _navigateToCreateBarber, // Conectado
            icon: const Icon(Icons.add),
            label: const Text('Agregar Barbero'),
          ),
        ],
      ),
    );
  }

  Widget _buildBarberList(TenantAdminProvider provider) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.barbers.length,
        itemBuilder: (context, index) {
          final barber = provider.barbers[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: barber.photoUrl != null
                    ? NetworkImage(barber.photoUrl!)
                    : null,
                child: barber.photoUrl == null
                    ? Text(
                  barber.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : null,
              ),
              title: Text(barber.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (barber.specialty != null)
                    Text(
                      barber.specialty!,
                      style: TextStyle(color: AppColors.textHint, fontSize: 12),
                    ),
                  if (barber.rating != null)
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          barber.rating!.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Text(' • ', style: TextStyle(fontSize: 12)),
                        Text(
                          '${barber.totalReviews ?? 0} reseñas',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: barber.isActive ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      barber.isActive ? 'Activo' : 'Inactivo',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Editar'),
                      ),
                      PopupMenuItem(
                        value: 'toggle',
                        child: Text(
                          barber.isActive ? 'Desactivar' : 'Activar',
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Eliminar',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      _handleAction(value, barber.id);
                    },
                  ),
                ],
              ),
              onTap: () {
                // TODO: Ver detalle del barbero
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleAction(String action, int barberId) async {
    final provider = context.read<TenantAdminProvider>();

    switch (action) {
      case 'edit':
      // TODO: Navegar a editar barbero
        break;
      case 'toggle':
        await provider.toggleBarber(barberId);
        break;
      case 'delete':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Eliminar Barbero'),
            content: const Text('¿Estás seguro que deseas eliminar este barbero?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Eliminar'),
              ),
            ],
          ),
        );
        if (confirm == true) {
          await provider.deleteBarber(barberId);
        }
        break;
    }
  }
}