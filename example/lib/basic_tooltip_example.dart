import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class BasicTooltipExample extends StatefulWidget {
  const BasicTooltipExample({Key? key}) : super(key: key);

  @override
  State<BasicTooltipExample> createState() => _BasicTooltipExampleState();
}

class _BasicTooltipExampleState extends State<BasicTooltipExample> {
  final _controller = SuperTooltipController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Tooltip')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Tap the icon below',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SuperTooltip(
              controller: _controller,
              content: const Text(
                "This is a simple tooltip with default styling!",
                softWrap: true,
                style: TextStyle(color: Colors.white),
              ),
              child: Container(
                width: 60.0,
                height: 60.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: const Icon(
                  Icons.info,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
