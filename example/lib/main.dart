import 'package:flutter/material.dart';
import 'package:super_tooltip_example/auto_direction_example.dart';
import 'package:super_tooltip_example/backdrop_effects_example.dart';
import 'package:super_tooltip_example/basic_tooltip_example.dart';
import 'package:super_tooltip_example/close_buton_example.dart';
import 'package:super_tooltip_example/complex_content_example.dart';
import 'package:super_tooltip_example/custom_styled_example.dart';
import 'package:super_tooltip_example/directional_example.dart';
import 'package:super_tooltip_example/interactive_behaviors_example.dart';
import 'package:super_tooltip_example/multiple_tooltip_example.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Tooltip Examples',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ExamplesHomePage(),
    );
  }
}

class ExamplesHomePage extends StatelessWidget {
  const ExamplesHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SuperTooltip Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ExampleCard(
            title: '1. Basic Tooltip',
            description: 'Simple tooltip with default styling',
            onTap: () => _navigate(context, const BasicTooltipExample()),
          ),
          _ExampleCard(
            title: '2. Auto Direction',
            description: 'Tooltip that automatically positions itself',
            onTap: () => _navigate(context, const AutoDirectionExample()),
          ),
          _ExampleCard(
            title: '3. Custom Styled',
            description: 'Colorful tooltips with custom styling',
            onTap: () => _navigate(context, const CustomStyledExample()),
          ),
          _ExampleCard(
            title: '4. With Close Button',
            description: 'Tooltips with inside and outside close buttons',
            onTap: () => _navigate(context, const CloseButtonExample()),
          ),
          _ExampleCard(
            title: '5. Different Directions',
            description: 'Tooltips in all four directions',
            onTap: () => _navigate(context, const DirectionalExample()),
          ),
          _ExampleCard(
            title: '6. Backdrop Effects',
            description: 'Tooltips with barriers and blur effects',
            onTap: () => _navigate(context, const BackdropEffectsExample()),
          ),
          _ExampleCard(
            title: '7. Interactive Behaviors',
            description: 'Hover, tap, and auto-dismiss behaviors',
            onTap: () =>
                _navigate(context, const InteractiveBehaviorsExample()),
          ),
          _ExampleCard(
            title: '8. Complex Content',
            description: 'Tooltips with rich content and actions',
            onTap: () => _navigate(context, const ComplexContentExample()),
          ),
          _ExampleCard(
            title: '9. All Together',
            description: 'Multiple tooltips on one screen',
            onTap: () => _navigate(context, const MultipleTooltipsExample()),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ExampleCard({
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
