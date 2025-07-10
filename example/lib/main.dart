import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Tooltip Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({
    Key? key,
  }) : super(key: key);
  @override
  State createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: TargetWidget(),
      ),
    );
  }
}

class TargetWidget extends StatefulWidget {
  const TargetWidget({Key? key}) : super(key: key);

  @override
  State createState() => _TargetWidgetState();
}

class _TargetWidgetState extends State<TargetWidget> {
  final _controller = SuperTooltipController();
  Future<bool>? _willPopCallback() async {
    // If the tooltip is open we don't pop the page on a backbutton press
    // but close the ToolTip
    if (_controller.isVisible) {
      await _controller.hideTooltip();
      return false;
    }
    return true;
  }

  TooltipDirection _tooltipDirection = TooltipDirection.left;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => _willPopCallback,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SuperTooltip(
            controller: _controller,
            popupDirection: TooltipDirection.left,
            popupDirectionBuilder: () {
              return _tooltipDirection;
            },
            backgroundColor: Color(0xff2f2d2f),
            showCloseButton: true,
            left: 30,
            right: 30,
            bottom: 200,
            arrowTipDistance: 20.0,
            minimumOutsideMargin: 120,
            arrowBaseWidth: 20.0,
            arrowLength: 20.0,
            borderWidth: 2.0,
            constraints: const BoxConstraints(
              minHeight: 0.0,
              maxHeight: 870,
              minWidth: 0.0,
              maxWidth: 402,
            ),
            touchThroughAreaShape: ClipAreaShape.rectangle,
            touchThroughAreaCornerRadius: 30,
            barrierColor: Color.fromARGB(26, 47, 45, 47),
            content: const Text(
              "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.",
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            child: Container(
              width: 40.0,
              height: 40.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _tooltipDirection = TooltipDirection.left;
                  },
                  icon: Icon(
                    Icons.arrow_left,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _tooltipDirection = TooltipDirection.right;
                  },
                  icon: Icon(
                    Icons.arrow_right,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
