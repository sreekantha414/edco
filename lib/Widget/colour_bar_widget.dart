import 'package:flutter/material.dart';

class HueGradientTrackShape extends SliderTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    required RenderBox parentBox,
    Offset? secondaryOffset,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required Offset thumbCenter,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4;
    final Rect trackRect = Rect.fromLTWH(offset.dx, thumbCenter.dy - trackHeight / 2, parentBox.size.width, trackHeight);

    final Gradient gradient = LinearGradient(colors: List.generate(361, (h) => HSVColor.fromAHSV(1.0, h.toDouble(), 1.0, 1.0).toColor()));

    final Paint paint =
        Paint()
          ..shader = gradient.createShader(trackRect)
          ..style = PaintingStyle.fill;

    context.canvas.drawRRect(RRect.fromRectAndRadius(trackRect, Radius.circular(4)), paint);
  }

  @override
  Rect getPreferredRect({
    bool isDiscrete = false,
    bool isEnabled = false,
    Offset offset = Offset.zero,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
