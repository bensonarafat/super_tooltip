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
    Key key,
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
  const TargetWidget({Key key}) : super(key: key);

  @override
  _TargetWidgetState createState() => new _TargetWidgetState();
}

class _TargetWidgetState extends State<TargetWidget> {
  SuperTooltip tooltip;

  Future<bool> _willPopCallback() async {
    if (tooltip.isOpen) {
      tooltip.close();
      return false; // return true if the route to be popped
    }
    return true;
  }

  void onTap() {
    if (tooltip != null && tooltip.isOpen) {
      tooltip.close();
      return;
    }

    RenderBox renderBox = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    var targetGlobalCenter =
        renderBox.localToGlobal(renderBox.size.center(Offset.zero), ancestor: overlay);

    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.down,
      content: new Material(
          child: Text(
            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, "
            "sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, "
            "sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ",
        softWrap: true,
      )),
    );

    tooltip.show(context);
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
