// lib/screens/auth/login_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/auth_service.dart';
import '../../presentation/screens/tenant_admin/admin_home_screen.dart';
import '../../presentation/screens/client/home_screen.dart';
import '../../presentation/screens/super_admin/super_admin_home_screen.dart'; // ✅ AGREGADO
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  double _dragX = 0;
  double _dragY = 0;

  void _handleSubmit() async {
    if (_emailController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa tu correo y contraseña'),
          backgroundColor: Color(0xFFC9A84C),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      print('📱 Iniciando proceso de login...');

      final response = await _authService.login(
        _emailController.text.trim(),
        _passController.text.trim(),
      );

      if (response != null) {
        print('✅ Login exitoso: ${response.name}');
        print('🔑 Rol del usuario: ${response.role}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Bienvenido!'),
              backgroundColor: Color(0xFFC9A84C),
            ),
          );

          // ✅ REDIRECCIÓN POR ROL
          if (response.role == 'TENANT_ADMIN') {
            print('➡️ Redirigiendo a TENANT_ADMIN');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
            );
          } else if (response.role == 'SUPER_ADMIN') {
            print('➡️ Redirigiendo a SUPER_ADMIN');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SuperAdminHomeScreen()),
            );
          } else {
            print('➡️ Redirigiendo a CLIENT');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        }
      } else {
        print('❌ Login fallido');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Credenciales incorrectas'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error en login: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de conexión: Verifica que el servidor esté corriendo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGold = Color(0xFFC9A84C);
    const secondaryGold = Color(0xFFE8D5A3);
    const darkGold = Color(0xFF8B7A3C);
    const deepBlack = Color(0xFF0A0A0A);
    const darkGray = Color(0xFF1A1A1A);

    return Scaffold(
      backgroundColor: deepBlack,
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _dragX += details.delta.dy * -0.001;
            _dragY += details.delta.dx * 0.001;
          });
        },
        onPanEnd: (_) {
          setState(() {
            _dragX = 0;
            _dragY = 0;
          });
        },
        child: Stack(
          children: [
            // Fondo
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [darkGray, deepBlack],
                ),
              ),
            ),

            // Anillos decorativos
            ...List.generate(3, (index) {
              final size = 200 + (index * 150);
              final opacity = 0.03 - (index * 0.008);
              return Positioned(
                top: -50 + (index * 80),
                right: -50 + (index * 60),
                child: Container(
                  width: size.toDouble(),
                  height: size.toDouble(),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryGold.withOpacity(opacity),
                      width: 1.5,
                    ),
                  ),
                ),
              );
            }),

            // Esfera Dorada principal
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              top: -100 + (_dragX * 50),
              right: -80 + (_dragY * 50),
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      primaryGold.withOpacity(0.15),
                      primaryGold.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.2, 1.2),
                duration: const Duration(seconds: 5),
              ),
            ),

            // Segunda esfera dorada
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              bottom: -80 - (_dragX * 50),
              left: -60 - (_dragY * 50),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      secondaryGold.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(
                begin: const Offset(1.1, 1.1),
                end: const Offset(0.8, 0.8),
                duration: const Duration(seconds: 4),
              ),
            ),

            // Líneas de corte decorativas
            ...List.generate(8, (index) {
              final angle = (index * 45) * 3.14159 / 180;
              final x = 50 * (index % 2 == 0 ? 1 : -1);
              final y = 50 * (index % 2 == 0 ? -1 : 1);
              return Positioned(
                top: MediaQuery.of(context).size.height / 2 + y,
                left: MediaQuery.of(context).size.width / 2 + x,
                child: Container(
                  width: 2,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryGold.withOpacity(0.15),
                        primaryGold.withOpacity(0.02),
                      ],
                    ),
                  ),
                  transform: Matrix4.rotationZ(angle),
                ),
              );
            }),

            // Tarjeta Glassmorphism
            Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
                child: AnimatedRotation(
                  turns: _dragY * 0.04,
                  duration: const Duration(milliseconds: 200),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(_dragX)
                      ..rotateY(_dragY),
                    transformAlignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: primaryGold.withOpacity(0.3),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryGold.withOpacity(0.1),
                                blurRadius: 60,
                                spreadRadius: 10,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.6),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Logo
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [primaryGold, darkGold, primaryGold],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryGold.withOpacity(0.4),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                    BoxShadow(
                                      color: primaryGold.withOpacity(0.2),
                                      blurRadius: 60,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.content_cut_rounded,
                                  size: 42,
                                  color: Colors.black,
                                ),
                              )
                                  .animate()
                                  .scale(
                                begin: const Offset(0.5, 0.5),
                                end: const Offset(1, 1),
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.elasticOut,
                              )
                                  .shimmer(
                                delay: const Duration(seconds: 2),
                                duration: const Duration(seconds: 2),
                                color: secondaryGold,
                              ),

                              const SizedBox(height: 24),

                              const Text(
                                'BARBERÍA\nPREMIUM',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 2.5,
                                  height: 1.2,
                                ),
                              )
                                  .animate()
                                  .fade()
                                  .slideY(begin: 0.3, end: 0),

                              const SizedBox(height: 8),

                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    Color(0xFFC9A84C),
                                    Color(0xFFE8D5A3),
                                    Color(0xFFC9A84C),
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  'Inicia sesión para gestionar tu negocio',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Campo Email
                              _build3DTextField(
                                controller: _emailController,
                                label: 'Correo Electrónico',
                                icon: Icons.email_outlined,
                                accentColor: primaryGold,
                              ).animate().fade(delay: const Duration(milliseconds: 100)).slideX(begin: -0.2, end: 0),

                              const SizedBox(height: 16),

                              // Campo Password
                              _build3DTextField(
                                controller: _passController,
                                label: 'Contraseña',
                                icon: Icons.lock_outline,
                                isPassword: true,
                                accentColor: primaryGold,
                              ).animate().fade(delay: const Duration(milliseconds: 200)).slideX(begin: 0.2, end: 0),

                              const SizedBox(height: 12),

                              // Olvidé contraseña
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                  child: Text(
                                    '¿Olvidaste tu contraseña?',
                                    style: TextStyle(
                                      color: primaryGold.withOpacity(0.7),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Botón INGRESAR
                              _isLoading
                                  ? const CircularProgressIndicator(
                                color: Color(0xFFC9A84C),
                                strokeWidth: 3,
                              )
                                  : Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [primaryGold, darkGold, primaryGold],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryGold.withOpacity(0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                    BoxShadow(
                                      color: primaryGold.withOpacity(0.2),
                                      blurRadius: 40,
                                      offset: const Offset(0, 15),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _handleSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'INGRESAR',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.black.withOpacity(0.8),
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                                  .animate()
                                  .scale(delay: const Duration(milliseconds: 300))
                                  .shimmer(
                                delay: const Duration(seconds: 1),
                                duration: const Duration(seconds: 2),
                                color: secondaryGold,
                              ),

                              const SizedBox(height: 24),

                              // Separador
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: primaryGold.withOpacity(0.2),
                                      thickness: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      'O continúa con',
                                      style: TextStyle(
                                        color: primaryGold.withOpacity(0.4),
                                        fontSize: 11,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: primaryGold.withOpacity(0.2),
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Botones sociales
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSocialButton(
                                      icon: Icons.g_mobiledata,
                                      label: 'Google',
                                      color: primaryGold,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildSocialButton(
                                      icon: Icons.facebook_rounded,
                                      label: 'Facebook',
                                      color: primaryGold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Redirección a Registro
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                                  );
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: '¿No tienes cuenta? ',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Regístrate',
                                        style: TextStyle(
                                          color: primaryGold,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: Icon(
                                          Icons.arrow_forward_rounded,
                                          color: primaryGold,
                                          size: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _build3DTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color accentColor,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accentColor.withOpacity(0.15),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: accentColor.withOpacity(0.5),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            icon,
            color: accentColor,
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: TextButton.icon(
        onPressed: () {},
        icon: Icon(
          icon,
          color: color,
          size: 22,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: TextButton.styleFrom(
          foregroundColor: Colors.transparent,
        ),
      ),
    );
  }
}