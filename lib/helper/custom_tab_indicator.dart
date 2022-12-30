import 'package:flutter/material.dart';

class CustomTabIndicator extends Decoration {
  final double radius;
  final Color color;
  final double indicatorHeight;
  final bool isCircle;
  const CustomTabIndicator(
      {this.radius = 8,
      this.indicatorHeight = 4,
      required this.color,
      required this.isCircle});

  @override
  _CustomPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(
        this, onChanged, radius, color, indicatorHeight, isCircle);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;
  final double radius;
  final Color color;
  final double indicatorHeight;
  final bool isCircle;
  _CustomPainter(this.decoration, VoidCallback? onChanged, this.radius,
      this.color, this.indicatorHeight, this.isCircle)
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    final Paint paint = Paint();
    double xAxisPos = offset.dx + configuration.size!.width / 2 -10;
    double yAxisPos =
        offset.dy + configuration.size!.height - indicatorHeight / 2;
    paint.color = color;

    if (isCircle) {
      final Offset circleOffset =
          Offset(configuration.size!.width/2, configuration.size!.height-20);
      canvas.drawCircle(offset + circleOffset, radius, paint);
    } else {
      RRect fullRect = RRect.fromRectAndCorners(
        Rect.fromCenter(
          center: Offset(xAxisPos, yAxisPos),
          width: configuration.size!.width,
          height: indicatorHeight,
        ),
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      );
      canvas.drawRRect(fullRect, paint);
    }
  }
}
