import 'package:flutter/material.dart';
import '../config/theme.dart';

/// PhotoSwipe App Logo
/// Blue rounded square with mountain/photo icon
class AppLogo extends StatelessWidget {
  final double size;
  final bool showShadow;

  const AppLogo({
    super.key,
    this.size = 80,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.accentPrimary,
        borderRadius: BorderRadius.circular(size * 0.2),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppTheme.accentPrimary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background frame effect
          Positioned(
            left: size * 0.15,
            top: size * 0.15,
            child: Container(
              width: size * 0.5,
              height: size * 0.4,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: AppTheme.backgroundMain.withOpacity(0.5),
                    width: 3,
                  ),
                  top: BorderSide(
                    color: AppTheme.backgroundMain.withOpacity(0.5),
                    width: 3,
                  ),
                ),
              ),
            ),
          ),
          // Mountain icon
          CustomPaint(
            size: Size(size * 0.6, size * 0.4),
            painter: _MountainPainter(),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the mountain icon
class _MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.backgroundMain
      ..style = PaintingStyle.fill;

    // Draw two mountain peaks
    final path = Path();
    
    // Left smaller mountain
    path.moveTo(0, size.height);
    path.lineTo(size.width * 0.35, size.height * 0.4);
    path.lineTo(size.width * 0.5, size.height);
    
    // Right larger mountain
    path.moveTo(size.width * 0.3, size.height);
    path.lineTo(size.width * 0.65, size.height * 0.1);
    path.lineTo(size.width, size.height);
    
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
