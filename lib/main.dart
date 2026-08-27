// lib/main.dart

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/tenant_admin_provider.dart';
import 'presentation/providers/client_provider.dart';
import 'presentation/providers/super_admin_provider.dart';

// Importa tus pantallas
import 'presentation/screens/tenant_admin/admin_home_screen.dart';
import 'presentation/screens/tenant_admin/barber_management_screen.dart';
import 'presentation/screens/tenant_admin/service_management_screen.dart';
import 'presentation/screens/super_admin/super_admin_home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'presentation/screens/client/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(), lazy: false),
        ChangeNotifierProvider(create: (_) => TenantAdminProvider()),
        ChangeNotifierProvider(create: (_) => ClientProvider()),
        ChangeNotifierProvider(create: (_) => SuperAdminProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EstilosApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/tenant-admin': (context) => const AdminHomeScreen(),
        '/tenant-admin/barbers': (context) => const BarberManagementScreen(),
        '/tenant-admin/services': (context) => const ServiceManagementScreen(),
        '/super-admin': (context) => const SuperAdminHomeScreen(),
        '/client/home': (context) => const HomeScreen(),
      },
    );
  }
}