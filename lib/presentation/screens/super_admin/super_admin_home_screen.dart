// lib/presentation/screens/super_admin/super_admin_home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:barberapp_yucatan/core/theme/colors.dart';
import 'package:barberapp_yucatan/presentation/providers/auth_provider.dart';
import 'package:barberapp_yucatan/presentation/providers/super_admin_provider.dart';

class SuperAdminHomeScreen extends StatefulWidget {
  const SuperAdminHomeScreen({super.key});

  @override
  State<SuperAdminHomeScreen> createState() => _SuperAdminHomeScreenState();
}

class _SuperAdminHomeScreenState extends State<SuperAdminHomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = context.read<SuperAdminProvider>();
    await provider.loadAllData();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SuperAdminProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: _buildAppBar(authProvider),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
        onRefresh: _loadData,
        child: _buildBody(provider),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AuthProvider authProvider) {
    return AppBar(
      backgroundColor: const Color(0xFF0A0A0A),
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Panel de Control',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Bienvenido, ${authProvider.userName ?? 'Administrador'}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
          ),
          child: const Text(
            'SUPER ADMIN',
            style: TextStyle(
              color: Colors.red,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildBody(SuperAdminProvider provider) {
    final metrics = provider.metrics;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============ TARJETAS DE MÉTRICAS ============
          if (metrics != null) ...[
            const Text(
              'Resumen General',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildMetricCard(
                  title: 'Usuarios',
                  value: metrics['totalUsers']?.toString() ?? '0',
                  icon: Icons.people_outline,
                  color: Colors.blue,
                ),
                _buildMetricCard(
                  title: 'Barberías',
                  value: metrics['totalBarbershops']?.toString() ?? '0',
                  icon: Icons.store_outlined,
                  color: AppColors.primary,
                ),
                _buildMetricCard(
                  title: 'Citas Totales',
                  value: metrics['totalAppointments']?.toString() ?? '0',
                  icon: Icons.calendar_today_outlined,
                  color: Colors.green,
                ),
                _buildMetricCard(
                  title: 'Ingresos',
                  value: '\$${metrics['totalRevenue']?.toString() ?? '0'}',
                  icon: Icons.attach_money_outlined,
                  color: Colors.amber,
                ),
                _buildMetricCard(
                  title: 'Calificación Promedio',
                  value: metrics['averageRating']?.toStringAsFixed(1) ?? '0.0',
                  icon: Icons.star_outlined,
                  color: Colors.purple,
                ),
                _buildMetricCard(
                  title: 'Suscripciones Activas',
                  value: metrics['activeSubscriptions']?.toString() ?? '0',
                  icon: Icons.verified_outlined,
                  color: Colors.teal,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          // ============ LISTA DE BARBERÍAS ============
          const Text(
            'Barberías Registradas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          if (provider.barbershops.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.store_outlined,
                    size: 48,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No hay barberías registradas',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.barbershops.length,
              itemBuilder: (context, index) {
                final barbershop = provider.barbershops[index];
                return _buildBarbershopCard(barbershop);
              },
            ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarbershopCard(Map<String, dynamic> barbershop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                barbershop['name']?.substring(0, 1).toUpperCase() ?? 'B',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  barbershop['name'] ?? 'Sin nombre',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Dueño: ${barbershop['ownerName'] ?? 'N/A'}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildSmallStat(
                      icon: Icons.people_outline,
                      value: barbershop['totalBarbers']?.toString() ?? '0',
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 12),
                    _buildSmallStat(
                      icon: Icons.construction_outlined,
                      value: barbershop['totalServices']?.toString() ?? '0',
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    _buildSmallStat(
                      icon: Icons.calendar_today_outlined,
                      value: barbershop['totalAppointments']?.toString() ?? '0',
                      color: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (barbershop['hasActiveSubscription'] ?? false)
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (barbershop['hasActiveSubscription'] ?? false)
                    ? Colors.green.withOpacity(0.3)
                    : Colors.red.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              (barbershop['hasActiveSubscription'] ?? false)
                  ? 'Activo'
                  : 'Inactivo',
              style: TextStyle(
                color: (barbershop['hasActiveSubscription'] ?? false)
                    ? Colors.green
                    : Colors.red,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStat({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color.withOpacity(0.6), size: 12),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}