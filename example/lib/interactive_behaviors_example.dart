import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class InteractiveBehaviorsExample extends StatefulWidget {
  const InteractiveBehaviorsExample({Key? key}) : super(key: key);

  @override
  State<InteractiveBehaviorsExample> createState() =>
      _InteractiveBehaviorsExampleState();
}

class _InteractiveBehaviorsExampleState
    extends State<InteractiveBehaviorsExample> {
  final _hoverController = SuperTooltipController();
  final _autoDismissController = SuperTooltipController();
  final _toggleController = SuperTooltipController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interactive Behaviors')),
      body: Center(
        child: Wrap(
          spacing: 40,
          runSpacing: 60,
          alignment: WrapAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Hover to Show'),
                const SizedBox(height: 8),
                SuperTooltip(
                  controller: _hoverController,
                  interactionConfig: const InteractionConfiguration(
                    showOnHover: true,
                    hideOnHoverExit: true,
                  ),
                  animationConfig: const AnimationConfiguration(
                    waitDuration: Duration(milliseconds: 500),
                  ),
                  content: const Text(
                    'I appear on hover!',
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Container(
                    width: 80,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Hover Me',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Auto Dismiss (3s)'),
                const SizedBox(height: 8),
                SuperTooltip(
                  controller: _autoDismissController,
                  animationConfig: const AnimationConfiguration(
                    showDuration: Duration(seconds: 3),
                  ),
                  content: const Text(
                    'I close automatically!',
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Container(
                    width: 80,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Tap Me',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Toggle On/Off'),
                const SizedBox(height: 8),
                SuperTooltip(
                  controller: _toggleController,
                  interactionConfig: const InteractionConfiguration(
                    toggleOnTap: true,
                    hideOnBarrierTap: false,
                  ),
                  content: const Text(
                    'Tap again to close!',
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Container(
                    width: 80,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Toggle',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
