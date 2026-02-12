// ignore_for_file: comment_references

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide TooltipPositionDelegate;
import 'package:super_tooltip/src/utils.dart';

import 'bubble_shape.dart';
import 'enums.dart';
import 'shape_overlay.dart';
import 'super_tooltip_controller.dart';
import 'super_tooltip_position_delegate.dart';

typedef DecorationBuilder = Decoration Function(
  Offset target,
);

/// A powerful and customizable tooltip widget for Flutter.
///
/// `SuperTooltip` provides a flexible and feature-rich way to display tooltips
/// in your Flutter applications. It offers several advantages over the standard
/// Flutter `Tooltip` widget, including:
///
/// * **Flexible Positioning:** Control the tooltip's position relative to its
///   target widget using the `popupDirection`, `top`, `right`, `bottom`, and
///   `left` parameters.
/// * **Customizable Appearance:** Customize the tooltip's background color,
///   border, shadow, and more using the `backgroundColor`, `decoration`,
///   `borderColor`, and other styling parameters.
/// * **Barrier and Blur:** Optionally display a barrier (scrim) and blur effect
///   behind the tooltip using the `showBarrier`, `barrierColor`,
///   `showDropBoxFilter`, `sigmaX`, and `sigmaY` parameters.
/// * **Close Button:** Add a close button to allow users to manually dismiss the
///   tooltip using the `showCloseButton` and `closeButtonType` parameters.
/// * **Animation:** Smooth fade-in and fade-out animations for a visually
///   appealing experience.
/// * **Event Callbacks:** Trigger actions when the tooltip is shown or hidden
///   using the `onShow` and `onHide` callbacks.
/// * **Touch-Through Area:** Define an area that allows touch events to pass
///   through the barrier using the `touchThroughArea` parameter.
///
/// To use `SuperTooltip`, wrap your target widget with a `GestureDetector`,
/// `MouseRegion`, or `InkWell` and use the `controller` to manage the
/// tooltip's visibility.
///
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
/// ```

class SuperTooltip extends StatefulWidget {
  // Creates a `SuperTooltip` widget.
  ///
  /// The `content` parameter is required and specifies the widget to be
  /// displayed inside the tooltip.
  final Widget content;

  /// The direction in which the tooltip should appear relative to its
  /// target widget.
  ///
  /// Defaults to [TooltipDirection.down].
  ///
  /// See also:
  ///
  /// * [TooltipDirection], which defines the possible tooltip directions.
  final TooltipDirection popupDirection;

  /// The direction in which the tooltip should appear relative to its
  /// target widget.
  ///
  /// Defaults to [TooltipDirection.down].
  ///
  /// See also:
  ///
  /// * [TooltipDirection], which defines the possible tooltip directions.
  final TooltipDirection Function()? popupDirectionBuilder;

  /// A [SuperTooltipController] to manage the tooltip's visibility and state.
  ///
  /// If not provided, a new [SuperTooltipController] will be created
  /// internally.
  final SuperTooltipController? controller;

  /// Called when the user long presses the target widget.
  final void Function()? onLongPress;

  /// Called when the tooltip is shown.
  final void Function()? onShow;

  /// Called when the tooltip is hidden.
  final void Function()? onHide;

  /// Whether the tooltip should snap to the top or bottom of the screen
  /// if there's not enough space in the preferred direction.
  ///
  /// Defaults to `false`.
  final bool snapsFarAwayVertically;

  /// Whether the tooltip should snap to the left or right of the screen
  /// if there's not enough space in the preferred direction.
  ///
  /// Defaults to `false`.
  final bool snapsFarAwayHorizontally;

  /// Whether the tooltip should have a shadow.
  ///
  /// Defaults to `true`.
  final bool? hasShadow;

  /// The color of the shadow.
  ///
  /// If not provided, the default color will be used.
  final Color? shadowColor;

  /// The blur radius of the shadow.
  ///
  /// If not provided, the default blur radius will be used.
  final double? shadowBlurRadius;

  /// The spread radius of the shadow.
  ///
  /// If not provided, the default spread radius will be used.
  final double? shadowSpreadRadius;

  /// The offset of the shadow.
  ///
  /// If not provided, the default offset will be used.
  final Offset? shadowOffset;

  /// [top], [right], [bottom], [left] define the distance between the respective
  /// edges of the tooltip and the corresponding edges of the screen.
  ///
  /// If not provided, the tooltip will be positioned as close as possible
  /// to the specified edge, respecting the `minimumOutsideMargin`.
  final double? top, right, bottom, left;

  /// Whether to display a close button inside the tooltip.
  ///
  /// Defaults to `false`.
  final bool showCloseButton;

  /// The type of close button to display.
  ///
  /// Defaults to [CloseButtonType.inside].
  ///
  /// See also:
  ///
  /// * [CloseButtonType], which defines the possible close button types.
  final CloseButtonType closeButtonType;

  /// The color of the close button.
  ///
  /// If not provided, the default color will be used.
  final Color? closeButtonColor;

  /// The size of the close button.
  ///
  /// If not provided, the default size will be used.
  final double? closeButtonSize;

  /// The minimum margin between the tooltip and the edges of the screen.
  ///
  /// Defaults to `20.0`.
  final double minimumOutsideMargin;

  /// The vertical offset of the tooltip from its target widget.
  ///
  /// Defaults to `0.0`.
  final double verticalOffset;

  /// The target widget to which the tooltip is attached.
  final Widget? child;

  /// The border color of the tooltip.
  ///
  /// Defaults to `Colors.black`.
  final Color borderColor;

  /// Box constraints for the tooltip's size.
  ///
  /// Defaults to:
  /// ```dart
  /// const BoxConstraints(
  ///   minHeight: 0.0,
  ///   maxHeight: double.infinity,
  ///   minWidth: 0.0,
  ///   maxWidth: double.infinity,
  /// )
  /// ```
  final BoxConstraints constraints;

  /// The background color of the tooltip.
  ///
  /// If not provided, the default background color will be used.
  final Color? backgroundColor;

  /// A custom decoration for the tooltip.
  ///
  /// If not provided, the default decoration will be used.
  final DecorationBuilder? decorationBuilder;

  /// The elevation of the tooltip.
  ///
  /// Defaults to `0.0`.
  final double elevation;

  /// The duration of the fade-in animation.
  ///
  /// Defaults to `const Duration(milliseconds: 150)`.
  final Duration fadeInDuration;

  /// The duration of the fade-out animation.
  ///
  /// Defaults to `const Duration(milliseconds: 0)`.
  final Duration fadeOutDuration;

  /// The length of the tooltip's arrow.
  ///
  /// Defaults to `20.0`.
  final double arrowLength;

  /// The width of the tooltip's arrow base.
  ///
  /// Defaults to `20.0`.
  final double arrowBaseWidth;

  /// The distance between the arrow tip and the target widget.
  ///
  /// Defaults to `2.0`.
  final double arrowTipRadius;

  final double arrowTipDistance;

  /// The border radius of the tooltip.
  ///
  /// Defaults to `10.0`.
  final double borderRadius;

  /// The width of the tooltip's border.
  ///
  /// Defaults to `0.0`.
  final double borderWidth;

  /// Whether to display a barrier (scrim) behind the tooltip.
  ///
  /// Defaults to `true`.
  final bool? showBarrier;

  /// The color of the barrier.
  ///
  /// If not provided, the default color will be used.
  final Color? barrierColor;

  /// A rectangular area that allows touch events to pass through the barrier.
  final Rect? touchThroughArea;

  /// The shape of the touch-through area.
  ///
  /// Defaults to [ClipAreaShape.oval].
  ///
  /// See also:
  ///
  /// * [ClipAreaShape], which defines the possible touch-through area shapes.
  final ClipAreaShape touchThroughAreaShape;

  /// The corner radius of the touch-through area.
  ///
  /// Defaults to `5.0`.
  final double touchThroughAreaCornerRadius;

  /// EdgeInsetsGeometry for the overlay.
  ///
  /// Defaults to `const EdgeInsets.all(10)`.
  final EdgeInsetsGeometry overlayDimensions;

  /// EdgeInsetsGeometry for the bubble.
  ///
  /// Defaults to `const EdgeInsets.all(10)`.
  final EdgeInsetsGeometry bubbleDimensions;

  /// Whether to hide the tooltip when tapped.
  ///
  /// Defaults to `false`.
  final bool hideTooltipOnTap;

  /// Whether to hide the tooltip when the barrier is tapped.
  ///
  /// Defaults to `true`.
  final bool hideTooltipOnBarrierTap;

  /// Whether to toggle the tooltip's visibility when tapped.
  ///
  /// Defaults to `false`.
  final bool toggleOnTap;
  final bool showOnTap;

  /// Whether to show a blur filter behind the tooltip.
  ///
  /// Defaults to `false`.
  final bool showDropBoxFilter;

  /// The sigmaX value for the blur filter (if `showDropBoxFilter` is `true`).
  ///
  /// Defaults to `5.0`.
  final double sigmaX;

  /// The sigmaY value for the blur filter (if `showDropBoxFilter` is `true`).
  ///
  /// Defaults to `5.0`.
  final double sigmaY;

  /// A list of box shadows to apply to the tooltip.
  final List<BoxShadow>? boxShadows;

  /// Whether the tooltip should be click-through.
  ///
  /// Defaults to `false`.
  final bool clickThrough;

  /// Whether to automatically show the tooltip when the mouse pointer hovers over the [child].
  ///
  /// This feature utilizes [MouseRegion] and is primarily intended for Web and Desktop platforms.
  /// On touch-based mobile devices, this parameter is generally ignored unless a mouse is connected.
  ///
  /// Defaults to `false`.
  final bool showOnHover;

  /// Whether to automatically hide the tooltip when the mouse pointer leaves the [child]'s bounds.
  ///
  /// This is primarily intended for Web and Desktop platforms.
  ///
  /// **Note:** On Web/Desktop, enabling this will automatically disable the modal barrier
  /// (regardless of [showBarrier]) to ensure the mouse can exit the widget area without
  /// being blocked by the overlay.
  ///
  /// Defaults to `false`.
  final bool hideOnHoverExit;

  SuperTooltip({
    Key? key,
    required this.content,
    this.popupDirection = TooltipDirection.down,
    this.controller,
    this.onLongPress,
    this.onShow,
    this.onHide,
    this.popupDirectionBuilder,
    /**
     * showCloseButton
     * This will enable the closeButton
     */
    this.showCloseButton = false,
    this.closeButtonType = CloseButtonType.inside,
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
    this.shadowOffset,
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

    //
    //
    //
    this.decorationBuilder,
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
    this.arrowTipRadius = 0.0,
    this.arrowTipDistance = 2.0,
    this.touchThroughAreaShape = ClipAreaShape.oval,
    this.touchThroughAreaCornerRadius = 5.0,
    this.touchThroughArea,
    this.borderWidth = 0.0,
    this.borderRadius = 10.0,
    this.overlayDimensions = const EdgeInsets.all(10),
    this.bubbleDimensions = const EdgeInsets.all(10),
    this.hideTooltipOnTap = false,
    this.sigmaX = 5.0,
    this.sigmaY = 5.0,
    this.showDropBoxFilter = false,
    this.hideTooltipOnBarrierTap = true,
    this.toggleOnTap = false,
    this.showOnTap = true,
    this.boxShadows,
    this.clickThrough = false,
    this.showOnHover = false,
    this.hideOnHoverExit = false,
  })  : assert(showDropBoxFilter ? showBarrier ?? false : true,
            'showDropBoxFilter or showBarrier can\'t be false | null'),
        super(key: key);

  /// Key used to identify the inside close button.
  static Key insideCloseButtonKey = const Key("InsideCloseButtonKey");

  /// Key used to identify the outside close button.
  static Key outsideCloseButtonKey = const Key("OutsideCloseButtonKey");

  /// Key used to identify the barrier.
  static Key barrierKey = const Key("barrierKey");

  /// Key used to identify the bubble.
  static Key bubbleKey = const Key("bubbleKey");

  @override
  State createState() => _SuperTooltipState();
}

class _SuperTooltipState extends State<SuperTooltip>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  late AnimationController _animationController;
  SuperTooltipController? _superTooltipController;
  OverlayEntry? _entry;
  OverlayEntry? _barrierEntry;
  OverlayEntry? blur;

  bool showCloseButton = false;
  CloseButtonType closeButtonType = CloseButtonType.inside;
  Color? closeButtonColor;
  double? closeButtonSize;
  late bool showBarrier;
  Color? barrierColor;
  late bool hasShadow;
  late Color shadowColor;
  late double shadowBlurRadius;
  late double shadowSpreadRadius;
  late Offset shadowOffset;
  late bool showBlur;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: widget.fadeInDuration,
      reverseDuration: widget.fadeOutDuration,
      vsync: this,
    );
    _superTooltipController = widget.controller ?? SuperTooltipController();
    _superTooltipController!.addListener(_onChangeNotifier);

    // TD: Mouse stuff
    super.initState();
  }

  @override
  void didUpdateWidget(SuperTooltip oldWidget) {
    if (_superTooltipController != widget.controller) {
      _superTooltipController!.removeListener(_onChangeNotifier);
      if (oldWidget.controller == null) {
        _superTooltipController?.dispose();
      }
      _superTooltipController = widget.controller ?? SuperTooltipController();
      _superTooltipController!.addListener(_onChangeNotifier);
    }
    super.didUpdateWidget(oldWidget);
  }

  // @override
  @override
  void dispose() {
    if (_entry != null) _removeEntries();
    _superTooltipController?.removeListener(_onChangeNotifier);
    if (widget.controller == null) {
      _superTooltipController?.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    showCloseButton = widget.showCloseButton;
    closeButtonType = widget.closeButtonType;
    closeButtonColor = widget.closeButtonColor ?? Colors.black;
    closeButtonSize = widget.closeButtonSize ?? 30.0;
    barrierColor = widget.barrierColor ?? Colors.black54;
    hasShadow = widget.hasShadow ?? true;
    shadowColor = widget.shadowColor ?? Colors.black54;
    shadowBlurRadius = widget.shadowBlurRadius ?? 10.0;
    shadowSpreadRadius = widget.shadowSpreadRadius ?? 5.0;
    shadowOffset = widget.shadowOffset ?? Offset.zero;
    showBlur = widget.showDropBoxFilter;

    /// On native mobile platforms, this parameter is ignored as hover events are not supported.
    /// The widget reverts to standard barrier behavior (tap-to-dismiss) to prevent the
    /// tooltip from becoming unresponsive.
    var isNativeMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);

    if (isNativeMobile) {
      /// On native mobile platforms, this parameter is ignored as hover events are not supported.
      /// The widget reverts to standard barrier behavior (tap-to-dismiss) to prevent the
      /// tooltip from becoming unresponsive.
      showBarrier = widget.showBarrier ?? true;
    } else {
      /// On Web and Desktop, if [hideOnHoverExit] is true, the barrier is
      /// automatically disabled regardless of this value. This ensures that
      /// the barrier does not obstruct the mouse cursor from triggering the exit event.
      showBarrier = widget.hideOnHoverExit ? false : widget.showBarrier ?? true;
    }
    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      onEnter: (_) {
        if (widget.showOnHover) {
          if (!_superTooltipController!.isVisible) {
            _superTooltipController!.showTooltip();
          }
        }
      },
      onExit: (_) {
        if (widget.hideOnHoverExit) {
          if (_superTooltipController!.isVisible) {
            _superTooltipController!.hideTooltip();
          }
        }
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          onTap: () {
            if (widget.toggleOnTap && _superTooltipController!.isVisible) {
              _superTooltipController!.hideTooltip();
            } else {
              if (widget.showOnTap) {
                _superTooltipController!.showTooltip();
              }
            }
          },
          onLongPress: widget.onLongPress,
          child: widget.child,
        ),
      ),
    );
  }

  /// Called when the [_superTooltipController] notifies its listeners.
  ///
  /// This method is used to show or hide the tooltip based on the event type.
  /// If the event is [Event.show], the [_showTooltip] method is called. If the
  /// event is [Event.hide], the [_hideTooltip] method is called.
  void _onChangeNotifier() {
    switch (_superTooltipController!.event) {
      // Show the tooltip.
      case Event.show:
        _showTooltip();
        break;

      // Hide the tooltip.
      case Event.hide:
        _hideTooltip();
        break;
    }
  }

  /// Creates the overlay entries for the tooltip, barrier, and blur filter (if enabled).
  ///
  /// The overlay entries are inserted into the [Overlay] using the [OverlayState.insertAll] method.
  /// The order of insertion is: blur filter overlay entry, barrier overlay entry, and tooltip overlay entry.
  void _createOverlayEntries() {
    // Find the render box of the widget.
    final renderBox = context.findRenderObject() as RenderBox;

    // Find the overlay state.
    final overlayState = Overlay.of(context);

    // Find the overlay render box (if available).
    RenderBox? overlay;

    // ignore: unnecessary_null_comparison
    if (overlayState != null) {
      overlay = overlayState.context.findRenderObject() as RenderBox?;
    }

    // Calculate the size of the widget.
    final size = renderBox.size;

    // Calculate the target position relative to the global coordinate system.
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

    var preferredDirection =
        widget.popupDirectionBuilder?.call() ?? widget.popupDirection;
    var left = widget.left;
    var right = widget.right;
    var top = widget.top;
    var bottom = widget.bottom;

    if (widget.snapsFarAwayVertically) {
      constraints = constraints.copyWith(maxHeight: null);
      left = right = 0.0;

      if (overlay != null) {
        if (target.dy > overlay.size.center(Offset.zero).dy) {
          preferredDirection = TooltipDirection.up;
          top = 0.0;
        } else {
          preferredDirection = TooltipDirection.down;
          bottom = 0.0;
        }
      } else {
        // overlay is null - set default values
        preferredDirection = TooltipDirection.down;
        bottom = 0.0;
      }
    } else if (widget.snapsFarAwayHorizontally) {
      constraints = constraints.copyWith(maxHeight: null);

      top = bottom = 0.0;

      if (overlay != null) {
        if (target.dx < overlay.size.center(Offset.zero).dx) {
          preferredDirection = TooltipDirection.right;
          right = 0.0;
        } else {
          preferredDirection = TooltipDirection.left;
          left = 0.0;
        }
      } else {
        // overlay is null - set default values
        preferredDirection = TooltipDirection.left;
        left = 0.0;
      }
    }

    _barrierEntry = showBarrier
        ? OverlayEntry(
            builder: (context) => FadeTransition(
              opacity: animation,
              child: GestureDetector(
                onTap: widget.hideTooltipOnBarrierTap
                    ? _superTooltipController!.hideTooltip
                    : null,
                child: Container(
                  key: SuperTooltip.barrierKey,
                  decoration: ShapeDecoration(
                    shape: ShapeOverlay(
                      clipAreaCornerRadius: widget.touchThroughAreaCornerRadius,
                      clipAreaShape: widget.touchThroughAreaShape,
                      clipRect: widget.touchThroughArea,
                      barrierColor: barrierColor,
                      overlayDimensions: widget.overlayDimensions,
                    ),
                  ),
                ),
              ),
            ),
          )
        : null;

    blur = showBlur
        ? OverlayEntry(
            builder: (BuildContext context) => FadeTransition(
              opacity: animation,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: widget.sigmaX,
                  sigmaY: widget.sigmaY,
                ),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          )
        : null;
    _entry = OverlayEntry(
      builder: (BuildContext context) => IgnorePointer(
        ignoring: widget.clickThrough,
        child: FadeTransition(
          opacity: animation,
          child: Center(
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: offsetToTarget,
              child: CustomSingleChildLayout(
                delegate: SuperTooltipPositionDelegate(
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
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (widget.hideTooltipOnTap) {
                            _superTooltipController!.hideTooltip();
                          }
                        },
                        child: Container(
                          key: SuperTooltip.bubbleKey,
                          margin: SuperUtils.getTooltipMargin(
                            arrowLength: widget.arrowLength,
                            arrowTipDistance: widget.arrowTipDistance,
                            closeButtonSize: closeButtonSize,
                            preferredDirection: preferredDirection,
                            closeButtonType: closeButtonType,
                            showCloseButton: showCloseButton,
                          ),
                          padding: SuperUtils.getTooltipPadding(
                            closeButtonSize: closeButtonSize,
                            closeButtonType: closeButtonType,
                            showCloseButton: showCloseButton,
                          ),
                          decoration: widget.decorationBuilder != null
                              ? widget.decorationBuilder!(target)
                              : ShapeDecoration(
                                  color: backgroundColor,
                                  shadows: hasShadow
                                      ? widget.boxShadows ??
                                          <BoxShadow>[
                                            BoxShadow(
                                              blurRadius: shadowBlurRadius,
                                              spreadRadius: shadowSpreadRadius,
                                              color: shadowColor,
                                              offset: shadowOffset,
                                            ),
                                          ]
                                      : null,
                                  shape: BubbleShape(
                                    arrowBaseWidth: widget.arrowBaseWidth,
                                    arrowTipDistance: widget.arrowTipDistance,
                                    arrowTipRadius: widget.arrowTipRadius,
                                    borderColor: widget.borderColor,
                                    borderRadius: widget.borderRadius,
                                    borderWidth: widget.borderWidth,
                                    bottom: bottom,
                                    left: left,
                                    preferredDirection: preferredDirection,
                                    right: right,
                                    target: target,
                                    top: top,
                                    bubbleDimensions: widget.bubbleDimensions,
                                  ),
                                ),
                          child: widget.content,
                        ),
                      ),
                    ),
                    _buildCloseButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // ignore: unnecessary_null_comparison
    if (overlayState != null) {
      // Insert the overlay entries for the tooltip, barrier, and blur filter
      // (if enabled).
      overlayState.insertAll([
        // Insert the blur filter overlay entry if enabled.
        if (showBlur) blur!,

        // Insert the barrier overlay entry if enabled.
        if (showBarrier) _barrierEntry!,

        // Insert the tooltip overlay entry.
        _entry!,
      ]);
    }
  }

  /// Shows the tooltip.
  ///
  /// This method starts the fade-in animation and adds the overlay entries for
  /// the tooltip, barrier, and blur filter (if enabled).
  ///
  /// The [onShow] callback is called before the animation starts. After the
  /// animation completes, the [SuperTooltipController.complete] method is called
  /// to complete the show operation.
  ///
  /// If the tooltip is already visible, this method does nothing.
  Future<void> _showTooltip() async {
    // Call the onShow callback before the animation starts.
    widget.onShow?.call();

    // Already visible.
    if (_entry != null) return;

    // Create the overlay entries for the tooltip, barrier, and blur filter.
    _createOverlayEntries();

    // Start the fade-in animation and wait for it to complete.
    await _animationController
        .forward()
        .whenComplete(_superTooltipController!.complete);
  }

  /// Removes the overlay entries for the tooltip, barrier, and blur filter.
  ///
  /// This function removes the overlay entries for the tooltip, barrier, and
  /// blur filter. It sets the [_entry], [_barrierEntry], and [blur] variables to
  /// `null` after the removal.
  void _removeEntries() {
    // Remove the tooltip overlay entry.
    _entry?.remove();
    _entry = null;

    // Remove the barrier overlay entry.
    _barrierEntry?.remove();
    _barrierEntry = null;

    // Remove the blur filter overlay entry.
    blur?.remove();
    blur = null;
  }

  /// Hides the tooltip.
  ///
  /// This method starts the fade-out animation and removes the overlay entries
  /// for the tooltip, barrier, and blur filter (if enabled).
  ///
  /// The [onHide] callback is called before the animation starts. After the
  /// animation completes, the [SuperTooltipController.complete] method is called
  /// to complete the hide operation.
  ///
  /// Finally, the method removes the overlay entries for the tooltip, barrier, and
  /// blur filter.
  Future<void> _hideTooltip() async {
    // Call the onHide callback before the animation starts.
    widget.onHide?.call();

    // Start the fade-out animation and wait for it to complete.
    await _animationController
        .reverse()
        .whenComplete(_superTooltipController!.complete);

    // Remove the overlay entries for the tooltip, barrier, and blur filter.
    _removeEntries();
  }

  /// Builds the close button widget based on the tooltip's configuration and
  /// the current [TooltipDirection].
  ///
  /// The position of the close button is calculated based on the
  /// [closeButtonType] and the [TooltipDirection]. The close button is positioned
  /// within the tooltip's content area.
  ///
  /// Returns the close button widget wrapped in a [Positioned] widget.
  Widget _buildCloseButton() {
    // Return an empty widget if close button is not enabled.
    if (!showCloseButton) {
      return const SizedBox.shrink();
    }

    // Calculate the position of the close button based on the tooltip direction.
    double right;
    double top;

    switch (widget.popupDirectionBuilder?.call() ?? widget.popupDirection) {
      //
      // LEFT: -------------------------------------
      case TooltipDirection.left:
        right = widget.arrowLength + widget.arrowTipDistance + 3.0;
        if (closeButtonType == CloseButtonType.inside) {
          // If the close button is inside the tooltip, position it at the top.
          top = 2.0;
        } else if (closeButtonType == CloseButtonType.outside) {
          // If the close button is outside the tooltip, position it at the top.
          top = 0.0;
        } else {
          throw AssertionError(closeButtonType);
        }
        break;

      // RIGHT/UP: ---------------------------------
      case TooltipDirection.right:
      case TooltipDirection.up:
        right = 5.0;
        if (closeButtonType == CloseButtonType.inside) {
          // If the close button is inside the tooltip, position it at the top.
          top = 2.0;
        } else if (closeButtonType == CloseButtonType.outside) {
          // If the close button is outside the tooltip, position it at the top.
          top = 0.0;
        } else {
          throw AssertionError(closeButtonType);
        }
        break;

      // DOWN: -------------------------------------
      case TooltipDirection.down:
        right = 2.0;
        if (closeButtonType == CloseButtonType.inside) {
          // If the close button is inside the tooltip, position it below the arrow.
          top = widget.arrowLength + widget.arrowTipDistance + 2.0;
        } else if (closeButtonType == CloseButtonType.outside) {
          // If the close button is outside the tooltip, position it at the top.
          top = 0.0;
        } else {
          throw AssertionError(closeButtonType);
        }
        break;

      // ---------------------------------------------

      default:
        throw AssertionError(
          widget.popupDirectionBuilder?.call() ?? widget.popupDirection,
        );
    }

    // Wrap the close button in a [Positioned] widget to position it within
    // the tooltip's content area.
    return Positioned(
      right: right,
      top: top,
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          key: closeButtonType == CloseButtonType.inside
              ? SuperTooltip.insideCloseButtonKey
              : SuperTooltip.outsideCloseButtonKey,
          icon: Icon(
            Icons.close_outlined,
            size: closeButtonSize,
            color: closeButtonColor,
          ),
          onPressed: () async => await widget.controller!.hideTooltip(),
        ),
      ),
    );
  }
}
