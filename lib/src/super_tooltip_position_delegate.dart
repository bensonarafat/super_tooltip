import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'enums.dart';
import 'utils.dart';

class SuperToolTipPositionDelegate extends SingleChildLayoutDelegate {
  SuperToolTipPositionDelegate({
    required this.snapsFarAwayVertically,
    required this.snapsFarAwayHorizontally,
    required this.preferredDirection,
    required this.constraints,
    required this.margin,
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
    required this.target,
    // @required this.verticalOffset,
    required this.overlay,
  });
  // assert(verticalOffset != null);

  final bool snapsFarAwayVertically;
  final bool snapsFarAwayHorizontally;
  // TD: Make this EdgeInsets
  final double margin;
  final Offset target;
  // final double verticalOffset;
  final RenderBox? overlay;
  final BoxConstraints constraints;

  final TooltipDirection preferredDirection;
  final double? top, bottom, left, right;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // We use the INCOMING constraints (screen size) to calculate available space.
    // We do NOT start with this.constraints (user prefs) because that leads to negative math.
    var availableConstraints = constraints;

    switch (preferredDirection) {
      case TooltipDirection.up:
      case TooltipDirection.down:
        availableConstraints = SuperUtils.verticalConstraints(
          constraints: availableConstraints,
          margin: margin,
          bottom: bottom,
          isUp: preferredDirection == TooltipDirection.up,
          target: target,
          top: top,
          left: left,
          right: right,
        );
        break;
      case TooltipDirection.right:
      case TooltipDirection.left:
        availableConstraints = SuperUtils.horizontalConstraints(
          constraints: availableConstraints,
          margin: margin,
          bottom: bottom,
          isRight: preferredDirection == TooltipDirection.right,
          target: target,
          top: top,
          left: left,
          right: right,
        );
        break;
      case TooltipDirection.auto:
        availableConstraints = SuperUtils.verticalConstraints(
          constraints: availableConstraints,
          margin: margin,
          bottom: bottom,
          isUp: false,
          target: target,
          top: top,
          left: left,
          right: right,
        );
        break;
    }

    // Now we merge the calculated "Available Space" with the User's "Desired Constraints".
    // We take the smaller of the two max widths/heights to ensure we fit in both.
    // We respect the user's min sizes unless they exceed available space.

    double finalMaxWidth =
        math.min(availableConstraints.maxWidth, this.constraints.maxWidth);
    double finalMaxHeight =
        math.min(availableConstraints.maxHeight, this.constraints.maxHeight);

    // Ensure final max is not negative
    finalMaxWidth = math.max(0.0, finalMaxWidth);
    finalMaxHeight = math.max(0.0, finalMaxHeight);

    final validatedConstraints = BoxConstraints(
      minWidth: math.min(this.constraints.minWidth, finalMaxWidth),
      maxWidth: finalMaxWidth,
      minHeight: math.min(this.constraints.minHeight, finalMaxHeight),
      maxHeight: finalMaxHeight,
    );

    return validatedConstraints;
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    switch (preferredDirection) {
      case TooltipDirection.up:
      case TooltipDirection.down:
        final topOffset = preferredDirection == TooltipDirection.up
            ? top ?? target.dy - childSize.height
            : target.dy;

        return Offset(
          SuperUtils.leftMostXtoTarget(
            childSize: childSize,
            left: left,
            margin: margin,
            right: right,
            size: size,
            target: target,
          ),
          topOffset,
        );

      case TooltipDirection.right:
      case TooltipDirection.left:
        final leftOffset = preferredDirection == TooltipDirection.left
            ? left ?? target.dx - childSize.width
            : target.dx;
        return Offset(
          leftOffset,
          SuperUtils.topMostYtoTarget(
            bottom: bottom,
            childSize: childSize,
            margin: margin,
            size: size,
            target: target,
            top: top,
          ),
        );
      default:
        throw ArgumentError(preferredDirection);
    }
  }

  @override
  bool shouldRelayout(SuperToolTipPositionDelegate oldDelegate) => true;
}
