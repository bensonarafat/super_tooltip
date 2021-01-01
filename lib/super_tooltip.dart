import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

enum PreferredDirection { up, down, left, right }
enum ShowCloseButton { inside, outside, none }
enum ClipAreaShape { oval, rectangle }
enum _Event { show, hide }

class SuperTooltipController extends ChangeNotifier {
  Completer _completer;
  bool _isVisible = true;
  bool get isVisible => _isVisible;

  _Event event;

  Future<void> showTooltip() {
    event = _Event.show;
    _completer = Completer();
    notifyListeners();
    return _completer.future.whenComplete(() => _isVisible = true);
  }

  Future<void> hideTooltip() {
    event = _Event.hide;
    _completer = Completer();
    notifyListeners();
    return _completer.future.whenComplete(() => _isVisible = false);
  }

  void complete() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }
}

class SuperTooltip extends StatefulWidget {
  const SuperTooltip({
    Key key,
    @required this.content,
    this.preferredDirection = PreferredDirection.down,
    this.controller,
    this.onLongPress,
    this.onShow,
    this.onHide,
    this.showCloseButton,
    this.closeButtonColor,
    this.closeButtonSize,
    this.showBarrier,
    this.barrierColor,
    this.snapsFarAwayVertically = false,
    this.snapsFarAwayHorizontally = false,
    this.hasShadow,
    this.shadowColor,
    this.shadowBlurRadius,
    this.shadowSpreadRadius,
    this.top,
    this.right,
    this.bottom,
    this.left,
    // TD: Make edgeinsets instead
    this.minimumOutsideMargin = 20.0,
    this.verticalOffset = 0.0,
    this.elevation = 0.0,
    // TD: The native flutter tooltip uses verticalOffset
    //  to space the tooltip from the child. But we'll likely
    // need just offset, since it's 4 way directional
    // this.verticalOffset = 24.0,
    this.backgroundColor,
    this.decoration,
    this.child,
    this.borderColor = Colors.black,
    this.constraints = const BoxConstraints(
      minHeight: 0.0,
      maxHeight: double.infinity,
      minWidth: 0.0,
      maxWidth: double.infinity,
    ),
    this.fadeInDuration = const Duration(milliseconds: 150),
    this.fadeOutDuration = const Duration(milliseconds: 0),
    this.arrowLength = 20.0,
    this.arrowBaseWidth = 20.0,
    this.arrowTipDistance = 2.0,
    this.touchThroughAreaShape = ClipAreaShape.oval,
    this.touchThroughAreaCornerRadius = 5.0,
    this.touchThrougArea,
    this.borderWidth = 0.0,
    this.borderRadius = 10.0,
  }) : super(key: key);

  static Key insideCloseButtonKey = const Key("InsideCloseButtonKey");
  static Key outsideCloseButtonKey = const Key("OutsideCloseButtonKey");
  static Key barrierKey = const Key("barrierKey");
  static Key bubbleKey = const Key("bubbleKey");

  final Widget content;
  final PreferredDirection preferredDirection;
  final SuperTooltipController controller;
  final void Function() onLongPress;
  final void Function() onShow;
  final void Function() onHide;
  final bool snapsFarAwayVertically;
  final bool snapsFarAwayHorizontally;
  final bool hasShadow;
  final Color shadowColor;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;
  final double top, right, bottom, left;
  final ShowCloseButton showCloseButton;
  final Color closeButtonColor;
  final double closeButtonSize;
  final double minimumOutsideMargin;
  final double verticalOffset;
  final Widget child;
  final Color borderColor;
  final BoxConstraints constraints;
  final Color backgroundColor;
  final Decoration decoration;
  final double elevation;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;
  final double arrowLength;
  final double arrowBaseWidth;
  final double arrowTipDistance;
  final double borderRadius;
  final double borderWidth;
  final bool showBarrier;
  final Color barrierColor;
  final Rect touchThrougArea;
  final ClipAreaShape touchThroughAreaShape;
  final double touchThroughAreaCornerRadius;

  @override
  _ExtendedTooltipState createState() => _ExtendedTooltipState();
}

class _ExtendedTooltipState extends State<SuperTooltip>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  AnimationController _animationController;
  SuperTooltipController _superTooltipController;
  OverlayEntry _entry;
  OverlayEntry _barrierEntry;

  ShowCloseButton showCloseButton;
  Color closeButtonColor;
  double closeButtonSize;
  bool showBarrier;
  Color barrierColor;
  bool hasShadow;
  Color shadowColor;
  double shadowBlurRadius;
  double shadowSpreadRadius;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: widget.fadeInDuration,
      reverseDuration: widget.fadeOutDuration,
      vsync: this,
    );
    _superTooltipController = widget.controller ?? SuperTooltipController();
    _superTooltipController.addListener(_onChangeNotifier);

    // TD: Mouse stuff
    super.initState();
  }

  @override
  void didUpdateWidget(SuperTooltip oldWidget) {
    if (_superTooltipController != widget.controller) {
      _superTooltipController.removeListener(_onChangeNotifier);
      _superTooltipController = widget.controller ?? SuperTooltipController();
      _superTooltipController.addListener(_onChangeNotifier);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (_entry != null) _removeEntries();
    _superTooltipController.removeListener(_onChangeNotifier);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    showCloseButton = widget.showCloseButton ?? ShowCloseButton.none;
    closeButtonColor = widget.closeButtonColor ?? Colors.black;
    closeButtonSize = widget.closeButtonSize ?? 30.0;
    showBarrier = widget.showBarrier ?? true;
    barrierColor = widget.barrierColor ?? Colors.black54;
    hasShadow = widget.hasShadow ?? true;
    shadowColor = widget.shadowColor ?? Colors.black54;
    shadowBlurRadius = widget.shadowBlurRadius ?? 10.0;
    shadowSpreadRadius = widget.shadowSpreadRadius ?? 5.0;

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _superTooltipController.showTooltip,
        onLongPress: widget.onLongPress,
        child: widget.child,
      ),
    );
  }

  void _onChangeNotifier() {
    switch (_superTooltipController.event) {
      case _Event.show:
        _showTooltip();
        break;
      case _Event.hide:
        _hideTooltip();
        break;
    }
  }

  void _createOverlayEntries() {
    final renderBox = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
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
        widget.backgroundColor ?? Theme.of(context).cardColor;

    var constraints = widget.constraints;
    var preferredDirection = widget.preferredDirection;
    var left = widget.left;
    var right = widget.right;
    var top = widget.top;
    var bottom = widget.bottom;

    if (widget.snapsFarAwayVertically) {
      constraints = constraints.copyWith(maxHeight: null);
      left = right = 0.0;

      if (target.dy > overlay.size.center(Offset.zero).dy) {
        preferredDirection = PreferredDirection.up;
        top = 0.0;
      } else {
        preferredDirection = PreferredDirection.down;
        bottom = 0.0;
      }
    } else if (widget.snapsFarAwayHorizontally) {
      constraints = constraints.copyWith(maxHeight: null);
      top = bottom = 0.0;

      if (target.dx < overlay.size.center(Offset.zero).dx) {
        preferredDirection = PreferredDirection.right;
        right = 0.0;
      } else {
        preferredDirection = PreferredDirection.left;
        left = 0.0;
      }
    }

    _barrierEntry = showBarrier
        ? OverlayEntry(
            builder: (context) => FadeTransition(
              opacity: animation,
              child: GestureDetector(
                onTap: _superTooltipController.hideTooltip,
                child: Container(
                  key: SuperTooltip.barrierKey,
                  decoration: ShapeDecoration(
                    shape: _ShapeOverlay(
                      clipAreaCornerRadius: widget.touchThroughAreaCornerRadius,
                      clipAreaShape: widget.touchThroughAreaShape,
                      clipRect: widget.touchThrougArea,
                      barrierColor: barrierColor,
                    ),
                  ),
                ),
              ),
            ),
          )
        : null;

    _entry = OverlayEntry(
      builder: (BuildContext context) => FadeTransition(
        opacity: animation,
        child: Center(
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: offsetToTarget,
            child: CustomSingleChildLayout(
              delegate: _TooltipPositionDelegate(
                preferredDirection: preferredDirection,
                constraints: constraints,
                top: top,
                bottom: bottom,
                left: left,
                right: right,
                target: target,
                // verticalOffset: widget.verticalOffset,
                overlay: overlay,
                margin: widget.minimumOutsideMargin,
                snapsFarAwayHorizontally: widget.snapsFarAwayHorizontally,
                snapsFarAwayVertically: widget.snapsFarAwayVertically,
              ),
              // TD:  Text fields and such will need a material ancestor
              // In order to function properly. Need to find more elegant way
              // to add this.
              child: Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: Container(
                      key: SuperTooltip.bubbleKey,
                      margin: _getTooltipMargin(
                        arrowLength: widget.arrowLength,
                        arrowTipDistance: widget.arrowTipDistance,
                        closeButtonSize: closeButtonSize,
                        preferredDirection: preferredDirection,
                        showCloseButton: showCloseButton,
                      ),
                      padding: _getTooltipPadding(
                        closeButtonSize: closeButtonSize,
                        showCloseButton: showCloseButton,
                      ),
                      decoration: ShapeDecoration(
                        color: backgroundColor,
                        shadows: hasShadow
                            ? <BoxShadow>[
                                BoxShadow(
                                  blurRadius: shadowBlurRadius,
                                  spreadRadius: shadowSpreadRadius,
                                  color: shadowColor,
                                ),
                              ]
                            : null,
                        shape: _BubbleShape(
                          arrowBaseWidth: widget.arrowBaseWidth,
                          arrowTipDistance: widget.arrowTipDistance,
                          borderColor: widget.borderColor,
                          borderRadius: widget.borderRadius,
                          borderWidth: widget.borderWidth,
                          bottom: bottom,
                          left: left,
                          preferredDirection: preferredDirection,
                          right: right,
                          target: target,
                          top: top,
                        ),
                      ),
                      child: widget.content,
                    ),
                  ),
                  _buildCloseButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insertAll([
      if (showBarrier) _barrierEntry,
      _entry,
    ]);
  }

  _showTooltip() async {
    widget.onShow?.call();

    if (_entry != null) return; // Already visible.

    _createOverlayEntries();

    await _animationController
        .forward()
        .whenComplete(_superTooltipController.complete);
  }

  _removeEntries() {
    _entry?.remove();
    _entry = null;
    _barrierEntry?.remove();
    _entry = null;
  }

  _hideTooltip() async {
    widget.onHide?.call();
    await _animationController
        .reverse()
        .whenComplete(_superTooltipController.complete);

    _removeEntries();
  }

  Widget _buildCloseButton() {
    const internalClickAreaPadding = 2.0;

    //
    if (showCloseButton == ShowCloseButton.none) {
      return SizedBox();
    }

    // ---

    double right;
    double top;

    switch (widget.preferredDirection) {
      //
      // LEFT: -------------------------------------
      case PreferredDirection.left:
        right = widget.arrowLength + widget.arrowTipDistance + 3.0;
        if (showCloseButton == ShowCloseButton.inside) {
          top = 2.0;
        } else if (showCloseButton == ShowCloseButton.outside) {
          top = 0.0;
        } else
          throw AssertionError(showCloseButton);
        break;

      // RIGHT/UP: ---------------------------------
      case PreferredDirection.right:
      case PreferredDirection.up:
        right = 5.0;
        if (showCloseButton == ShowCloseButton.inside) {
          top = 2.0;
        } else if (showCloseButton == ShowCloseButton.outside) {
          top = 0.0;
        } else
          throw AssertionError(showCloseButton);
        break;

      // DOWN: -------------------------------------
      case PreferredDirection.down:
        // If this value gets negative the Shadow gets clipped. The problem occurs is arrowlength + arrowTipDistance
        // is smaller than _outSideCloseButtonPadding which would mean arrowLength would need to be increased if the button is ouside.
        right = 2.0;
        if (showCloseButton == ShowCloseButton.inside) {
          top = widget.arrowLength + widget.arrowTipDistance + 2.0;
        } else if (showCloseButton == ShowCloseButton.outside) {
          top = 0.0;
        } else
          throw AssertionError(showCloseButton);
        break;

      // ---------------------------------------------

      default:
        throw AssertionError(widget.preferredDirection);
    }

    // ---

    return Positioned(
      right: right,
      top: top,
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          key: showCloseButton == ShowCloseButton.inside
              ? SuperTooltip.insideCloseButtonKey
              : SuperTooltip.outsideCloseButtonKey,
          icon: Icon(
            Icons.close,
            size: closeButtonSize,
            color: closeButtonColor,
          ),
          onPressed: () async => await widget.controller.hideTooltip(),
        ),
      ),
    );
  }
}

class _TooltipPositionDelegate extends SingleChildLayoutDelegate {
  _TooltipPositionDelegate({
    @required this.snapsFarAwayVertically,
    @required this.snapsFarAwayHorizontally,
    @required this.preferredDirection,
    @required this.constraints,
    @required this.margin,
    @required this.top,
    @required this.bottom,
    @required this.left,
    @required this.right,
    @required this.target,
    // @required this.verticalOffset,
    @required this.overlay,
  }) : assert(target != null);
  // assert(verticalOffset != null);

  final bool snapsFarAwayVertically;
  final bool snapsFarAwayHorizontally;
  // TD: Make this EdgeInsets
  final double margin;
  final Offset target;
  // final double verticalOffset;
  final RenderBox overlay;
  final BoxConstraints constraints;

  final PreferredDirection preferredDirection;
  final double top, bottom, left, right;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // TD: when margin is EdgeInsets, look into
    // constraints.deflate(margin);

    var newConstraints = constraints;

    switch (preferredDirection) {
      case PreferredDirection.up:
      case PreferredDirection.down:
        newConstraints = _verticalConstraints(
          constraints: newConstraints,
          margin: margin,
          bottom: bottom,
          isUp: preferredDirection == PreferredDirection.up,
          target: target,
          top: top,
          left: left,
          right: right,
        );
        break;
      case PreferredDirection.right:
      case PreferredDirection.left:
        newConstraints = _horizontalConstraints(
          constraints: newConstraints,
          margin: margin,
          bottom: bottom,
          isRight: preferredDirection == PreferredDirection.right,
          target: target,
          top: top,
          left: left,
          right: right,
        );
        break;
    }

    // TD: This scenerio should likely be avoided in the initial functions
    return newConstraints.copyWith(
      minHeight: newConstraints.minHeight > newConstraints.maxHeight
          ? newConstraints.maxHeight
          : newConstraints.minHeight,
      minWidth: newConstraints.minWidth > newConstraints.maxWidth
          ? newConstraints.maxWidth
          : newConstraints.minWidth,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // TD: If there isn't enough space for the child on the preferredDirection
    // use the opposite dirrection
    //
    // See:
    // return positionDependentBox(
    //     size: size,
    //     childSize: childSize,
    //     target: target,
    //     verticalOffset: verticalOffset,
    //     preferBelow: preferBelow,
    //   );

    switch (preferredDirection) {
      case PreferredDirection.up:
      case PreferredDirection.down:
        final topOffset = preferredDirection == PreferredDirection.up
            ? top ?? target.dy - childSize.height
            : target.dy;

        return Offset(
          _leftMostXtoTarget(
            childSize: childSize,
            left: left,
            margin: margin,
            right: right,
            size: size,
            target: target,
          ),
          topOffset,
        );

      case PreferredDirection.right:
      case PreferredDirection.left:
        final leftOffset = preferredDirection == PreferredDirection.left
            ? left ?? target.dx - childSize.width
            : target.dx;
        return Offset(
          leftOffset,
          _topMostYtoTarget(
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
  bool shouldRelayout(_TooltipPositionDelegate oldDelegate) => true;
}

class _BubbleShape extends ShapeBorder {
  const _BubbleShape({
    @required this.preferredDirection,
    @required this.target,
    @required this.borderRadius,
    @required this.arrowBaseWidth,
    @required this.arrowTipDistance,
    @required this.borderColor,
    @required this.borderWidth,
    @required this.left,
    @required this.top,
    @required this.right,
    @required this.bottom,
  });

  final Offset target;
  final double arrowBaseWidth;
  final double arrowTipDistance;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final double left, top, right, bottom;
  final PreferredDirection preferredDirection;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(10.0);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) => Path()
    ..fillType = PathFillType.evenOdd
    ..addPath(getOuterPath(rect), Offset.zero);

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    //
    double topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius;

    Path _getLeftTopPath(Rect rect) => Path()
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

    Path _getBottomRightPath(Rect rect) => Path()
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
      case PreferredDirection.down:
        return _getBottomRightPath(rect)
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
          ..lineTo(target.dx, target.dy + arrowTipDistance) // up to arrow tip
          ..lineTo(
            max(
              min(
                target.dx - arrowBaseWidth / 2,
                rect.right - topLeftRadius - arrowBaseWidth,
              ),
              rect.left + topLeftRadius,
            ),
            rect.top,
          ) //  down /

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

      case PreferredDirection.up:
        return _getLeftTopPath(rect)
          ..lineTo(rect.right, rect.bottom - bottomRightRadius)
          ..arcToPoint(Offset(rect.right - bottomRightRadius, rect.bottom),
              radius: Radius.circular(bottomRightRadius), clockwise: true)
          ..lineTo(
              min(
                  max(target.dx + arrowBaseWidth / 2,
                      rect.left + bottomLeftRadius + arrowBaseWidth),
                  rect.right - bottomRightRadius),
              rect.bottom)

          // up to arrow tip   \
          ..lineTo(target.dx, target.dy - arrowTipDistance)

          //  down /
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

      case PreferredDirection.left:
        return _getLeftTopPath(rect)
          ..lineTo(
              rect.right,
              max(
                  min(target.dy - arrowBaseWidth / 2,
                      rect.bottom - bottomRightRadius - arrowBaseWidth),
                  rect.top + topRightRadius))
          ..lineTo(
              target.dx - arrowTipDistance, target.dy) // right to arrow tip   \
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

      case PreferredDirection.right:
        return _getBottomRightPath(rect)
          ..lineTo(rect.left + topLeftRadius, rect.top)
          ..arcToPoint(Offset(rect.left, rect.top + topLeftRadius),
              radius: Radius.circular(topLeftRadius), clockwise: false)
          ..lineTo(
              rect.left,
              max(
                  min(target.dy - arrowBaseWidth / 2,
                      rect.bottom - bottomLeftRadius - arrowBaseWidth),
                  rect.top + topLeftRadius))

          //left to arrow tip   /
          ..lineTo(target.dx + arrowTipDistance, target.dy)

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
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
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
    return _BubbleShape(
      preferredDirection: preferredDirection,
      target: target,
      borderRadius: borderRadius,
      arrowBaseWidth: arrowBaseWidth,
      arrowTipDistance: arrowTipDistance,
      borderColor: borderColor,
      borderWidth: borderWidth,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }
}

class _ShapeOverlay extends ShapeBorder {
  const _ShapeOverlay({
    @required this.clipRect,
    @required this.clipAreaShape,
    @required this.clipAreaCornerRadius,
    @required this.barrierColor,
  });

  final Rect clipRect;
  final ClipAreaShape clipAreaShape;
  final double clipAreaCornerRadius;
  final Color barrierColor;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(10.0);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) =>
      Path()..addOval(clipRect);

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    var outer = Path()..addRect(rect);

    if (clipRect == null) return outer;

    Path exclusion;

    if (clipAreaShape == ClipAreaShape.oval) {
      exclusion = Path()..addOval(clipRect);
    } else {
      exclusion = Path()
        ..moveTo(clipRect.left + clipAreaCornerRadius, clipRect.top)
        ..lineTo(clipRect.right - clipAreaCornerRadius, clipRect.top)
        ..arcToPoint(
          Offset(clipRect.right, clipRect.top + clipAreaCornerRadius),
          radius: Radius.circular(clipAreaCornerRadius),
        )
        ..lineTo(clipRect.right, clipRect.bottom - clipAreaCornerRadius)
        ..arcToPoint(
          Offset(clipRect.right - clipAreaCornerRadius, clipRect.bottom),
          radius: Radius.circular(clipAreaCornerRadius),
        )
        ..lineTo(clipRect.left + clipAreaCornerRadius, clipRect.bottom)
        ..arcToPoint(
          Offset(clipRect.left, clipRect.bottom - clipAreaCornerRadius),
          radius: Radius.circular(clipAreaCornerRadius),
        )
        ..lineTo(clipRect.left, clipRect.top + clipAreaCornerRadius)
        ..arcToPoint(
          Offset(clipRect.left + clipAreaCornerRadius, clipRect.top),
          radius: Radius.circular(clipAreaCornerRadius),
        )
        ..close();
    }

    return Path.combine(ui.PathOperation.difference, outer, exclusion);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) =>
      canvas.drawPath(
        getOuterPath(rect),
        Paint()..color = barrierColor,
      );

  @override
  ShapeBorder scale(double t) {
    return _ShapeOverlay(
      clipRect: clipRect,
      clipAreaShape: clipAreaShape,
      clipAreaCornerRadius: clipAreaCornerRadius,
      barrierColor: barrierColor,
    );
  }
}

EdgeInsets _getTooltipMargin({
  @required ShowCloseButton showCloseButton,
  @required double closeButtonSize,
  @required double arrowTipDistance,
  @required double arrowLength,
  @required PreferredDirection preferredDirection,
}) {
  final top =
      (showCloseButton == ShowCloseButton.outside) ? closeButtonSize + 12 : 0.0;

  switch (preferredDirection) {
    case PreferredDirection.down:
      return EdgeInsets.only(top: arrowTipDistance + arrowLength);

    case PreferredDirection.up:
      return EdgeInsets.only(bottom: arrowTipDistance + arrowLength, top: top);

    case PreferredDirection.left:
      return EdgeInsets.only(right: arrowTipDistance + arrowLength, top: top);

    case PreferredDirection.right:
      return EdgeInsets.only(left: arrowTipDistance + arrowLength, top: top);

    default:
      throw ArgumentError(preferredDirection);
  }
}

EdgeInsets _getTooltipPadding({
  @required ShowCloseButton showCloseButton,
  @required double closeButtonSize,
}) {
  final top =
      (showCloseButton == ShowCloseButton.inside) ? closeButtonSize : 0.0;
  return EdgeInsets.only(top: top);
}

double _leftMostXtoTarget({
  @required double left,
  @required double right,
  @required double margin,
  @required Size size,
  @required Size childSize,
  @required Offset target,
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

double _topMostYtoTarget({
  @required double top,
  @required double bottom,
  @required double margin,
  @required Offset target,
  @required Size size,
  @required Size childSize,
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

BoxConstraints _horizontalConstraints({
  @required BoxConstraints constraints,
  @required double top,
  @required double bottom,
  @required double right,
  @required double left,
  @required double margin,
  @required bool isRight,
  @required Offset target,
}) {
  var _maxHeight = constraints.maxHeight;
  var _minWidth = constraints.minWidth;
  var _maxWidth = constraints.maxWidth;

  if (top != null && bottom != null) {
    _maxHeight = _maxHeight - (top + bottom);
  } else if ((top != null && bottom == null) ||
      (top == null && bottom != null)) {
    // make sure that the sum of top, bottom + _maxHeight isn't bigger than the screen Height.
    final sideDelta = (top ?? 0.0) + (bottom ?? 0.0) + margin;

    if (_maxHeight > _maxHeight - sideDelta) {
      _maxHeight = _maxHeight - sideDelta;
    }
  } else {
    if (_maxHeight > _maxHeight - 2 * margin) {
      _maxHeight = _maxHeight - 2 * margin;
    }
  }

  if (isRight) {
    if (right != null) {
      _minWidth = _maxWidth = _maxWidth - right - target.dx;
    } else {
      _maxWidth = min(_maxWidth, _maxWidth - target.dx) - margin;
    }
  } else {
    if (left != null) {
      _minWidth = _maxWidth = target.dx - left;
    } else {
      _maxWidth = min(_maxWidth, target.dx) - margin;
    }
  }

  return constraints.copyWith(
    maxHeight: _maxHeight,
    minWidth: _minWidth,
    maxWidth: _maxWidth,
  );
}

BoxConstraints _verticalConstraints({
  @required BoxConstraints constraints,
  @required double margin,
  @required bool isUp,
  @required double top,
  @required double left,
  @required double right,
  @required double bottom,
  @required Offset target,
}) {
  var _minHeight = constraints.minHeight;
  var _maxHeight = constraints.maxHeight;
  var _maxWidth = constraints.maxWidth;

  if (left != null && right != null) {
    _maxWidth = _maxWidth - (left + right);
  } else if ((left != null && right == null) ||
      (left == null && right != null)) {
    // make sure that the sum of left, right + maxwidth isn't bigger than the screen width.
    final sideDelta = (left ?? 0.0) + (right ?? 0.0) + margin;

    if (_maxWidth > _maxWidth - sideDelta) {
      _maxWidth = _maxWidth - sideDelta;
    }
  } else {
    if (_maxWidth > _maxWidth - 2 * margin) {
      _maxWidth = _maxWidth - 2 * margin;
    }
  }

  if (isUp) {
    if (top != null) {
      _minHeight = _maxHeight = target.dy - top;
    } else {
      _maxHeight = min(_maxHeight, target.dy) - margin;
      // TD: clamp minheight
    }
  } else {
    if (bottom != null) {
      _minHeight = _maxHeight = _maxHeight - bottom - target.dy;
    } else {
      _maxHeight = min(_maxHeight, _maxHeight - target.dy) - margin;
      // TD: clamp minheight
    }
  }

  return constraints.copyWith(
    minHeight: _minHeight,
    maxHeight: _maxHeight,
    maxWidth: _maxWidth,
  );
}

// References
// https://github.com/escamoteur/super_tooltip
// https://api.flutter.dev/flutter/painting/positionDependentBox.html
// https://medium.com/saugo360/https-medium-com-saugo360-flutter-using-overlay-to-display-floating-widgets-2e6d0e8decb9

// TD: Add to build method
// final ThemeData theme = Theme.of(context);
// final TooltipThemeData tooltipTheme = TooltipTheme.of(context);

// BoxDecoration defaultDecoration;
// if (theme.brightness == Brightness.dark) {
//   defaultDecoration = BoxDecoration(
//     color: Colors.white.withOpacity(0.9),
//     borderRadius: const BorderRadius.all(Radius.circular(4)),
//   );
// } else {
//   defaultDecoration = BoxDecoration(
//     color: Colors.grey[700].withOpacity(0.9),
//     borderRadius: const BorderRadius.all(Radius.circular(4)),
//   );
// }

// padding = widget.padding ?? tooltipTheme.padding;
// margin = widget.margin ?? tooltipTheme.margin;
// verticalOffset = widget.verticalOffset ?? tooltipTheme.verticalOffset;
// preferBelow = widget.preferBelow ?? tooltipTheme.preferBelow;
// decoration =
//     widget.decoration ?? tooltipTheme.decoration ?? defaultDecoration;
