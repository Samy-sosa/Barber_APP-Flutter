// lib/presentation/screens/tenant_admin/service_management_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barberapp_yucatan/presentation/providers/tenant_admin_provider.dart';
import 'package:barberapp_yucatan/core/theme/colors.dart';
// IMPORTANTE: Importar la pantalla de creación
import 'package:barberapp_yucatan/presentation/screens/tenant_admin/service_create_screen.dart';

class ServiceManagementScreen extends StatefulWidget {
  const ServiceManagementScreen({super.key});

  @override
  State<ServiceManagementScreen> createState() => _ServiceManagementScreenState();
}

class _ServiceManagementScreenState extends State<ServiceManagementScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = context.read<TenantAdminProvider>();
    await provider.loadServices();
  }

  // Método para navegar a crear servicio
  Future<void> _navigateToCreateService() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const ServiceCreateScreen()),
    );

    if (result == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TenantAdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToCreateService, // Conectado
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.services.isEmpty
          ? _buildEmptyState()
          : _buildServiceList(provider),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction_outlined, size: 80, color: AppColors.textHint),
          const SizedBox(height: 16),
          const Text(
            'No tienes servicios registrados',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega los servicios que ofreces en tu barbería',
            style: TextStyle(color: AppColors.textHint),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _navigateToCreateService, // Conectado
            icon: const Icon(Icons.add),
            label: const Text('Agregar Servicio'),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceList(TenantAdminProvider provider) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.services.length,
        itemBuilder: (context, index) {
          final service = provider.services[index];
          return Card(
            child: ListTile(
              leading: service.imageUrl != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  service.imageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50,
                      height: 50,
                      color: AppColors.primary.withOpacity(0.2),
                      child: const Icon(Icons.construction),
                    );
                  },
                ),
              )
                  : Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.construction),
              ),
              title: Text(service.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (service.description != null)
                    Text(
                      service.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: AppColors.textHint, fontSize: 12),
                    ),
                  Row(
                    children: [
                      Text(
                        '\$${service.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        service.durationFormatted,
                        style: TextStyle(color: AppColors.textHint, fontSize: 12),
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
                      color: service.isActive ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      service.isActive ? 'Activo' : 'Inactivo',
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
                          service.isActive ? 'Desactivar' : 'Activar',
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
                      _handleAction(value, service.id);
                    },
                  ),
                ],
              ),
              onTap: () {
                // TODO: Ver detalle del servicio
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleAction(String action, int serviceId) async {
    final provider = context.read<TenantAdminProvider>();

    switch (action) {
      case 'edit':
      // TODO: Navegar a editar servicio
        break;
      case 'toggle':
        await provider.toggleService(serviceId);
        break;
      case 'delete':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Eliminar Servicio'),
            content: const Text('¿Estás seguro que deseas eliminar este servicio?'),
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
          await provider.deleteService(serviceId);
        }
        break;
    }
  }
}