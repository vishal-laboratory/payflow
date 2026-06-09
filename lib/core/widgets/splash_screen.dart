import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({super.key, required this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );

    // Text animations - appears first with a bounce effect
    _textFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    // Logo animations - appears after text, centered
    _logoFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.75, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();

    // Navigate after animation completes
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => widget.nextScreen),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Text
            SlideTransition(
              position: _textSlideAnimation,
              child: FadeTransition(
                opacity: _textFadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'This app is dedicated to',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A73E8),
                      letterSpacing: 0.5,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Animated Logo
            ScaleTransition(
              scale: _logoScaleAnimation,
              child: FadeTransition(
                opacity: _logoFadeAnimation,
                child: Image.asset(
                  'assets/splash_logo.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlowLinePainter extends CustomPainter {
  final double progress;
  final int index;

  FlowLinePainter({required this.progress, required this.index});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF1A73E8).withOpacity(0.6 + (0.2 * (index / 2)))
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path();
    const steps = 20;
    const waveAmplitude = 4.0;
    const waveFrequency = 3;

    for (int i = 0; i <= steps; i++) {
      final x = (i / steps) * size.width;
      final baseY = size.height / 2;
      final offset = (i / steps + progress * 2) % 1.0;
      final y = baseY +
          waveAmplitude *
              Math.sin((offset * 2 * waveFrequency) * 3.14159);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(FlowLinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Helper for sin calculation
class Math {
  static double sin(double x) {
    return (x - (x * x * x / 6) + (x * x * x * x * x / 120)).toDouble();
  }
}
