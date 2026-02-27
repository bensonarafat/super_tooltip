import 'package:flutter/material.dart';

@immutable
class TooltipStyle {
  const TooltipStyle({
    this.backgroundColor,
    this.gradient,
    this.borderColor = Colors.black,
    this.borderWidth = 0.0,
    this.borderRadius = 10.0,
    this.elevation = 0.0,
    this.hasShadow = true,
    this.shadowColor,
    this.shadowBlurRadius,
    this.shadowSpreadRadius,
    this.shadowOffset,
    this.boxShadows,
    this.bubbleDimensions = const EdgeInsets.all(10),
  });

  final Color? backgroundColor;
  final Gradient? gradient;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double elevation;
  final bool hasShadow;
  final Color? shadowColor;
  final double? shadowBlurRadius;
  final double? shadowSpreadRadius;
  final Offset? shadowOffset;
  final List<BoxShadow>? boxShadows;
  final EdgeInsetsGeometry bubbleDimensions;

  TooltipStyle copyWith({
    Color? backgroundColor,
    Gradient? gradient,
    Color? borderColor,
    double? borderWidth,
    double? borderRadius,
    double? elevation,
    bool? hasShadow,
    Color? shadowColor,
    double? shadowBlurRadius,
    double? shadowSpreadRadius,
    Offset? shadowOffset,
    List<BoxShadow>? boxShadows,
    EdgeInsetsGeometry? bubbleDimensions,
  }) {
    return TooltipStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      gradient: gradient ?? this.gradient,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      hasShadow: hasShadow ?? this.hasShadow,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      shadowSpreadRadius: shadowSpreadRadius ?? this.shadowSpreadRadius,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      boxShadows: boxShadows ?? this.boxShadows,
      bubbleDimensions: bubbleDimensions ?? this.bubbleDimensions,
    );
  }
}
