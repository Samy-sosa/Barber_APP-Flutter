// lib/presentation/screens/tenant_admin/widgets/admin_drawer.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barberapp_yucatan/presentation/providers/auth_provider.dart';
import 'package:barberapp_yucatan/core/theme/colors.dart';

// IMPORTAR TODAS LAS PANTALLAS
import 'package:barberapp_yucatan/presentation/screens/tenant_admin/barber_management_screen.dart';
import 'package:barberapp_yucatan/presentation/screens/tenant_admin/service_management_screen.dart';
// Importa las demás pantallas que existan (ej: service_management, appointments, etc.)

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Column(
          children: [
            // Header (igual que antes)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.black,
                    child: Text(
                      authProvider.userName?.substring(0, 1).toUpperCase() ?? 'A',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    authProvider.userName ?? 'Administrador',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    authProvider.userEmail ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'TENANT ADMIN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Menú (Ahora usa Navigator.push directo)
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                      // Si ya estás en el home, no hagas nada
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.store,
                    title: 'Mi Barbería',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navegar a pantalla de perfil (si existe)
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.people,
                    title: 'Barberos',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BarberManagementScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.construction,
                    title: 'Servicios',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ServiceManagementScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.schedule,
                    title: 'Horarios',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navegar a pantalla de horarios (si existe)
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.calendar_today,
                    title: 'Citas',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navegar a pantalla de citas (si existe)
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.assessment,
                    title: 'Métricas',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navegar a pantalla de métricas (si existe)
                    },
                  ),
                  const Divider(color: AppColors.primary, thickness: 0.5),
                  _buildDrawerItem(
                    icon: Icons.payment,
                    title: 'Mercado Pago',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navegar a pantalla de Mercado Pago (si existe)
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings,
                    title: 'Configuración',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navegar a pantalla de configuración (si existe)
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.help,
                    title: 'Ayuda',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navegar a pantalla de ayuda (si existe)
                    },
                  ),
                  const Divider(color: AppColors.primary, thickness: 0.5),
                  _buildDrawerItem(
                    icon: Icons.logout,
                    title: 'Cerrar Sesión',
                    color: Colors.red,
                    onTap: () => _logout(context),
                  ),
                ],
              ),
            ),

            // Versión
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'BarberApp Yucatán v1.0.0',
                style: TextStyle(
                  color: AppColors.textHint,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textHint,
        size: 18,
      ),
      onTap: onTap,
    );
  }

  void _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.logout();
      // Regresa al login
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }
}