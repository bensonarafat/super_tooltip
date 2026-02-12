import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class AutoDirectionExample extends StatefulWidget {
  const AutoDirectionExample({Key? key}) : super(key: key);

  @override
  State<AutoDirectionExample> createState() => _AutoDirectionExampleState();
}

class _AutoDirectionExampleState extends State<AutoDirectionExample> {
  final _topController = SuperTooltipController();
  final _bottomController = SuperTooltipController();
  final _centerController = SuperTooltipController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auto Direction')),
      body: Column(
        children: [
          // Top corner
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.topLeft,
              child: _buildAutoTooltip(
                _topController,
                'Top Corner',
                'I automatically show below!',
                Icons.arrow_downward,
              ),
            ),
          ),
          const Spacer(),
          // Center
          _buildAutoTooltip(
            _centerController,
            'Center',
            'I can go in any direction!',
            Icons.all_out,
          ),
          const Spacer(),
          // Bottom corner
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: _buildAutoTooltip(
                _bottomController,
                'Bottom Corner',
                'I automatically show above!',
                Icons.arrow_upward,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoTooltip(
    SuperTooltipController controller,
    String label,
    String message,
    IconData icon,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        SuperTooltip(
          controller: controller,
          positionConfig: const PositionConfiguration(
            preferredDirection: TooltipDirection.auto,
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
