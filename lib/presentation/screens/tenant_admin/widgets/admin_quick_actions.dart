// lib/presentation/screens/tenant_admin/widgets/admin_quick_actions.dart

import 'package:flutter/material.dart';
import 'package:barberapp_yucatan/core/theme/colors.dart';

// Importar pantallas de creación
import 'package:barberapp_yucatan/presentation/screens/tenant_admin/barber_create_screen.dart';
import 'package:barberapp_yucatan/presentation/screens/tenant_admin/service_create_screen.dart';

class AdminQuickActions extends StatelessWidget {
  const AdminQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Acciones Rápidas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          childAspectRatio: 0.9,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: [
            _buildQuickAction(
              icon: Icons.add,
              label: 'Nueva Cita',
              color: Colors.blue,
              onTap: () {
                // TODO: Navegar a crear cita
              },
            ),
            _buildQuickAction(
              icon: Icons.person_add,
              label: 'Nuevo Barbero',
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BarberCreateScreen()),
                );
              },
            ),
            _buildQuickAction(
              icon: Icons.construction,
              label: 'Nuevo Servicio',
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ServiceCreateScreen()),
                );
              },
            ),
            _buildQuickAction(
              icon: Icons.schedule,
              label: 'Nuevo Horario',
              color: Colors.purple,
              onTap: () {
                // TODO: Navegar a crear horario
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}