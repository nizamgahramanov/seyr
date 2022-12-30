import 'package:flutter/material.dart';
class UnderlinedTabIndicator extends Decoration {
  final Color color;
  double radius;
  UnderlinedTabIndicator({required this.color, required this.radius});
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinedPainter(color: color, radius: radius);
  }
}

class _UnderlinedPainter extends BoxPainter {
  final Color color;
  double radius;
  _UnderlinedPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint paint = Paint();
    paint.color = color;
    paint.isAntiAlias = true;
    final Offset p1 = Offset(
        configuration.size!.width,
        configuration.size!.height);

    final Offset p2 = Offset(
        configuration.size!.width+15,
        configuration.size!.height);

    canvas.drawLine(p1, p2, paint);
    // canvas.drawCircle(offset + circleOffset, radius, paint);

  }
}