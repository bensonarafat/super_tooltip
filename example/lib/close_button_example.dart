import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class CloseButtonExample extends StatefulWidget {
  const CloseButtonExample({Key? key}) : super(key: key);

  @override
  State<CloseButtonExample> createState() => _CloseButtonExampleState();
}

class _CloseButtonExampleState extends State<CloseButtonExample> {
  final _insideController = SuperTooltipController();
  final _outsideController = SuperTooltipController();
  final _noButtonController = SuperTooltipController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Close Button Examples')),
      body: Center(
        child: Wrap(
          spacing: 40,
          runSpacing: 40,
          alignment: WrapAlignment.center,
          children: [
            _buildCloseButtonTooltip(
              controller: _insideController,
              closeButtonConfig: const CloseButtonConfiguration(
                show: true,
                type: CloseButtonType.inside,
                color: Colors.white,
                size: 24,
              ),
              label: 'Inside Button',
              color: Colors.deepPurple,
            ),
            _buildCloseButtonTooltip(
              controller: _outsideController,
              closeButtonConfig: const CloseButtonConfiguration(
                show: true,
                type: CloseButtonType.outside,
                color: Colors.white,
                size: 24,
              ),
              label: 'Outside Button',
              color: Colors.orange,
            ),
            _buildCloseButtonTooltip(
              controller: _noButtonController,
              closeButtonConfig: const CloseButtonConfiguration(
                show: false,
              ),
              label: 'No Button',
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButtonTooltip({
    required SuperTooltipController controller,
    required CloseButtonConfiguration closeButtonConfig,
    required String label,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        SuperTooltip(
          controller: controller,
          closeButtonConfig: closeButtonConfig,
          style: TooltipStyle(backgroundColor: color),
          content: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              closeButtonConfig.show
                  ? 'Tap the X button to close'
                  : 'Tap outside to close',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.touch_app, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
