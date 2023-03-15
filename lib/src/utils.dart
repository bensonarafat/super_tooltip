import 'dart:math';

import 'package:flutter/material.dart';
import 'enums.dart';

class SuperUtils {
  static EdgeInsets getTooltipMargin({
    required ShowCloseButton? showCloseButton,
    required double? closeButtonSize,
    required double arrowTipDistance,
    required double arrowLength,
    required TooltipDirection preferredDirection,
  }) {
    final top = (showCloseButton == ShowCloseButton.outside)
        ? closeButtonSize! + 12
        : 0.0;

    switch (preferredDirection) {
      case TooltipDirection.down:
        return EdgeInsets.only(top: arrowTipDistance + arrowLength);

      case TooltipDirection.up:
        return EdgeInsets.only(
            bottom: arrowTipDistance + arrowLength, top: top);

      case TooltipDirection.left:
        return EdgeInsets.only(right: arrowTipDistance + arrowLength, top: top);

      case TooltipDirection.right:
        return EdgeInsets.only(left: arrowTipDistance + arrowLength, top: top);

      default:
        throw ArgumentError(preferredDirection);
    }
  }

  static EdgeInsets getTooltipPadding({
    required ShowCloseButton? showCloseButton,
    required double? closeButtonSize,
  }) {
    final top =
        (showCloseButton == ShowCloseButton.inside) ? closeButtonSize! : 0.0;
    return EdgeInsets.only(top: top);
  }

  static double leftMostXtoTarget({
    required double? left,
    required double? right,
    required double margin,
    required Size size,
    required Size childSize,
    required Offset target,
  }) {
    double leftMostXtoTarget;

    if (left != null) {
      leftMostXtoTarget = left;
    } else if (right != null) {
      // leftMostXtoTarget
      //               ________________________
      //               |                      |
      //               |   childSize.width    |
      //               ________________________
      //
      //    topLeft -> |  |                             |  | <- topRight
      //               |  |                             |  |
      //               |  |                             |  |
      //                ^                                ^
      //          margin                 margin
      leftMostXtoTarget = max(
        size.topLeft(Offset.zero).dx + margin,
        size.topRight(Offset.zero).dx - margin - childSize.width - right,
      );
    } else {
      leftMostXtoTarget = max(
        margin,
        min(
          target.dx - childSize.width / 2,
          size.topRight(Offset.zero).dx - margin - childSize.width,
        ),
      );
    }

    return leftMostXtoTarget;
  }

  static double topMostYtoTarget({
    required double? top,
    required double? bottom,
    required double margin,
    required Offset target,
    required Size size,
    required Size childSize,
  }) {
    double topmostYtoTarget;

    if (top != null) {
      topmostYtoTarget = top;
    } else if (bottom != null) {
      topmostYtoTarget = max(
        size.topLeft(Offset.zero).dy + margin,
        size.bottomRight(Offset.zero).dy - margin - childSize.height - bottom,
      );
    } else {
      topmostYtoTarget = max(
        margin,
        min(
          target.dy - childSize.height / 2,
          size.bottomRight(Offset.zero).dy - margin - childSize.height,
        ),
      );
    }

    return topmostYtoTarget;
  }

  static BoxConstraints horizontalConstraints({
    required BoxConstraints constraints,
    required double? top,
    required double? bottom,
    required double? right,
    required double? left,
    required double margin,
    required bool isRight,
    required Offset target,
  }) {
    var maxHeight = constraints.maxHeight;
    var minWidth = constraints.minWidth;
    var maxWidth = constraints.maxWidth;

    if (top != null && bottom != null) {
      maxHeight = maxHeight - (top + bottom);
    } else if ((top != null && bottom == null) ||
        (top == null && bottom != null)) {
      // make sure that the sum of top, bottom + _maxHeight isn't bigger than the screen Height.
      final sideDelta = (top ?? 0.0) + (bottom ?? 0.0) + margin;

      if (maxHeight > maxHeight - sideDelta) {
        maxHeight = maxHeight - sideDelta;
      }
    } else {
      if (maxHeight > maxHeight - 2 * margin) {
        maxHeight = maxHeight - 2 * margin;
      }
    }

    if (isRight) {
      if (right != null) {
        minWidth = maxWidth = maxWidth - right - target.dx;
      } else {
        maxWidth = min(maxWidth, maxWidth - target.dx) - margin;
      }
    } else {
      if (left != null) {
        minWidth = maxWidth = target.dx - left;
      } else {
        maxWidth = min(maxWidth, target.dx) - margin;
      }
    }

    return constraints.copyWith(
      maxHeight: maxHeight,
      minWidth: minWidth,
      maxWidth: maxWidth,
    );
  }

  static BoxConstraints verticalConstraints({
    required BoxConstraints constraints,
    required double margin,
    required bool isUp,
    required double? top,
    required double? left,
    required double? right,
    required double? bottom,
    required Offset target,
  }) {
    var minHeight = constraints.minHeight;
    var maxHeight = constraints.maxHeight;
    var maxWidth = constraints.maxWidth;

    if (left != null && right != null) {
      maxWidth = maxWidth - (left + right);
    } else if ((left != null && right == null) ||
        (left == null && right != null)) {
      // make sure that the sum of left, right + maxwidth isn't bigger than the screen width.
      final sideDelta = (left ?? 0.0) + (right ?? 0.0) + margin;

      if (maxWidth > maxWidth - sideDelta) {
        maxWidth = maxWidth - sideDelta;
      }
    } else {
      if (maxWidth > maxWidth - 2 * margin) {
        maxWidth = maxWidth - 2 * margin;
      }
    }

    if (isUp) {
      if (top != null) {
        minHeight = maxHeight = target.dy - top;
      } else {
        maxHeight = min(maxHeight, target.dy) - margin;
        // TD: clamp minheight
      }
    } else {
      if (bottom != null) {
        minHeight = maxHeight = maxHeight - bottom - target.dy;
      } else {
        maxHeight = min(maxHeight, maxHeight - target.dy) - margin;
        // TD: clamp minheight
      }
    }

    return constraints.copyWith(
      minHeight: minHeight,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
    );
  }
}
