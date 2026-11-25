import 'package:flutter/material.dart';
import 'login_screen.dart';

const String kBrandSymbolPath = 'assets/images/holowear-symbol-color-512px.png';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _emblemFade;
  late final Animation<double> _emblemScale;
  late final Animation<double> _scanLineProgress;
  late final Animation<double> _wordmarkFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1750),
    );

    _emblemFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );

    _emblemScale = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    // Barrido óptico sutil sobre el emblema (referencia al escaneo AR)
    _scanLineProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.80, curve: Curves.easeInOut),
    );

    _wordmarkFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.90, curve: Curves.easeOut),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 250), () {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 650),
              pageBuilder: (_, __, ___) => const LoginScreen(),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  ),
                  child: child,
                );
              },
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EE),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo conectado mediante Hero hacia la pantalla de Login
            FadeTransition(
              opacity: _emblemFade,
              child: ScaleTransition(
                scale: _emblemScale,
                child: Hero(
                  tag: 'holowear-brand-emblem',
                  child: _BrandEmblem(scanAnimation: _scanLineProgress, size: 92),
                ),
              ),
            ),

            const SizedBox(height: 20),

            FadeTransition(
              opacity: _wordmarkFade,
              child: const Text(
                'HoloWear',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                  color: Color(0xFF1F1B16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Emblema con esquinas de visor AR y barrido óptico opcional
class _BrandEmblem extends StatelessWidget {
  final Animation<double>? scanAnimation;
  final double size;

  const _BrandEmblem({
    this.scanAnimation,
    this.size = 76,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 16,
      height: size + 16,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Esquinas sutiles de enfoque AR
          CustomPaint(
            size: Size(size + 16, size + 16),
            painter: _ViewfinderCornersPainter(
              color: const Color(0xFF1D4ED8).withAlpha(110),
            ),
          ),

          // Contenedor del símbolo
          Container(
            width: size,
            height: size,
            padding: EdgeInsets.all(size * 0.20),
            decoration: BoxDecoration(
              color: const Color(0xFFFDFBF7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0x141F1B16)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x101F1B16),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    kBrandSymbolPath,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(
                        Icons.view_in_ar_rounded,
                        color: Color(0xFF1D4ED8),
                        size: 32,
                      ),
                    ),
                  ),
                  if (scanAnimation != null)
                    AnimatedBuilder(
                      animation: scanAnimation!,
                      builder: (context, _) {
                        final v = scanAnimation!.value;
                        if (v <= 0.0 || v >= 1.0) {
                          return const SizedBox.shrink();
                        }
                        return Align(
                          alignment: Alignment(0, (v * 2) - 1),
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1D4ED8).withAlpha(180),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1D4ED8).withAlpha(90),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewfinderCornersPainter extends CustomPainter {
  final Color color;

  _ViewfinderCornersPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const len = 10.0;
    const r = 6.0;
    final w = size.width;
    final h = size.height;

    // Superior izquierda
    canvas.drawPath(
      Path()
        ..moveTo(0, len)
        ..lineTo(0, r)
        ..quadraticBezierTo(0, 0, r, 0)
        ..lineTo(len, 0),
      paint,
    );
    // Superior derecha
    canvas.drawPath(
      Path()
        ..moveTo(w - len, 0)
        ..lineTo(w - r, 0)
        ..quadraticBezierTo(w, 0, w, r)
        ..lineTo(w, len),
      paint,
    );
    // Inferior izquierda
    canvas.drawPath(
      Path()
        ..moveTo(0, h - len)
        ..lineTo(0, h - r)
        ..quadraticBezierTo(0, h, r, h)
        ..lineTo(len, h),
      paint,
    );
    // Inferior derecha
    canvas.drawPath(
      Path()
        ..moveTo(w - len, h)
        ..lineTo(w - r, h)
        ..quadraticBezierTo(w, h, w, h - r)
        ..lineTo(w, h - len),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}