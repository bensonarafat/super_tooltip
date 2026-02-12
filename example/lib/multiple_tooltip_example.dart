import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class MultipleTooltipsExample extends StatefulWidget {
  const MultipleTooltipsExample({Key? key}) : super(key: key);

  @override
  State<MultipleTooltipsExample> createState() =>
      _MultipleTooltipsExampleState();
}

class _MultipleTooltipsExampleState extends State<MultipleTooltipsExample> {
  final _tooltip1 = SuperTooltipController();
  final _tooltip2 = SuperTooltipController();
  final _tooltip3 = SuperTooltipController();
  final _tooltip4 = SuperTooltipController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multiple Tooltips')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconTooltip(
                  _tooltip1,
                  Icons.favorite,
                  Colors.red,
                  'Like this',
                ),
                _buildIconTooltip(
                  _tooltip2,
                  Icons.share,
                  Colors.blue,
                  'Share this',
                ),
                _buildIconTooltip(
                  _tooltip3,
                  Icons.bookmark,
                  Colors.orange,
                  'Save this',
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Product Title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  '\$99.99',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                SuperTooltip(
                  controller: _tooltip4,
                  positionConfig: const PositionConfiguration(
                    preferredDirection: TooltipDirection.up,
                  ),
                  style: const TooltipStyle(backgroundColor: Colors.green),
                  content: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '20% discount applied!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'SALE',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconTooltip(
    SuperTooltipController controller,
    IconData icon,
    Color color,
    String message,
  ) {
    return SuperTooltip(
      controller: controller,
      positionConfig: const PositionConfiguration(
        preferredDirection: TooltipDirection.down,
      ),
      style: TooltipStyle(backgroundColor: color),
      arrowConfig: const ArrowConfiguration(length: 10),
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}
