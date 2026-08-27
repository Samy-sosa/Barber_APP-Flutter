// lib/presentation/screens/tenant_admin/widgets/admin_appointments_chart.dart

import 'package:flutter/material.dart';
import 'package:barberapp_yucatan/core/theme/colors.dart';

class AdminAppointmentsChart extends StatelessWidget {
  final List<dynamic> appointments;

  const AdminAppointmentsChart({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    // Calcular estadísticas de las citas
    final total = appointments.length;
    final pending = appointments.where((a) => a['status'] == 'PENDING').length;
    final confirmed = appointments.where((a) => a['status'] == 'CONFIRMED').length;
    final completed = appointments.where((a) => a['status'] == 'COMPLETED').length;
    final cancelled = appointments.where((a) => a['status'] == 'CANCELLED').length;
    final noShow = appointments.where((a) => a['status'] == 'NO_SHOW').length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen de Citas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Gráfico de barras simple
            if (total > 0)
              Column(
                children: [
                  _buildBar('Pendientes', pending, total, Colors.orange),
                  const SizedBox(height: 8),
                  _buildBar('Confirmadas', confirmed, total, Colors.blue),
                  const SizedBox(height: 8),
                  _buildBar('Completadas', completed, total, Colors.green),
                  const SizedBox(height: 8),
                  _buildBar('Canceladas', cancelled, total, Colors.red),
                  const SizedBox(height: 8),
                  _buildBar('No Asistió', noShow, total, Colors.grey),
                ],
              )
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No hay citas registradas',
                    style: TextStyle(color: AppColors.textHint),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Resumen total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Total', total.toString(), Colors.white),
                _buildSummaryItem(
                  'Pendientes',
                  pending.toString(),
                  Colors.orange,
                ),
                _buildSummaryItem(
                  'Confirmadas',
                  confirmed.toString(),
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(String label, int value, int total, Color color) {
    final percentage = total > 0 ? (value / total) * 100 : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 40,
              child: Text(
                '$value',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textHint,
          ),
        ),
      ],
    );
  }
}