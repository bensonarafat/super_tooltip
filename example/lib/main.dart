import 'dart:async';

import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.red,
      body: new Center(child: TargetWidget()),
    );
  }
}

class TargetWidget extends StatefulWidget {
  const TargetWidget({Key? key}) : super(key: key);

  @override
  _TargetWidgetState createState() => new _TargetWidgetState();
}

class _TargetWidgetState extends State<TargetWidget> {
  SuperTooltip? tooltip;

  Future<bool> _willPopCallback() async {
    // If the tooltip is open we don't pop the page on a backbutton press
    // but close the ToolTip
    if (tooltip!.isOpen) {
      tooltip!.close();
      return false;
    }
    return true;
  }

  void onTap() {
    if (tooltip != null && tooltip!.isOpen) {
      tooltip!.close();
      return;
    }

    var renderBox = context.findRenderObject() as RenderBox;
    final overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox?;

    var targetGlobalCenter = renderBox
        .localToGlobal(renderBox.size.center(Offset.zero), ancestor: overlay);

    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.left,
      arrowTipDistance: 15.0,
      arrowBaseWidth: 40.0,
      arrowLength: 40.0,
      borderColor: Colors.green,
      borderWidth: 5.0,
      showCloseButton: ShowCloseButton.inside,
      hasShadow: true,
      shadowOffset: Offset(10, 10),
      touchThrougArea: new Rect.fromLTWH(targetGlobalCenter.dx - 100,
          targetGlobalCenter.dy - 100, 200.0, 160.0),
      touchThroughAreaShape: ClipAreaShape.rectangle,
      content: new Material(
          child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, "
          "sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, "
          "sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ",
          softWrap: true,
        ),
      )),
    );

    tooltip!.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _willPopCallback,
      child: new GestureDetector(
        onTap: onTap,
        child: Container(
            width: 20.0,
            height: 20.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            )),
      ),
    );
  }
}
