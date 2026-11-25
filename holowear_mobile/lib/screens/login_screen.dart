import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _formController;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _isPressed = false;
  bool _emailFocused = false;
  bool _passwordFocused = false;
  bool _isEmailValid = false;

  static final RegExp _emailRegex =
      RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$');

  @override
  void initState() {
    super.initState();

    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 680),
    )..forward();

    _emailFocus.addListener(() {
      setState(() => _emailFocused = _emailFocus.hasFocus);
    });
    _passwordFocus.addListener(() {
      setState(() => _passwordFocused = _passwordFocus.hasFocus);
    });
    _emailController.addListener(() {
      final valid = _emailRegex.hasMatch(_emailController.text.trim());
      if (valid != _isEmailValid) {
        setState(() => _isEmailValid = valid);
      }
    });
  }

  @override
  void dispose() {
    _formController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Widget _fadeSlide({
    required double start,
    required double end,
    required Widget child,
  }) {
    final anim = CurvedAnimation(
      parent: _formController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(anim),
        child: child,
      ),
    );
  }

  void _onLoginTap() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Credenciales validadas para ${_emailController.text.trim()}',
        ),
        backgroundColor: const Color(0xFF0A1628),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _openForgotPasswordSheet() {
    final recoveryController = TextEditingController(
      text: _emailController.text.trim(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFFFFFF),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            16,
            24,
            MediaQuery.of(ctx).viewInsets.bottom + 28,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6E4F5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Recuperar contraseña',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                  color: Color(0xFF0A1628),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu acceso.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Color(0xFF526077),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: recoveryController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 15, color: Color(0xFF0A1628)),
                decoration: InputDecoration(
                  hintText: 'nombre@correo.com',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  prefixIcon: const Icon(
                    Icons.mail_outline_rounded,
                    size: 19,
                    color: Color(0xFF526077),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF6F9FC),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD6E4F5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF1D4ED8),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Si el correo está registrado, recibirás un enlace en breve.',
                        ),
                        backgroundColor: const Color(0xFF0A1628),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Enviar enlace',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToRegister() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 380),
        pageBuilder: (_, _, _) => const RegisterScreen(),
        transitionsBuilder: (_, animation, _, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Emblema Hero centrado
                    const Center(
                      child: Hero(
                        tag: 'holowear-brand-emblem',
                        child: BrandEmblem(size: 72),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // 2. Título, subtítulo y firma sutil de costura + AR
                    _fadeSlide(
                      start: 0.06,
                      end: 0.48,
                      child: Column(
                        children: [
                          const Text(
                            'Bienvenido a HoloWear',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              color: Color(0xFF0A1628),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Suprarreciclaje textil al alcance de tu mano.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: Color(0xFF526077),
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Firma visual sutil: puntada textil + punto AR
                          SizedBox(
                            width: 140,
                            height: 12,
                            child: CustomPaint(
                              painter: _StitchSignaturePainter(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // 3. Campo Correo electrónico
                    _fadeSlide(
                      start: 0.16,
                      end: 0.62,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Correo electrónico',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: _emailFocused
                                  ? const [
                                      BoxShadow(
                                        color: Color(0x181D4ED8),
                                        blurRadius: 12,
                                        offset: Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0A1628),
                              ),
                              validator: (value) {
                                final text = (value ?? '').trim();
                                if (text.isEmpty) {
                                  return 'Ingresa tu correo electrónico';
                                }
                                if (!_emailRegex.hasMatch(text)) {
                                  return 'Formato de correo no válido';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'nombre@correo.com',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                ),
                                prefixIcon: Icon(
                                  Icons.mail_outline_rounded,
                                  size: 19,
                                  color: _emailFocused
                                      ? const Color(0xFF1D4ED8)
                                      : const Color(0xFF7C8BA1),
                                ),
                                suffixIcon: _isEmailValid
                                    ? const Icon(
                                        Icons.check_circle_rounded,
                                        size: 19,
                                        color: Color(0xFF16A34A),
                                      )
                                    : null,
                                filled: true,
                                fillColor: _emailFocused
                                    ? const Color(0xFFFFFFFF)
                                    : const Color(0xFFF6F9FC),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 15,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD6E4F5),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF1D4ED8),
                                    width: 1.6,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDC2626),
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDC2626),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // 4. Campo Contraseña + enlace de recuperación debajo
                    _fadeSlide(
                      start: 0.26,
                      end: 0.74,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Contraseña',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: _passwordFocused
                                  ? const [
                                      BoxShadow(
                                        color: Color(0x181D4ED8),
                                        blurRadius: 12,
                                        offset: Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              obscureText: _obscurePassword,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0A1628),
                              ),
                              validator: (value) {
                                if ((value ?? '').isEmpty) {
                                  return 'Ingresa tu contraseña';
                                }
                                if ((value ?? '').length < 6) {
                                  return 'Mínimo 6 caracteres';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outline_rounded,
                                  size: 19,
                                  color: _passwordFocused
                                      ? const Color(0xFF1D4ED8)
                                      : const Color(0xFF7C8BA1),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 20,
                                    color: _passwordFocused
                                        ? const Color(0xFF1D4ED8)
                                        : const Color(0xFF7C8BA1),
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                                filled: true,
                                fillColor: _passwordFocused
                                    ? const Color(0xFFFFFFFF)
                                    : const Color(0xFFF6F9FC),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 15,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD6E4F5),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF1D4ED8),
                                    width: 1.6,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDC2626),
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDC2626),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _openForgotPasswordSheet,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 4,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1D4ED8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),

                    // 5. Botón principal con degradado HoloWear (Cobalto -> Cian)
                    _fadeSlide(
                      start: 0.36,
                      end: 0.86,
                      child: GestureDetector(
                        onTapDown: (_) => setState(() => _isPressed = true),
                        onTapUp: (_) {
                          setState(() => _isPressed = false);
                          _onLoginTap();
                        },
                        onTapCancel: () => setState(() => _isPressed = false),
                        child: AnimatedScale(
                          scale: _isPressed ? 0.98 : 1.0,
                          duration: const Duration(milliseconds: 110),
                          curve: Curves.easeOut,
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFF1D4ED8),
                                  Color(0xFF0284C7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x331D4ED8),
                                  blurRadius: 16,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 26),

                    // 6. Enlace centrado de Registro (Creador o Taller)
                    _fadeSlide(
                      start: 0.46,
                      end: 1.0,
                      child: Center(
                        child: TextButton(
                          onPressed: _navigateToRegister,
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF1D4ED8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                          ),
                          child: const Text.rich(
                            TextSpan(
                              text: '¿No tienes cuenta? ',
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Color(0xFF526077),
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Regístrate como Creador o Taller',
                                  style: TextStyle(
                                    color: Color(0xFF1D4ED8),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
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
    );
  }
}

/// Firma visual sutil: línea de puntada textil con nodo central AR
class _StitchSignaturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stitchPaint = Paint()
      ..color = const Color(0xFFCBD9EC)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    final midY = size.height / 2;
    final midX = size.width / 2;

    // Puntadas izquierda
    for (double x = 0; x < midX - 12; x += 8) {
      canvas.drawLine(Offset(x, midY), Offset(x + 4, midY), stitchPaint);
    }
    // Puntadas derecha
    for (double x = midX + 12; x < size.width; x += 8) {
      canvas.drawLine(Offset(x, midY), Offset(x + 4, midY), stitchPaint);
    }

    // Rombo óptico central
    final nodePaint = Paint()
      ..color = const Color(0xFF0EA5E9)
      ..style = PaintingStyle.fill;

    final diamond = Path()
      ..moveTo(midX, midY - 4)
      ..lineTo(midX + 4, midY)
      ..lineTo(midX, midY + 4)
      ..lineTo(midX - 4, midY)
      ..close();

    canvas.drawPath(diamond, nodePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}