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
      duration: const Duration(milliseconds: 1650),
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

    _scanLineProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.22, 0.82, curve: Curves.easeInOut),
    );

    _wordmarkFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.92, curve: Curves.easeOut),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 220), () {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 600),
              pageBuilder: (_, _, _) => const LoginScreen(),
              transitionsBuilder: (_, animation, _, child) {
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
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: _emblemFade,
              child: ScaleTransition(
                scale: _emblemScale,
                child: Hero(
                  tag: 'holowear-brand-emblem',
                  child: BrandEmblem(
                    scanAnimation: _scanLineProgress,
                    size: 92,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _wordmarkFade,
              child: const Column(
                children: [
                  Text(
                    'HoloWear',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                      color: Color(0xFF0A1628),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'SUPRARRECICLAJE · AR',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.2,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Emblema con esquinas de visor AR y resplandor óptico suave
class BrandEmblem extends StatelessWidget {
  final Animation<double>? scanAnimation;
  final double size;

  const BrandEmblem({
    super.key,
    this.scanAnimation,
    this.size = 72,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 18,
      height: size + 18,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Halo cian/azul muy suave detrás del emblema
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F0EA5E9),
                  blurRadius: 24,
                  spreadRadius: 2,
                  offset: Offset(0, 8),
                ),
              ],
            ),
          ),
          CustomPaint(
            size: Size(size + 18, size + 18),
            painter: _ViewfinderCornersPainter(
              color: const Color(0xFF0EA5E9).withAlpha(150),
            ),
          ),
          Container(
            width: size,
            height: size,
            padding: EdgeInsets.all(size * 0.18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFFFFF), Color(0xFFF4F8FD)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFD6E4F5)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    kBrandSymbolPath,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Center(
                      child: Icon(
                        Icons.view_in_ar_rounded,
                        color: Color(0xFF1D4ED8),
                        size: 30,
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
                            height: 2.5,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0x000EA5E9),
                                  Color(0xFF0EA5E9),
                                  Color(0xFF1D4ED8),
                                  Color(0x000EA5E9),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0EA5E9).withAlpha(110),
                                  blurRadius: 8,
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
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    const len = 10.0;
    const r = 6.0;
    final w = size.width;
    final h = size.height;

    canvas.drawPath(
      Path()
        ..moveTo(0, len)
        ..lineTo(0, r)
        ..quadraticBezierTo(0, 0, r, 0)
        ..lineTo(len, 0),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(w - len, 0)
        ..lineTo(w - r, 0)
        ..quadraticBezierTo(w, 0, w, r)
        ..lineTo(w, len),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, h - len)
        ..lineTo(0, h - r)
        ..quadraticBezierTo(0, h, r, h)
        ..lineTo(len, h),
      paint,
    );
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