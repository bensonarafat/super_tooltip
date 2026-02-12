import 'dart:math';

import 'package:flutter/material.dart';
import 'enums.dart';

class SuperUtils {
  static EdgeInsets getTooltipMargin({
    required CloseButtonType? closeButtonType,
    required double? closeButtonSize,
    required double arrowTipDistance,
    required double arrowLength,
    required TooltipDirection preferredDirection,
    required bool showCloseButton,
  }) {
    final top = !showCloseButton
        ? 0.0
        : (closeButtonType == CloseButtonType.outside)
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
    required CloseButtonType? closeButtonType,
    required double? closeButtonSize,
    required bool showCloseButton,
  }) {
    final top = !showCloseButton
        ? 0.0
        : (closeButtonType == CloseButtonType.inside)
            ? closeButtonSize!
            : 0.0;
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
        // Calculate available width based on margin
        maxWidth = maxWidth - right - target.dx;
        // Don't force minWidth to be equal to maxWidth (allows shrinking)
      } else {
        maxWidth = (maxWidth - target.dx) - margin;
      }
    } else {
      if (left != null) {
        // Calculate available width based on margin
        maxWidth = target.dx - left;
      } else {
        maxWidth = min(maxWidth, target.dx) - margin;
      }
    }

    // Robustness check to prevent negative constraints
    if (maxWidth < 0) maxWidth = 0;
    if (minWidth > maxWidth) minWidth = maxWidth;

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
        maxHeight = target.dy - top;
      } else {
        maxHeight = min(maxHeight, target.dy) - margin;
      }
    } else {
      if (bottom != null) {
        maxHeight = maxHeight - bottom - target.dy;
      } else {
        maxHeight = min(maxHeight, maxHeight - target.dy) - margin;
      }
    }

    // Robustness check
    if (maxHeight < 0) maxHeight = 0;
    if (minHeight > maxHeight) minHeight = maxHeight;

    return constraints.copyWith(
      minHeight: minHeight,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
    );
  }

  /// This method determines the most suitable direction for displaying
  /// the tooltip relative to the target widget.
  static TooltipDirection resolve({
    required RenderBox overlay,
    required Offset target,
    required Size estimatedTooltipSize,
    required double margin,
  }) {
    final screen = overlay.size;

    final spaceAbove = target.dy - margin;
    final spaceBelow = screen.height - target.dy - margin;
    final spaceLeft = target.dx - margin;
    final spaceRight = screen.width - target.dx - margin;

    final requiredHeight = estimatedTooltipSize.height;
    final requiredWidth = estimatedTooltipSize.width;

    if (spaceBelow >= requiredHeight) return TooltipDirection.down;
    if (spaceAbove >= requiredHeight) return TooltipDirection.up;

    if (spaceRight >= requiredWidth) return TooltipDirection.right;
    if (spaceLeft >= requiredWidth) return TooltipDirection.left;

    final candidates = <TooltipDirection, double>{
      TooltipDirection.down: spaceBelow,
      TooltipDirection.up: spaceAbove,
      TooltipDirection.right: spaceRight,
      TooltipDirection.left: spaceLeft,
    };

    return candidates.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}
