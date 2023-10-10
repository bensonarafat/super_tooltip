import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'enums.dart';

class ShapeOverlay extends ShapeBorder {
  const ShapeOverlay({
    required this.clipRect,
    required this.clipAreaShape,
    required this.clipAreaCornerRadius,
    required this.barrierColor,
    required this.overlayDimensions,
  });

  final Rect? clipRect;
  final ClipAreaShape clipAreaShape;
  final double clipAreaCornerRadius;
  final Color? barrierColor;
  final EdgeInsetsGeometry overlayDimensions;

  @override
  EdgeInsetsGeometry get dimensions => overlayDimensions;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addOval(clipRect!);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    var outer = Path()..addRect(rect);

    if (clipRect == null) return outer;

    Path exclusion;

    if (clipAreaShape == ClipAreaShape.oval) {
      exclusion = Path()..addOval(clipRect!);
    } else {
      exclusion = Path()
        ..moveTo(clipRect!.left + clipAreaCornerRadius, clipRect!.top)
        ..lineTo(clipRect!.right - clipAreaCornerRadius, clipRect!.top)
        ..arcToPoint(
          Offset(clipRect!.right, clipRect!.top + clipAreaCornerRadius),
          radius: Radius.circular(clipAreaCornerRadius),
        )
        ..lineTo(clipRect!.right, clipRect!.bottom - clipAreaCornerRadius)
        ..arcToPoint(
          Offset(clipRect!.right - clipAreaCornerRadius, clipRect!.bottom),
          radius: Radius.circular(clipAreaCornerRadius),
        )
        ..lineTo(clipRect!.left + clipAreaCornerRadius, clipRect!.bottom)
        ..arcToPoint(
          Offset(clipRect!.left, clipRect!.bottom - clipAreaCornerRadius),
          radius: Radius.circular(clipAreaCornerRadius),
        )
        ..lineTo(clipRect!.left, clipRect!.top + clipAreaCornerRadius)
        ..arcToPoint(
          Offset(clipRect!.left + clipAreaCornerRadius, clipRect!.top),
          radius: Radius.circular(clipAreaCornerRadius),
        )
        ..close();
    }

    return Path.combine(ui.PathOperation.difference, outer, exclusion);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) =>
      canvas.drawPath(
        getOuterPath(rect),
        Paint()..color = barrierColor!,
      );

  @override
  ShapeBorder scale(double t) {
    return ShapeOverlay(
      clipRect: clipRect,
      clipAreaShape: clipAreaShape,
      clipAreaCornerRadius: clipAreaCornerRadius,
      barrierColor: barrierColor,
      overlayDimensions: overlayDimensions,
    );
  }
}
