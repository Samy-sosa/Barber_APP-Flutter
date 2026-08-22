import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/auth/register_request.dart';
import '../../services/auth_service.dart';
import '../barbershop/barbershop_list_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passController = TextEditingController();
  final _barbershopNameController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  String _selectedRole = 'CLIENT';
  double _dragX = 0;
  double _dragY = 0;

  void _onRegister() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passController.text.isEmpty ||
        (_selectedRole == 'TENANT_ADMIN' && _barbershopNameController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos requeridos'),
          backgroundColor: Color(0xFFC9A84C),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final request = RegisterRequest(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passController.text.trim(),
      role: _selectedRole,
      barbershopName: _selectedRole == 'TENANT_ADMIN' ? _barbershopNameController.text.trim() : null,
    );

    final result = await _authService.register(request);
    setState(() => _isLoading = false);

    if (mounted) {
      if (result != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BarbershopListScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al registrar cuenta'),
            backgroundColor: Color(0xFFC9A84C),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 Paleta de colores Premium - Barbería
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
            // 🎯 Fondo con gradiente radial
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    darkGray,
                    deepBlack,
                  ],
                ),
              ),
            ),

            // 🔵 Anillos decorativos dorados
            ...List.generate(3, (index) {
              final size = 200 + (index * 150);
              final opacity = 0.03 - (index * 0.008);
              return Positioned(
                bottom: -50 + (index * 80),
                left: -50 + (index * 60),
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

            // 🌟 Esfera Dorada principal
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

            // ✨ Segunda esfera dorada inferior
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

            // 💎 Tarjeta Glassmorphism Premium
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
                          padding: const EdgeInsets.all(28),
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
                              // 🪒 Logo/Ícono Premium
                              Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      primaryGold,
                                      darkGold,
                                      primaryGold,
                                    ],
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
                                child: Icon(
                                  _selectedRole == 'CLIENT'
                                      ? Icons.person_add_rounded
                                      : Icons.store_rounded,
                                  size: 36,
                                  color: Colors.black,
                                ),
                              )
                                  .animate()
                                  .scale(
                                begin: const Offset(0.5, 0.5),
                                end: const Offset(1, 1),
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.elasticOut,
                              ),

                              const SizedBox(height: 20),

                              // 📝 Título con estilo premium
                              const Text(
                                'CREAR\nCUENTA',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 2.5,
                                  height: 1.2,
                                ),
                              )
                                  .animate()
                                  .fade()
                                  .slideY(begin: 0.3, end: 0),

                              const SizedBox(height: 16),

                              // 🔘 Selector de Tipo de Usuario (Premium)
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: primaryGold.withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => setState(() => _selectedRole = 'CLIENT'),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 250),
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          decoration: BoxDecoration(
                                            color: _selectedRole == 'CLIENT'
                                                ? primaryGold
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.person_outline,
                                                  size: 16,
                                                  color: _selectedRole == 'CLIENT'
                                                      ? Colors.black
                                                      : Colors.white70,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'Cliente',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: _selectedRole == 'CLIENT'
                                                        ? Colors.black
                                                        : Colors.white70,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => setState(() => _selectedRole = 'TENANT_ADMIN'),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 250),
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          decoration: BoxDecoration(
                                            color: _selectedRole == 'TENANT_ADMIN'
                                                ? primaryGold
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.store_outlined,
                                                  size: 16,
                                                  color: _selectedRole == 'TENANT_ADMIN'
                                                      ? Colors.black
                                                      : Colors.white70,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'Barbería',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: _selectedRole == 'TENANT_ADMIN'
                                                        ? Colors.black
                                                        : Colors.white70,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // 🎁 Insignia Mes Gratis para Barberías
                              if (_selectedRole == 'TENANT_ADMIN')
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: primaryGold.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: primaryGold.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.bolt_rounded,
                                        color: primaryGold,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '¡1 Mes Gratis de Prueba Incluido!',
                                        style: TextStyle(
                                          color: primaryGold,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ).animate().fade().scale(),

                              const SizedBox(height: 18),

                              // 🏪 Campo Nombre Barbería (Solo si es Barbería)
                              if (_selectedRole == 'TENANT_ADMIN') ...[
                                _build3DTextField(
                                  controller: _barbershopNameController,
                                  label: 'Nombre de la Barbería',
                                  icon: Icons.storefront_outlined,
                                  accentColor: primaryGold,
                                ).animate().fade().slideY(begin: -0.2, end: 0),
                                const SizedBox(height: 12),
                              ],

                              // 👤 Campos Estándar
                              _build3DTextField(
                                controller: _nameController,
                                label: 'Nombre Completo',
                                icon: Icons.person_outline,
                                accentColor: primaryGold,
                              ),
                              const SizedBox(height: 12),

                              _build3DTextField(
                                controller: _emailController,
                                label: 'Correo Electrónico',
                                icon: Icons.email_outlined,
                                accentColor: primaryGold,
                              ),
                              const SizedBox(height: 12),

                              _build3DTextField(
                                controller: _phoneController,
                                label: 'Teléfono',
                                icon: Icons.phone_outlined,
                                accentColor: primaryGold,
                              ),
                              const SizedBox(height: 12),

                              _build3DTextField(
                                controller: _passController,
                                label: 'Contraseña',
                                icon: Icons.lock_outline,
                                isPassword: true,
                                accentColor: primaryGold,
                              ),

                              const SizedBox(height: 24),

                              // 🚀 Botón REGISTRAR Premium
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
                                    colors: [
                                      primaryGold,
                                      darkGold,
                                      primaryGold,
                                    ],
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
                                  onPressed: _onRegister,
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
                                      Text(
                                        _selectedRole == 'TENANT_ADMIN'
                                            ? 'REGISTRAR BARBERÍA'
                                            : 'REGISTRARME',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black,
                                          letterSpacing: 1.5,
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
                                  .scale(delay: const Duration(milliseconds: 200))
                                  .shimmer(
                                delay: const Duration(seconds: 1),
                                duration: const Duration(seconds: 2),
                                color: secondaryGold,
                              ),

                              // 🔵 Botón Google para Clientes
                              if (_selectedRole == 'CLIENT') ...[
                                const SizedBox(height: 14),
                                _buildSocialButton(
                                  icon: Icons.g_mobiledata,
                                  label: 'Continuar con Google',
                                  color: primaryGold,
                                ).animate().fade(),
                              ],

                              const SizedBox(height: 20),

                              // 📝 Redirección a Login
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: RichText(
                                  text: TextSpan(
                                    text: '¿Ya tienes cuenta? ',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Inicia Sesión',
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
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: TextButton.icon(
        onPressed: () {
          // TODO: Implementar autenticación social
        },
        icon: Icon(
          icon,
          color: color,
          size: 24,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
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