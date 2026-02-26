import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bubble_shape.dart';
import 'enums.dart';
import 'shape_overlay.dart';
import 'super_tooltip_configuration.dart';
import 'super_tooltip_controller.dart';
import 'super_tooltip_position_delegate.dart';
import 'super_tooltip_style.dart';
import 'utils.dart';

typedef DecorationBuilder = Decoration Function(Offset target);

/// A powerful and customizable tooltip widget for Flutter.
///
/// `SuperTooltip` provides a flexible and feature-rich way to display tooltips
/// in your Flutter applications with extensive customization options.
///
/// Example:
/// ```dart
/// final _controller = SuperTooltipController();
///
/// GestureDetector(
///   onTap: () => _controller.showTooltip(),
///   child: SuperTooltip(
///     controller: _controller,
///     content: const Text('This is a tooltip!'),
///     child: const Icon(Icons.info),
///   ),
/// )
/// `

class SuperTooltip extends StatefulWidget {
  const SuperTooltip({
    Key? key,
    required this.content,
    this.controller,
    this.child,
    this.style = const TooltipStyle(),
    this.arrowConfig = const ArrowConfiguration(),
    this.closeButtonConfig = const CloseButtonConfiguration(),
    this.barrierConfig = const BarrierConfiguration(),
    this.positionConfig = const PositionConfiguration(),
    this.interactionConfig = const InteractionConfiguration(),
    this.animationConfig = const AnimationConfiguration(),
    this.constraints = const BoxConstraints(
      minHeight: 0.0,
      maxHeight: double.infinity,
      minWidth: 0.0,
      maxWidth: double.infinity,
    ),
    this.decorationBuilder,
    this.touchThroughArea,
    this.touchThroughAreaShape = ClipAreaShape.oval,
    this.touchThroughAreaCornerRadius = 5.0,
    this.overlayDimensions = const EdgeInsets.all(10),
    this.mouseCursor,
    this.onLongPress,
    this.onShow,
    this.onHide,
  }) : super(key: key);

  /// The widget to be displayed inside the tooltip.
  final Widget content;

  /// Controller to manage the tooltip's visibility and state.
  final SuperTooltipController? controller;

  /// The target widget to which the tooltip is attached.
  final Widget? child;

  /// Styling configuration for the tooltip.
  final TooltipStyle style;

  /// Arrow configuration.
  final ArrowConfiguration arrowConfig;

  /// Close button configuration.
  final CloseButtonConfiguration closeButtonConfig;

  /// Barrier configuration.
  final BarrierConfiguration barrierConfig;

  /// Positioning configuration.
  final PositionConfiguration positionConfig;

  /// Interaction behavior configuration.
  final InteractionConfiguration interactionConfig;

  /// Animation timing configuration.
  final AnimationConfiguration animationConfig;

  /// Box constraints for the tooltip's size.
  final BoxConstraints constraints;

  /// Custom decoration builder for advanced styling.
  final DecorationBuilder? decorationBuilder;

  /// Rectangular area that allows touch events to pass through the barrier.
  final Rect? touchThroughArea;

  /// Shape of the touch-through area.
  final ClipAreaShape touchThroughAreaShape;

  /// Corner radius of the touch-through area.
  final double touchThroughAreaCornerRadius;

  /// EdgeInsetsGeometry for the overlay.
  final EdgeInsetsGeometry overlayDimensions;

  /// Mouse cursor when hovering over the child.
  final MouseCursor? mouseCursor;

  /// Callback when the user long presses the target widget.
  final VoidCallback? onLongPress;

  /// Callback when the tooltip is shown.
  final VoidCallback? onShow;

  /// Callback when the tooltip is hidden.
  final VoidCallback? onHide;

  /// Key used to identify the inside close button.
  static const Key insideCloseButtonKey = Key("InsideCloseButtonKey");

  /// Key used to identify the outside close button.
  static const Key outsideCloseButtonKey = Key("OutsideCloseButtonKey");

  /// Key used to identify the barrier.
  static const Key barrierKey = Key("barrierKey");

  /// Key used to identify the bubble.
  static const Key bubbleKey = Key("bubbleKey");

  @override
  State<SuperTooltip> createState() => _SuperTooltipState();
}

class _SuperTooltipState extends State<SuperTooltip>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  late AnimationController _animationController;
  late SuperTooltipController _controller;
  bool _ownsController = false;

  OverlayEntry? _tooltipEntry;
  OverlayEntry? _barrierEntry;
  OverlayEntry? _blurEntry;

  TooltipDirection _resolvedDirection = TooltipDirection.down;

  Timer? _showTimer;
  Timer? _hideTimer;
  Timer? _showDurationTimer;

  // Computed properties
  bool get _isNativeMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  bool get _shouldShowBarrier {
    if (_isNativeMobile) {
      return widget.barrierConfig.show;
    }
    return widget.interactionConfig.hideOnHoverExit
        ? false
        : widget.barrierConfig.show;
  }

  Color get _effectiveBarrierColor =>
      widget.barrierConfig.color ?? Colors.black54;

  Color get _effectiveCloseButtonColor =>
      widget.closeButtonConfig.color ?? Colors.black;

  double get _effectiveCloseButtonSize => widget.closeButtonConfig.size ?? 30.0;

  Color get _effectiveShadowColor => widget.style.shadowColor ?? Colors.black54;

  double get _effectiveShadowBlurRadius =>
      widget.style.shadowBlurRadius ?? 10.0;

  double get _effectiveShadowSpreadRadius =>
      widget.style.shadowSpreadRadius ?? 5.0;

  Offset get _effectiveShadowOffset => widget.style.shadowOffset ?? Offset.zero;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _initializeAnimationController();
  }

  void _initializeController() {
    if (widget.controller == null) {
      _controller = SuperTooltipController();
      _ownsController = true;
    } else {
      _controller = widget.controller!;
      _ownsController = false;
    }
    _controller.addListener(_onControllerChanged);
  }

  void _initializeAnimationController() {
    _animationController = AnimationController(
      duration: widget.animationConfig.fadeInDuration,
      reverseDuration: widget.animationConfig.fadeOutDuration,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(SuperTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handleControllerUpdate(oldWidget);
    _handleAnimationUpdate(oldWidget);
  }

  void _handleControllerUpdate(SuperTooltip oldWidget) {
    if (_controller != widget.controller) {
      _controller.removeListener(_onControllerChanged);
      if (_ownsController) {
        _controller.dispose();
      }
      _initializeController();
    }
  }

  void _handleAnimationUpdate(SuperTooltip oldWidget) {
    if (widget.animationConfig.fadeInDuration !=
            oldWidget.animationConfig.fadeInDuration ||
        widget.animationConfig.fadeOutDuration !=
            oldWidget.animationConfig.fadeOutDuration) {
      _animationController.duration = widget.animationConfig.fadeInDuration;
      _animationController.reverseDuration =
          widget.animationConfig.fadeOutDuration;
    }
  }

  @override
  void dispose() {
    _cancelAllTimers();
    _removeAllOverlayEntries();
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _cancelAllTimers() {
    _showTimer?.cancel();
    _hideTimer?.cancel();
    _showDurationTimer?.cancel();
  }

  void _removeAllOverlayEntries() {
    if (_tooltipEntry != null) {
      _removeEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.mouseCursor ?? SystemMouseCursors.basic,
      hitTestBehavior: HitTestBehavior.translucent,
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          onTap: _handleTap,
          onLongPress: widget.onLongPress,
          child: widget.child,
        ),
      ),
    );
  }

  void _handleMouseEnter(PointerEnterEvent event) {
    if (!widget.interactionConfig.showOnHover) return;

    _hideTimer?.cancel();
    _showTimer?.cancel();
    _showTimer = Timer(widget.animationConfig.waitDuration, () {
      if (!_controller.isVisible) {
        _controller.showTooltip();
      }
    });
  }

  void _handleMouseExit(PointerExitEvent event) {
    if (!widget.interactionConfig.hideOnHoverExit) return;

    _showTimer?.cancel();
    if (!_controller.isVisible) return;

    _hideTimer?.cancel();
    _hideTimer = Timer(widget.animationConfig.exitDuration, () {
      if (_controller.isVisible) {
        _controller.hideTooltip();
      }
    });
  }

  void _handleTap() {
    if (widget.interactionConfig.toggleOnTap && _controller.isVisible) {
      _controller.hideTooltip();
    } else if (widget.interactionConfig.showOnTap) {
      _controller.showTooltip();
    }
  }

  void _onControllerChanged() {
    switch (_controller.event) {
      case Event.show:
        _showTooltip();
        break;
      case Event.hide:
        _hideTooltip();
        break;
    }
  }

  Future<void> _showTooltip() async {
    widget.onShow?.call();

    if (_tooltipEntry != null) return;

    _showTimer?.cancel();
    _createOverlayEntries();

    await _animationController.forward().whenComplete(_controller.complete);

    _showDurationTimer?.cancel();
    if (widget.animationConfig.showDuration != null) {
      _showDurationTimer = Timer(widget.animationConfig.showDuration!, () {
        if (_controller.isVisible) {
          _controller.hideTooltip();
        }
      });
    }
  }

  Future<void> _hideTooltip() async {
    widget.onHide?.call();
    _showDurationTimer?.cancel();

    await _animationController.reverse().whenComplete(_controller.complete);
    _removeEntries();
  }

  void _createOverlayEntries() {
    final overlayState = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final overlay = overlayState.context.findRenderObject() as RenderBox?;

    final size = renderBox.size;
    final target = renderBox.localToGlobal(size.center(Offset.zero));

    final animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );

    final offsetToTarget = Offset(
      -target.dx + size.width / 2,
      -target.dy + size.height / 2,
    );

    final backgroundColor =
        widget.style.backgroundColor ?? Theme.of(context).cardColor;

    final positionData = _calculatePosition(target, overlay);
    _resolvedDirection = positionData.direction;

    _barrierEntry = _shouldShowBarrier ? _createBarrierEntry(animation) : null;

    _blurEntry = widget.barrierConfig.showBlur
        ? _createBlurEntry(animation)
        : null;

    _tooltipEntry = _createTooltipEntry(
      animation: animation,
      offsetToTarget: offsetToTarget,
      target: target,
      backgroundColor: backgroundColor,
      overlay: overlay,
      positionData: positionData,
    );

    overlayState.insertAll([
      if (widget.barrierConfig.showBlur) _blurEntry!,
      if (_shouldShowBarrier) _barrierEntry!,
      _tooltipEntry!,
    ]);
  }

  OverlayEntry _createBarrierEntry(Animation<double> animation) {
    return OverlayEntry(
      builder: (context) => FadeTransition(
        opacity: animation,
        child: GestureDetector(
          onTap: widget.interactionConfig.hideOnBarrierTap
              ? _controller.hideTooltip
              : null,
          onVerticalDragUpdate: widget.interactionConfig.hideOnScroll
              ? (_) => _controller.hideTooltip()
              : null,
          onHorizontalDragUpdate: widget.interactionConfig.hideOnScroll
              ? (_) => _controller.hideTooltip()
              : null,
          child: Container(
            key: SuperTooltip.barrierKey,
            decoration: ShapeDecoration(
              shape: ShapeOverlay(
                clipAreaCornerRadius: widget.touchThroughAreaCornerRadius,
                clipAreaShape: widget.touchThroughAreaShape,
                clipRect: widget.touchThroughArea,
                barrierColor: _effectiveBarrierColor,
                overlayDimensions: widget.overlayDimensions,
              ),
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry _createBlurEntry(Animation<double> animation) {
    return OverlayEntry(
      builder: (context) => FadeTransition(
        opacity: animation,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.barrierConfig.sigmaX,
            sigmaY: widget.barrierConfig.sigmaY,
          ),
          child: Container(width: double.infinity, height: double.infinity),
        ),
      ),
    );
  }

  OverlayEntry _createTooltipEntry({
    required Animation<double> animation,
    required Offset offsetToTarget,
    required Offset target,
    required Color backgroundColor,
    required RenderBox? overlay,
    required _PositionData positionData,
  }) {
    return OverlayEntry(
      builder: (context) => IgnorePointer(
        ignoring: widget.interactionConfig.clickThrough,
        child: FadeTransition(
          opacity: animation,
          child: Center(
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: offsetToTarget,
              child: CustomSingleChildLayout(
                delegate: SuperToolTipPositionDelegate(
                  preferredDirection: positionData.direction,
                  constraints: positionData.constraints,
                  top: positionData.top,
                  bottom: positionData.bottom,
                  left: positionData.left,
                  right: positionData.right,
                  target: target,
                  overlay: overlay,
                  margin: widget.positionConfig.minimumOutsideMargin,
                  snapsFarAwayHorizontally:
                      widget.positionConfig.snapsFarAwayHorizontally,
                  snapsFarAwayVertically:
                      widget.positionConfig.snapsFarAwayVertically,
                ),
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                    _buildTooltipBubble(target, backgroundColor, positionData),
                    _buildCloseButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTooltipBubble(
    Offset target,
    Color backgroundColor,
    _PositionData positionData,
  ) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.interactionConfig.hideOnTap
            ? _controller.hideTooltip
            : null,
        onVerticalDragUpdate: widget.interactionConfig.hideOnScroll
            ? (_) => _controller.hideTooltip()
            : null,
        onHorizontalDragUpdate: widget.interactionConfig.hideOnScroll
            ? (_) => _controller.hideTooltip()
            : null,
        child: Container(
          key: SuperTooltip.bubbleKey,
          margin: SuperUtils.getTooltipMargin(
            arrowLength: widget.arrowConfig.length,
            arrowTipDistance: widget.arrowConfig.tipDistance,
            closeButtonSize: _effectiveCloseButtonSize,
            preferredDirection: _resolvedDirection,
            closeButtonType: widget.closeButtonConfig.type,
            showCloseButton: widget.closeButtonConfig.show,
          ),
          padding: SuperUtils.getTooltipPadding(
            closeButtonSize: _effectiveCloseButtonSize,
            closeButtonType: widget.closeButtonConfig.type,
            showCloseButton: widget.closeButtonConfig.show,
          ),
          decoration:
              widget.decorationBuilder?.call(target) ??
              _buildDefaultDecoration(backgroundColor, target, positionData),
          child: widget.content,
        ),
      ),
    );
  }

  Decoration _buildDefaultDecoration(
    Color backgroundColor,
    Offset target,
    _PositionData positionData,
  ) {
    return ShapeDecoration(
      color: backgroundColor,
      shadows: widget.style.hasShadow
          ? widget.style.boxShadows ??
                [
                  BoxShadow(
                    blurRadius: _effectiveShadowBlurRadius,
                    spreadRadius: _effectiveShadowSpreadRadius,
                    color: _effectiveShadowColor,
                    offset: _effectiveShadowOffset,
                  ),
                ]
          : null,
      shape: BubbleShape(
        arrowBaseWidth: widget.arrowConfig.baseWidth,
        arrowTipDistance: widget.arrowConfig.tipDistance,
        arrowTipRadius: widget.arrowConfig.tipRadius,
        borderColor: widget.style.borderColor,
        borderRadius: widget.style.borderRadius,
        borderWidth: widget.style.borderWidth,
        bottom: positionData.bottom,
        left: positionData.left,
        preferredDirection: _resolvedDirection,
        right: positionData.right,
        target: target,
        top: positionData.top,
        bubbleDimensions: widget.style.bubbleDimensions,
      ),
    );
  }

  Widget _buildCloseButton() {
    if (!widget.closeButtonConfig.show) {
      return const SizedBox.shrink();
    }

    final buttonPosition = _calculateCloseButtonPosition();

    return Positioned(
      right: buttonPosition.right,
      top: buttonPosition.top,
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          key: widget.closeButtonConfig.type == CloseButtonType.inside
              ? SuperTooltip.insideCloseButtonKey
              : SuperTooltip.outsideCloseButtonKey,
          icon: Icon(
            Icons.close_outlined,
            size: _effectiveCloseButtonSize,
            color: _effectiveCloseButtonColor,
          ),
          onPressed: _controller.hideTooltip,
          tooltip: widget.closeButtonConfig.tooltip,
        ),
      ),
    );
  }

  ({double right, double top}) _calculateCloseButtonPosition() {
    final isInside = widget.closeButtonConfig.type == CloseButtonType.inside;

    switch (_resolvedDirection) {
      case TooltipDirection.left:
        return (
          right:
              widget.arrowConfig.length + widget.arrowConfig.tipDistance + 3.0,
          top: isInside ? 2.0 : 0.0,
        );

      case TooltipDirection.right:
      case TooltipDirection.up:
        return (right: 5.0, top: isInside ? 2.0 : 0.0);

      case TooltipDirection.down:
        return (
          right: 2.0,
          top: isInside
              ? widget.arrowConfig.length + widget.arrowConfig.tipDistance + 2.0
              : 0.0,
        );

      case TooltipDirection.auto:
        return (right: 2.0, top: 0.0);
    }
  }

  _PositionData _calculatePosition(Offset target, RenderBox? overlay) {
    var constraints = widget.constraints;
    var preferredDirection =
        widget.positionConfig.preferredDirectionBuilder?.call() ??
        widget.positionConfig.preferredDirection;
    var left = widget.positionConfig.left;
    var right = widget.positionConfig.right;
    var top = widget.positionConfig.top;
    var bottom = widget.positionConfig.bottom;

    // Auto direction resolution
    if (preferredDirection == TooltipDirection.auto && overlay != null) {
      preferredDirection = _resolveAutoDirection(target, overlay, constraints);
    }

    // Handle snapping behavior
    if (widget.positionConfig.snapsFarAwayVertically) {
      final snapData = _handleVerticalSnapping(target, overlay);
      constraints = snapData.constraints;
      left = snapData.left;
      right = snapData.right;
      top = snapData.top;
      bottom = snapData.bottom;
      preferredDirection = snapData.direction;
    } else if (widget.positionConfig.snapsFarAwayHorizontally) {
      final snapData = _handleHorizontalSnapping(target, overlay);
      constraints = snapData.constraints;
      top = snapData.top;
      bottom = snapData.bottom;
      left = snapData.left;
      right = snapData.right;
      preferredDirection = snapData.direction;
    }

    return _PositionData(
      direction: preferredDirection,
      constraints: constraints,
      top: top,
      bottom: bottom,
      left: left,
      right: right,
    );
  }

  TooltipDirection _resolveAutoDirection(
    Offset target,
    RenderBox overlay,
    BoxConstraints constraints,
  ) {
    final estimatedSize = Size(
      constraints.maxWidth.isFinite
          ? constraints.maxWidth
          : overlay.size.width * 0.8,
      constraints.maxHeight.isFinite
          ? constraints.maxHeight
          : overlay.size.height * 0.4,
    );

    final screen = overlay.size;
    final margin = widget.positionConfig.minimumOutsideMargin;

    final spaceAbove = target.dy - margin;
    final spaceBelow = screen.height - target.dy - margin;
    final spaceLeft = target.dx - margin;
    final spaceRight = screen.width - target.dx - margin;

    // Check if there's enough space in preferred directions
    if (spaceBelow >= estimatedSize.height) {
      return TooltipDirection.down;
    } else if (spaceAbove >= estimatedSize.height) {
      return TooltipDirection.up;
    } else if (spaceRight >= estimatedSize.width) {
      return TooltipDirection.right;
    } else if (spaceLeft >= estimatedSize.width) {
      return TooltipDirection.left;
    }

    // Find direction with most space
    final candidates = {
      TooltipDirection.down: spaceBelow,
      TooltipDirection.up: spaceAbove,
      TooltipDirection.right: spaceRight,
      TooltipDirection.left: spaceLeft,
    };

    return candidates.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  _SnapData _handleVerticalSnapping(Offset target, RenderBox? overlay) {
    final constraints = widget.constraints.copyWith(maxHeight: null);
    final left = 0.0;
    final right = 0.0;

    if (overlay != null) {
      final isUpperHalf = target.dy > overlay.size.center(Offset.zero).dy;
      return _SnapData(
        constraints: constraints,
        left: left,
        right: right,
        top: isUpperHalf ? 0.0 : null,
        bottom: isUpperHalf ? null : 0.0,
        direction: isUpperHalf ? TooltipDirection.up : TooltipDirection.down,
      );
    }

    return _SnapData(
      constraints: constraints,
      left: left,
      right: right,
      top: null,
      bottom: 0.0,
      direction: TooltipDirection.down,
    );
  }

  _SnapData _handleHorizontalSnapping(Offset target, RenderBox? overlay) {
    final constraints = widget.constraints.copyWith(maxHeight: null);
    final top = 0.0;
    final bottom = 0.0;

    if (overlay != null) {
      final isLeftHalf = target.dx < overlay.size.center(Offset.zero).dx;
      return _SnapData(
        constraints: constraints,
        top: top,
        bottom: bottom,
        left: isLeftHalf ? null : 0.0,
        right: isLeftHalf ? 0.0 : null,
        direction: isLeftHalf ? TooltipDirection.right : TooltipDirection.left,
      );
    }

    return _SnapData(
      constraints: constraints,
      top: top,
      bottom: bottom,
      left: 0.0,
      right: null,
      direction: TooltipDirection.left,
    );
  }

  void _removeEntries() {
    _tooltipEntry?.remove();
    _tooltipEntry = null;

    _barrierEntry?.remove();
    _barrierEntry = null;

    _blurEntry?.remove();
    _blurEntry = null;
  }
}

/// Internal class to hold position calculation results
class _PositionData {
  const _PositionData({
    required this.direction,
    required this.constraints,
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });

  final TooltipDirection direction;
  final BoxConstraints constraints;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
}

/// Internal class to hold snap calculation results
class _SnapData {
  const _SnapData({
    required this.constraints,
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
    required this.direction,
  });

  final BoxConstraints constraints;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final TooltipDirection direction;
}
