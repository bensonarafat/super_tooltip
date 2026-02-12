import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class DirectionalExample extends StatefulWidget {
  const DirectionalExample({Key? key}) : super(key: key);

  @override
  State<DirectionalExample> createState() => _DirectionalExampleState();
}

class _DirectionalExampleState extends State<DirectionalExample> {
  final _upController = SuperTooltipController();
  final _downController = SuperTooltipController();
  final _leftController = SuperTooltipController();
  final _rightController = SuperTooltipController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Directional Tooltips')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDirectionalTooltip(
              _upController,
              TooltipDirection.up,
              'Up',
              Icons.arrow_upward,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDirectionalTooltip(
                  _leftController,
                  TooltipDirection.left,
                  'Left',
                  Icons.arrow_back,
                ),
                const SizedBox(width: 80),
                _buildDirectionalTooltip(
                  _rightController,
                  TooltipDirection.right,
                  'Right',
                  Icons.arrow_forward,
                ),
              ],
            ),
            const SizedBox(height: 40),
            _buildDirectionalTooltip(
              _downController,
              TooltipDirection.down,
              'Down',
              Icons.arrow_downward,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionalTooltip(
    SuperTooltipController controller,
    TooltipDirection direction,
    String label,
    IconData icon,
  ) {
    return SuperTooltip(
      controller: controller,
      positionConfig: PositionConfiguration(
        preferredDirection: direction,
      ),
      style: const TooltipStyle(backgroundColor: Colors.indigo),
      content: Text(
        'Tooltip pointing $label',
        style: const TextStyle(color: Colors.white),
      ),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
