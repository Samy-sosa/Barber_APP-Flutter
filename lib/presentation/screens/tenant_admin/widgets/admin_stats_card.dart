// lib/presentation/screens/tenant_admin/widgets/admin_stats_card.dart

import 'package:flutter/material.dart';
import 'package:barberapp_yucatan/core/theme/colors.dart';

class AdminStatsCard extends StatelessWidget {
  final Map<String, dynamic> metrics;

  const AdminStatsCard({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildStatItem(
                  icon: Icons.calendar_today,
                  value: metrics['totalAppointments']?.toString() ?? '0',
                  label: 'Citas Totales',
                  color: Colors.blue,
                ),
                _buildStatItem(
                  icon: Icons.people,
                  value: metrics['totalClients']?.toString() ?? '0',
                  label: 'Clientes',
                  color: Colors.green,
                ),
                _buildStatItem(
                  icon: Icons.person,
                  value: metrics['totalBarbers']?.toString() ?? '0',
                  label: 'Barberos',
                  color: Colors.orange,
                ),
                _buildStatItem(
                  icon: Icons.monetization_on,
                  value: '\$${metrics['monthlyRevenue']?.toString() ?? '0'}',
                  label: 'Ingresos Mensuales',
                  color: AppColors.primary,
                ),
                _buildStatItem(
                  icon: Icons.star,
                  value: metrics['averageRating']?.toStringAsFixed(1) ?? '0.0',
                  label: 'Calificación',
                  color: Colors.amber,
                ),
                _buildStatItem(
                  icon: Icons.trending_up,
                  value: '${metrics['completionRate']?.toStringAsFixed(0) ?? '0'}%',
                  label: 'Tasa de Cumplimiento',
                  color: Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textHint,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}