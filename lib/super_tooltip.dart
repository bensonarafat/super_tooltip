library super_tooltip;

export 'src/enums.dart';
export 'src/super_tooltip.dart';
export 'src/super_tooltip_controller.dart';

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
