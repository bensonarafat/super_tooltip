import 'package:flutter/material.dart';
import 'package:super_tooltip/src/enums.dart';

/// Configuration class for tooltip arrow
@immutable
class ArrowConfiguration {
  const ArrowConfiguration(
      {this.length = 20.0,
      this.baseWidth = 20.0,
      this.tipRadius = 0.0,
      this.tipDistance = 2.0});

  final double length;
  final double baseWidth;
  final double tipRadius;
  final double tipDistance;

  ArrowConfiguration copyWith({
    double? length,
    double? baseWidth,
    double? tipRadius,
    double? tipDistance,
  }) {
    return ArrowConfiguration(
      length: length ?? this.length,
      baseWidth: baseWidth ?? this.baseWidth,
      tipRadius: tipRadius ?? this.tipRadius,
      tipDistance: tipDistance ?? this.tipDistance,
    );
  }
}

/// Configuration class for close button
@immutable
class CloseButtonConfiguration {
  const CloseButtonConfiguration({
    this.show = false,
    this.type = CloseButtonType.inside,
    this.color,
    this.size,
  });

  final bool show;
  final CloseButtonType type;
  final Color? color;
  final double? size;

  CloseButtonConfiguration copyWith({
    bool? show,
    CloseButtonType? type,
    Color? color,
    double? size,
  }) {
    return CloseButtonConfiguration(
      show: show ?? this.show,
      type: type ?? this.type,
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }
}

/// Configuration class for barrier
@immutable
class BarrierConfiguration {
  const BarrierConfiguration({
    this.show = true,
    this.color,
    this.showBlur = false,
    this.sigmaX = 5.0,
    this.sigmaY = 5.0,
  });

  final bool show;
  final Color? color;
  final bool showBlur;
  final double sigmaX;
  final double sigmaY;

  BarrierConfiguration copyWith({
    bool? show,
    Color? color,
    bool? showBlur,
    double? sigmaX,
    double? sigmaY,
  }) {
    return BarrierConfiguration(
      show: show ?? this.show,
      color: color ?? this.color,
      showBlur: showBlur ?? this.showBlur,
      sigmaX: sigmaX ?? this.sigmaX,
      sigmaY: sigmaY ?? this.sigmaY,
    );
  }
}

/// Configuration class for tooltip positioning
@immutable
class PositionConfiguration {
  const PositionConfiguration({
    this.preferredDirection = TooltipDirection.down,
    this.preferredDirectionBuilder,
    this.snapsFarAwayVertically = false,
    this.snapsFarAwayHorizontally = false,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.minimumOutsideMargin = 20.0,
  });

  final TooltipDirection preferredDirection;
  final TooltipDirection Function()? preferredDirectionBuilder;
  final bool snapsFarAwayVertically;
  final bool snapsFarAwayHorizontally;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final double minimumOutsideMargin;

  PositionConfiguration copyWith({
    TooltipDirection? preferredDirection,
    TooltipDirection Function()? preferredDirectionBuilder,
    bool? snapsFarAwayVertically,
    bool? snapsFarAwayHorizontally,
    double? top,
    double? right,
    double? bottom,
    double? left,
    double? minimumOutsideMargin,
  }) {
    return PositionConfiguration(
      preferredDirection: preferredDirection ?? this.preferredDirection,
      preferredDirectionBuilder:
          preferredDirectionBuilder ?? this.preferredDirectionBuilder,
      snapsFarAwayVertically:
          snapsFarAwayVertically ?? this.snapsFarAwayVertically,
      snapsFarAwayHorizontally:
          snapsFarAwayHorizontally ?? this.snapsFarAwayHorizontally,
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      minimumOutsideMargin: minimumOutsideMargin ?? this.minimumOutsideMargin,
    );
  }
}

/// Configuration class for interaction behavior
@immutable
class InteractionConfiguration {
  const InteractionConfiguration({
    this.hideOnTap = false,
    this.hideOnBarrierTap = true,
    this.hideOnScroll = false,
    this.toggleOnTap = false,
    this.showOnTap = true,
    this.showOnHover = false,
    this.hideOnHoverExit = false,
    this.clickThrough = false,
  });

  final bool hideOnTap;
  final bool hideOnBarrierTap;
  final bool hideOnScroll;
  final bool toggleOnTap;
  final bool showOnTap;
  final bool showOnHover;
  final bool hideOnHoverExit;
  final bool clickThrough;

  InteractionConfiguration copyWith({
    bool? hideOnTap,
    bool? hideOnBarrierTap,
    bool? hideOnScroll,
    bool? toggleOnTap,
    bool? showOnTap,
    bool? showOnHover,
    bool? hideOnHoverExit,
    bool? clickThrough,
  }) {
    return InteractionConfiguration(
      hideOnTap: hideOnTap ?? this.hideOnTap,
      hideOnBarrierTap: hideOnBarrierTap ?? this.hideOnBarrierTap,
      hideOnScroll: hideOnScroll ?? this.hideOnScroll,
      toggleOnTap: toggleOnTap ?? this.toggleOnTap,
      showOnTap: showOnTap ?? this.showOnTap,
      showOnHover: showOnHover ?? this.showOnHover,
      hideOnHoverExit: hideOnHoverExit ?? this.hideOnHoverExit,
      clickThrough: clickThrough ?? this.clickThrough,
    );
  }
}

/// Configuration class for animation timing
@immutable
class AnimationConfiguration {
  const AnimationConfiguration({
    this.fadeInDuration = const Duration(milliseconds: 150),
    this.fadeOutDuration = Duration.zero,
    this.waitDuration = Duration.zero,
    this.showDuration,
    this.exitDuration = const Duration(milliseconds: 100),
  });

  final Duration fadeInDuration;
  final Duration fadeOutDuration;
  final Duration waitDuration;
  final Duration? showDuration;
  final Duration exitDuration;

  AnimationConfiguration copyWith({
    Duration? fadeInDuration,
    Duration? fadeOutDuration,
    Duration? waitDuration,
    Duration? showDuration,
    Duration? exitDuration,
  }) {
    return AnimationConfiguration(
      fadeInDuration: fadeInDuration ?? this.fadeInDuration,
      fadeOutDuration: fadeOutDuration ?? this.fadeOutDuration,
      waitDuration: waitDuration ?? this.waitDuration,
      showDuration: showDuration ?? this.showDuration,
      exitDuration: exitDuration ?? this.exitDuration,
    );
  }
}
