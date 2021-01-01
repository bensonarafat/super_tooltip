import 'dart:async';

import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(child: TargetWidget()),
    );
  }
}

class TargetWidget extends StatefulWidget {
  const TargetWidget({Key key}) : super(key: key);

  @override
  _TargetWidgetState createState() => _TargetWidgetState();
}

class _TargetWidgetState extends State<TargetWidget> {
  final _controller = SuperTooltipController();
  SuperTooltip tooltip;

  Future<bool> _willPopCallback() async {
    // If the tooltip is open we don't pop the page on a backbutton press
    // but close the ToolTip
    if (_controller.isVisible) {
      await _controller.hideTooltip();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // var renderBox = context.findRenderObject() as RenderBox;
    // final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    // var targetGlobalCenter =
    //     renderBox.localToGlobal(renderBox.size.center(Offset.zero), ancestor: overlay);

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: GestureDetector(
        onTap: () async {
          await _controller.showTooltip();
        },
        child: SuperTooltip(
          controller: _controller,
          preferredDirection: PreferredDirection.up,
          left: 0,
          arrowTipDistance: 15.0,
          arrowBaseWidth: 20.0,
          arrowLength: 20.0,
          borderColor: Colors.green,
          borderWidth: 2.0,
          constraints: const BoxConstraints(
            minHeight: 0.0,
            maxHeight: 100,
            minWidth: 0.0,
            maxWidth: 100,
          ),
          // snapsFarAwayVertically: true,
          showCloseButton: ShowCloseButton.inside,
          // hasShadow: false,
          // touchThrougArea: Rect.fromLTWH(
          //     targetGlobalCenter.dx - 100, targetGlobalCenter.dy - 100, 200.0, 160.0),
          touchThroughAreaShape: ClipAreaShape.rectangle,
          content: Text(
            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, "
            "sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, "
            "sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ",
            softWrap: true,
          ),

          child: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
