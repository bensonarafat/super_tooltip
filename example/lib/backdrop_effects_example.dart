import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class BackdropEffectsExample extends StatefulWidget {
  const BackdropEffectsExample({Key? key}) : super(key: key);

  @override
  State<BackdropEffectsExample> createState() => _BackdropEffectsExampleState();
}

class _BackdropEffectsExampleState extends State<BackdropEffectsExample> {
  final _withBarrierController = SuperTooltipController();
  final _withBlurController = SuperTooltipController();
  final _noBarrierController = SuperTooltipController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backdrop Effects')),
      body: Stack(
        children: [
          // Background image/content
          Positioned.fill(
            child: Image.network(
              'https://picsum.photos/400/800',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image, size: 100, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          Center(
            child: Wrap(
              spacing: 30,
              runSpacing: 30,
              alignment: WrapAlignment.center,
              children: [
                _buildBackdropTooltip(
                  controller: _withBarrierController,
                  barrierConfig: const BarrierConfiguration(
                    show: true,
                    color: Colors.black54,
                  ),
                  label: 'Dark Barrier',
                ),
                _buildBackdropTooltip(
                  controller: _withBlurController,
                  barrierConfig: const BarrierConfiguration(
                    show: true,
                    color: Colors.black26,
                    showBlur: true,
                    sigmaX: 10.0,
                    sigmaY: 10.0,
                  ),
                  label: 'Blur Effect',
                ),
                _buildBackdropTooltip(
                  controller: _noBarrierController,
                  barrierConfig: const BarrierConfiguration(
                    show: false,
                  ),
                  label: 'No Barrier',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackdropTooltip({
    required SuperTooltipController controller,
    required BarrierConfiguration barrierConfig,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(label, style: const TextStyle(fontSize: 12)),
        ),
        const SizedBox(height: 8),
        SuperTooltip(
          controller: controller,
          barrierConfig: barrierConfig,
          style: const TooltipStyle(
            backgroundColor: Colors.white,
            hasShadow: true,
            shadowBlurRadius: 20.0,
          ),
          content: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              barrierConfig.showBlur
                  ? 'Background is blurred'
                  : barrierConfig.show
                      ? 'Background is darkened'
                      : 'No backdrop effect',
              style: const TextStyle(color: Colors.black),
            ),
          ),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.visibility, size: 30),
          ),
        ),
      ],
    );
  }
}
