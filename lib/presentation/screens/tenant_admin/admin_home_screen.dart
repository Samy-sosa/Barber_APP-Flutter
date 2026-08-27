// lib/presentation/screens/tenant_admin/admin_home_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:barberapp_yucatan/core/theme/colors.dart';
import 'package:barberapp_yucatan/presentation/providers/auth_provider.dart';
import 'package:barberapp_yucatan/presentation/providers/tenant_admin_provider.dart';
import 'package:barberapp_yucatan/presentation/screens/tenant_admin/widgets/admin_drawer.dart';
import 'package:barberapp_yucatan/presentation/screens/tenant_admin/widgets/admin_quick_actions.dart';
import 'package:barberapp_yucatan/presentation/screens/tenant_admin/widgets/admin_stats_card.dart';
import 'package:barberapp_yucatan/presentation/screens/tenant_admin/widgets/admin_appointments_chart.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = context.read<AuthProvider>();
    final provider = context.read<TenantAdminProvider>();
    final barbershopId = authProvider.barbershopId;

    if (barbershopId != null) {
      await provider.loadBarbershop(barbershopId);
      await provider.loadMetrics(barbershopId);
      await provider.loadStats(barbershopId);
      await provider.loadBarbers(barbershopId: barbershopId);
      await provider.loadServices(barbershopId: barbershopId);
      await provider.loadAppointments(barbershopId: barbershopId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TenantAdminProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      drawer: const AdminDrawer(), // ✅ MENÚ LATERAL QUE YA TENÍAS
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: _buildAppBar(authProvider),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
        onRefresh: _loadData,
        child: _buildBody(provider, authProvider),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar(AuthProvider authProvider) {
    return AppBar(
      backgroundColor: const Color(0xFF0A0A0A),
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Barbería ${authProvider.userName ?? ''}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Hoy, ${_formatDate(DateTime.now())}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            // TODO: Navegar a notificaciones
          },
        ),
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.primary,
          child: Text(
            authProvider.userName?.substring(0, 1).toUpperCase() ?? 'U',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildBody(TenantAdminProvider provider, AuthProvider authProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // ============ ESTADO DE LA BARBERÍA ============
          if (provider.barbershop != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: provider.barbershop!.isActive
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: provider.barbershop!.isActive
                      ? Colors.green
                      : Colors.red,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    provider.barbershop!.isActive
                        ? Icons.check_circle
                        : Icons.warning,
                    color: provider.barbershop!.isActive
                        ? Colors.green
                        : Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      provider.barbershop!.isActive
                          ? '✅ Activa y visible para clientes'
                          : '⚠️ Inactiva. Actívala para recibir reservas',
                      style: TextStyle(
                        color: provider.barbershop!.isActive
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),

          // ============ TARJETAS DE ESTADÍSTICAS (estilo agenda) ============
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'TURNOS',
                  value: provider.metrics?['totalAppointments']?.toString() ?? '0',
                  icon: Icons.calendar_today_outlined,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  title: 'INGRESOS',
                  value: '\$${provider.metrics?['monthlyRevenue']?.toString() ?? '0'}',
                  icon: Icons.attach_money_outlined,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  title: 'ESTE MES',
                  value: provider.metrics?['totalAppointmentsThisMonth']?.toString() ?? '0',
                  icon: Icons.trending_up_outlined,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ============ ACCIONES RÁPIDAS (YA TENÍAS) ============
          const AdminQuickActions(),
          const SizedBox(height: 20),

          // ============ CALENDARIO (estilo agenda) ============
          _buildCalendar(provider),
          const SizedBox(height: 16),

          // ============ CITAS DEL DÍA (estilo agenda) ============
          _buildAppointmentsList(provider),
          const SizedBox(height: 16),

          // ============ GRÁFICO DE CITAS (YA TENÍAS) ============
          if (provider.appointments.isNotEmpty)
            AdminAppointmentsChart(appointments: provider.appointments),
          const SizedBox(height: 16),

          // ============ TARJETA DE MÉTRICAS (YA TENÍAS) ============
          if (provider.metrics != null)
            AdminStatsCard(metrics: provider.metrics!),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ============ STAT CARD (estilo agenda) ============
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ============ CALENDARIO ============
  Widget _buildCalendar(TenantAdminProvider provider) {
    final now = DateTime.now();
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hoy',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
              Text(
                DateFormat('dd MMMM yyyy', 'es').format(now).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Días de la semana
          Row(
            children: const [
              _DayLabel('L'),
              _DayLabel('M'),
              _DayLabel('M'),
              _DayLabel('J'),
              _DayLabel('V'),
              _DayLabel('S'),
              _DayLabel('D'),
            ],
          ),
          const SizedBox(height: 6),

          // Días del mes
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.3,
            ),
            itemCount: lastDayOfMonth.day,
            itemBuilder: (context, index) {
              final day = index + 1;
              final date = DateTime(now.year, now.month, day);
              final isToday = date.day == now.day &&
                  date.month == now.month &&
                  date.year == now.year;
              final hasAppointment = provider.appointments.any((a) =>
              a.appointmentDate.day == day &&
                  a.appointmentDate.month == now.month);

              return _DayCell(
                day: day,
                isToday: isToday,
                hasAppointment: hasAppointment,
              );
            },
          ),

          // Leyenda
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Día con citas',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
              Text(
                '${provider.appointments.length} citas',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============ LISTA DE CITAS DEL DÍA ============
  Widget _buildAppointmentsList(TenantAdminProvider provider) {
    final todayAppointments = provider.appointments.where((a) =>
    a.appointmentDate.day == DateTime.now().day &&
        a.appointmentDate.month == DateTime.now().month &&
        a.appointmentDate.year == DateTime.now().year).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('dd MMMM yyyy', 'es').format(DateTime.now()),
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          if (todayAppointments.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Icon(
                      Icons.event_busy_outlined,
                      color: Colors.white.withOpacity(0.2),
                      size: 32,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'No hay reservas para hoy',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...todayAppointments.map((appointment) => _buildAppointmentItem(appointment)),
        ],
      ),
    );
  }

  Widget _buildAppointmentItem(dynamic appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.clientName ?? 'Cliente',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${appointment.serviceName ?? 'Servicio'} • ${appointment.barberName ?? 'Barbero'}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            DateFormat('HH:mm').format(appointment.appointmentDate),
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ============ BOTTOM NAVIGATION BAR ============
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0A0A0A),
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.white.withOpacity(0.4),
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        _navigateToSection(index);
      },
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'Agenda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'Clientes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money_outlined),
          label: 'Caja',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.build_outlined),
          label: 'Herramientas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Config',
        ),
      ],
    );
  }

  void _navigateToSection(int index) {
    switch (index) {
      case 0:
      // Ya estamos en Agenda
        break;
      case 1:
        Navigator.pushNamed(context, '/tenant-admin/barbers');
        break;
      case 2:
      // TODO: Navegar a Caja
        break;
      case 3:
        Navigator.pushNamed(context, '/tenant-admin/services');
        break;
      case 4:
      // TODO: Navegar a Configuración
        break;
    }
  }

  // ============ MÉTODOS AUXILIARES ============
  String _formatDate(DateTime date) {
    final days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return '${days[date.weekday - 1]} ${date.day} ${_monthName(date.month)} ${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
  }
}

// ============ WIDGETS AUXILIARES ============

class _DayLabel extends StatelessWidget {
  final String label;
  const _DayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool hasAppointment;

  const _DayCell({
    required this.day,
    this.isToday = false,
    this.hasAppointment = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isToday ? AppColors.primary : Colors.transparent,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            day.toString(),
            style: TextStyle(
              color: isToday ? Colors.black : Colors.white,
              fontSize: 11,
              fontWeight: isToday ? FontWeight.bold : FontWeight.w400,
            ),
          ),
          if (hasAppointment && !isToday)
            Positioned(
              bottom: 2,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}