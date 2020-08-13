import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_tooltip/super_tooltip.dart';

const Key targetWidgetKey = Key('targetWidget');

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
    this.showBarrier,
    this.barrierColor,
  }) : super(key: key);

  final bool showBarrier;
  final Color barrierColor;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = SuperTooltipController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SuperTooltip(
          controller: _controller,
          preferredDirection: PreferredDirection.down,
          showBarrier: widget.showBarrier,
          barrierColor: widget.barrierColor,
          content: const Material(child: Text('Lorem ipsum...')),
          child: Container(
            key: targetWidgetKey,
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets(
    'SuperTooltip should handle null options gracefully',
    (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: HomePage(showBarrier: null, barrierColor: null),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(targetWidgetKey));
      await tester.pumpAndSettle();

      expect(find.byKey(SuperTooltip.insideCloseButtonKey), findsNothing);
      expect(find.byKey(SuperTooltip.outsideCloseButtonKey), findsNothing);
    },
  );

  group('barrierColor option', () {
    testWidgets('barrier-color should be black by default', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomePage(showBarrier: true)));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(targetWidgetKey));
      await tester.pumpAndSettle();

      final barrier = find.byKey(SuperTooltip.barrierKey);
      await expectLater(barrier, matchesGoldenFile('barrier_color_default.png'));
    });

    testWidgets('barrier-color should be equal to given color',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: HomePage(
          showBarrier: true,
          barrierColor: Colors.blue,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(targetWidgetKey));
      await tester.pumpAndSettle();

      final barrier = find.byKey(SuperTooltip.barrierKey);
      await expectLater(barrier, matchesGoldenFile('barrier_color_blue.png'));
    });
  });
}
