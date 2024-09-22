import 'dart:math';

import 'package:flutter/material.dart';

import 'enums.dart';

class BubbleShape extends ShapeBorder {
  const BubbleShape({
    required this.preferredDirection,
    required this.target,
    required this.borderRadius,
    required this.arrowTipRadius,
    required this.arrowBaseWidth,
    required this.arrowTipDistance,
    required this.borderColor,
    required this.borderWidth,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.bubbleDimensions,
  });

  final Offset target;
  final double arrowBaseWidth;
  final double arrowTipDistance;
  final double borderRadius;
  final double arrowTipRadius;
  final Color borderColor;
  final double borderWidth;
  final double? left, top, right, bottom;
  final TooltipDirection preferredDirection;
  final EdgeInsetsGeometry bubbleDimensions;

  @override
  EdgeInsetsGeometry get dimensions => bubbleDimensions;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path()
    ..fillType = PathFillType.evenOdd
    ..addPath(getOuterPath(rect), Offset.zero);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    //
    late double topLeftRadius,
        topRightRadius,
        bottomLeftRadius,
        bottomRightRadius;

    Path getLeftTopPath(Rect rect) => Path()
      ..moveTo(rect.left, rect.bottom - bottomLeftRadius)
      ..lineTo(rect.left, rect.top + topLeftRadius)
      ..arcToPoint(
        Offset(rect.left + topLeftRadius, rect.top),
        radius: Radius.circular(topLeftRadius),
      )
      ..lineTo(rect.right - topRightRadius, rect.top)
      ..arcToPoint(
        Offset(rect.right, rect.top + topRightRadius),
        radius: Radius.circular(topRightRadius),
        clockwise: true,
      );

    Path getBottomRightPath(Rect rect) => Path()
      ..moveTo(rect.left + bottomLeftRadius, rect.bottom)
      ..lineTo(rect.right - bottomRightRadius, rect.bottom)
      ..arcToPoint(
        Offset(rect.right, rect.bottom - bottomRightRadius),
        radius: Radius.circular(bottomRightRadius),
        clockwise: false,
      )
      ..lineTo(rect.right, rect.top + topRightRadius)
      ..arcToPoint(
        Offset(rect.right - topRightRadius, rect.top),
        radius: Radius.circular(topRightRadius),
        clockwise: false,
      );

    topLeftRadius = (left == 0 || top == 0) ? 0.0 : borderRadius;
    topRightRadius = (right == 0 || top == 0) ? 0.0 : borderRadius;
    bottomLeftRadius = (left == 0 || bottom == 0) ? 0.0 : borderRadius;
    bottomRightRadius = (right == 0 || bottom == 0) ? 0.0 : borderRadius;

    switch (preferredDirection) {
      case TooltipDirection.down:
        return getBottomRightPath(rect)
          ..lineTo(
            min(
              max(
                target.dx + arrowBaseWidth / 2,
                rect.left + borderRadius + arrowBaseWidth,
              ),
              rect.right - topRightRadius,
            ),
            rect.top,
          )
          // up to arrow tip where the curve starts
          ..lineTo(
              target.dx + arrowTipRadius / sqrt(2), //sin and cos 45 = 1/root(2)
              target.dy +
                  arrowTipDistance -
                  (arrowTipRadius - arrowTipRadius / sqrt(2)))

          //arc for the tip
          ..arcToPoint(
              Offset(
                  target.dx - arrowTipRadius / sqrt(2),
                  target.dy +
                      arrowTipDistance -
                      (arrowTipRadius - arrowTipRadius / sqrt(2))),
              radius: Radius.circular(arrowTipRadius),
              clockwise: false)

          //  down /
          ..lineTo(
            max(
              min(
                target.dx - arrowBaseWidth / 2,
                rect.right - topLeftRadius - arrowBaseWidth,
              ),
              rect.left + topLeftRadius,
            ),
            rect.top,
          )
          ..lineTo(rect.left + topLeftRadius, rect.top)
          ..arcToPoint(
            Offset(rect.left, rect.top + topLeftRadius),
            radius: Radius.circular(topLeftRadius),
            clockwise: false,
          )
          ..lineTo(rect.left, rect.bottom - bottomLeftRadius)
          ..arcToPoint(
            Offset(rect.left + bottomLeftRadius, rect.bottom),
            radius: Radius.circular(bottomLeftRadius),
            clockwise: false,
          );

      case TooltipDirection.up:
        return getLeftTopPath(rect)
          ..lineTo(rect.right, rect.bottom - bottomRightRadius)
          ..arcToPoint(Offset(rect.right - bottomRightRadius, rect.bottom),
              radius: Radius.circular(bottomRightRadius), clockwise: true)
          ..lineTo(
              min(
                  max(target.dx + arrowBaseWidth / 2,
                      rect.left + bottomLeftRadius + arrowBaseWidth),
                  rect.right - bottomRightRadius),
              rect.bottom)

          // down to arrow tip curvature start\
          ..lineTo(
              target.dx + arrowTipRadius / sqrt(2), //sin and cos 45 = 1/root(2)
              target.dy -
                  arrowTipDistance +
                  (arrowTipRadius - arrowTipRadius / sqrt(2)))

          //arc for the tip
          ..arcToPoint(
              Offset(
                  target.dx - arrowTipRadius / sqrt(2),
                  target.dy -
                      arrowTipDistance +
                      (arrowTipRadius - arrowTipRadius / sqrt(2))),
              radius: Radius.circular(arrowTipRadius))

          //  up /
          ..lineTo(
              max(
                  min(target.dx - arrowBaseWidth / 2,
                      rect.right - bottomRightRadius - arrowBaseWidth),
                  rect.left + bottomLeftRadius),
              rect.bottom)
          ..lineTo(rect.left + bottomLeftRadius, rect.bottom)
          ..arcToPoint(Offset(rect.left, rect.bottom - bottomLeftRadius),
              radius: Radius.circular(bottomLeftRadius), clockwise: true)
          ..lineTo(rect.left, rect.top + topLeftRadius)
          ..arcToPoint(Offset(rect.left + topLeftRadius, rect.top),
              radius: Radius.circular(topLeftRadius), clockwise: true);

      case TooltipDirection.left:
        return getLeftTopPath(rect)
          ..lineTo(
              rect.right,
              max(
                  min(target.dy - arrowBaseWidth / 2,
                      rect.bottom - bottomRightRadius - arrowBaseWidth),
                  rect.top + topRightRadius))

          // right to arrow tip to the start point of the arc \
          ..lineTo(
              target.dx -
                  arrowTipDistance +
                  (arrowTipRadius - arrowTipRadius / sqrt(2)),
              target.dy - arrowTipRadius / sqrt(2))

          //arc for the tip
          ..arcToPoint(
            Offset(
              target.dx -
                  arrowTipDistance +
                  (arrowTipRadius - arrowTipRadius / sqrt(2)),
              target.dy + arrowTipRadius / sqrt(2),
            ),
            radius: Radius.circular(arrowTipRadius),
          )

          //  left /
          ..lineTo(
              rect.right,
              min(target.dy + arrowBaseWidth / 2,
                  rect.bottom - bottomRightRadius))
          ..lineTo(rect.right, rect.bottom - borderRadius)
          ..arcToPoint(Offset(rect.right - bottomRightRadius, rect.bottom),
              radius: Radius.circular(bottomRightRadius), clockwise: true)
          ..lineTo(rect.left + bottomLeftRadius, rect.bottom)
          ..arcToPoint(Offset(rect.left, rect.bottom - bottomLeftRadius),
              radius: Radius.circular(bottomLeftRadius), clockwise: true);

      case TooltipDirection.right:
        return getBottomRightPath(rect)
          ..lineTo(rect.left + topLeftRadius, rect.top)
          ..arcToPoint(Offset(rect.left, rect.top + topLeftRadius),
              radius: Radius.circular(topLeftRadius), clockwise: false)
          ..lineTo(
              rect.left,
              max(
                  min(target.dy - arrowBaseWidth / 2,
                      rect.bottom - bottomLeftRadius - arrowBaseWidth),
                  rect.top + topLeftRadius))

          //left to arrow tip till curve start/

          ..lineTo(
              target.dx +
                  arrowTipDistance -
                  (arrowTipRadius - arrowTipRadius / sqrt(2)),
              target.dy - arrowTipRadius / sqrt(2))

          //arc for the tip
          ..arcToPoint(
              Offset(
                  target.dx +
                      arrowTipDistance -
                      (arrowTipRadius - arrowTipRadius / sqrt(2)),
                  target.dy + arrowTipRadius / sqrt(2)),
              radius: Radius.circular(arrowTipRadius),
              clockwise: false)

          //  right \
          ..lineTo(
              rect.left,
              min(target.dy + arrowBaseWidth / 2,
                  rect.bottom - bottomLeftRadius))
          ..lineTo(rect.left, rect.bottom - bottomLeftRadius)
          ..arcToPoint(Offset(rect.left + bottomLeftRadius, rect.bottom),
              radius: Radius.circular(bottomLeftRadius), clockwise: false);

      default:
        throw ArgumentError(preferredDirection);
    }
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    var paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawPath(getOuterPath(rect), paint);

    paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    if (right == 0.0) {
      if (top == 0.0 && bottom == 0.0) {
        canvas.drawPath(
          Path()
            ..moveTo(rect.right, rect.top)
            ..lineTo(rect.right, rect.bottom),
          paint,
        );
      } else {
        canvas.drawPath(
          Path()
            ..moveTo(rect.right, rect.top + borderWidth / 2)
            ..lineTo(rect.right, rect.bottom - borderWidth / 2),
          paint,
        );
      }
    }
    if (left == 0.0) {
      if (top == 0.0 && bottom == 0.0) {
        canvas.drawPath(
          Path()
            ..moveTo(rect.left, rect.top)
            ..lineTo(rect.left, rect.bottom),
          paint,
        );
      } else {
        canvas.drawPath(
          Path()
            ..moveTo(rect.left, rect.top + borderWidth / 2)
            ..lineTo(rect.left, rect.bottom - borderWidth / 2),
          paint,
        );
      }
    }
    if (top == 0.0) {
      if (left == 0.0 && right == 0.0) {
        canvas.drawPath(
          Path()
            ..moveTo(rect.right, rect.top)
            ..lineTo(rect.left, rect.top),
          paint,
        );
      } else {
        canvas.drawPath(
          Path()
            ..moveTo(rect.right - borderWidth / 2, rect.top)
            ..lineTo(rect.left + borderWidth / 2, rect.top),
          paint,
        );
      }
    }
    if (bottom == 0.0) {
      if (left == 0.0 && right == 0.0) {
        canvas.drawPath(
          Path()
            ..moveTo(rect.right, rect.bottom)
            ..lineTo(rect.left, rect.bottom),
          paint,
        );
      } else {
        canvas.drawPath(
          Path()
            ..moveTo(rect.right - borderWidth / 2, rect.bottom)
            ..lineTo(rect.left + borderWidth / 2, rect.bottom),
          paint,
        );
      }
    }
  }

  @override
  ShapeBorder scale(double t) {
    return BubbleShape(
      preferredDirection: preferredDirection,
      target: target,
      borderRadius: borderRadius,
      arrowTipRadius: arrowTipRadius,
      arrowBaseWidth: arrowBaseWidth,
      arrowTipDistance: arrowTipDistance,
      borderColor: borderColor,
      borderWidth: borderWidth,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      bubbleDimensions: bubbleDimensions,
    );
  }
}
