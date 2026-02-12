import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class CustomStyledExample extends StatefulWidget {
  const CustomStyledExample({Key? key}) : super(key: key);

  @override
  State<CustomStyledExample> createState() => _CustomStyledExampleState();
}

class _CustomStyledExampleState extends State<CustomStyledExample> {
  final _redController = SuperTooltipController();
  final _greenController = SuperTooltipController();
  final _blueController = SuperTooltipController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Styled Tooltips')),
      body: Center(
        child: Wrap(
          spacing: 30,
          runSpacing: 30,
          alignment: WrapAlignment.center,
          children: [
            _buildStyledTooltip(
              controller: _redController,
              color: Colors.red,
              label: 'Error Style',
              message: 'This is an error tooltip with custom styling!',
              icon: Icons.error,
            ),
            _buildStyledTooltip(
              controller: _greenController,
              color: Colors.green,
              label: 'Success Style',
              message: 'This is a success tooltip with rounded corners!',
              icon: Icons.check_circle,
            ),
            _buildStyledTooltip(
              controller: _blueController,
              color: Colors.blue,
              label: 'Info Style',
              message: 'This is an info tooltip with a border!',
              icon: Icons.info,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledTooltip({
    required SuperTooltipController controller,
    required Color color,
    required String label,
    required String message,
    required IconData icon,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        SuperTooltip(
          controller: controller,
          style: TooltipStyle(
            backgroundColor: color,
            borderColor: color.withValues(alpha: 0.5),
            borderWidth: 3.0,
            borderRadius: 15.0,
            hasShadow: true,
            shadowColor: color.withValues(alpha: 0.3),
            shadowBlurRadius: 20.0,
            bubbleDimensions: const EdgeInsets.all(8),
          ),
          arrowConfig: const ArrowConfiguration(
            length: 15.0,
            baseWidth: 25.0,
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ),
      ],
    );
  }
}
