import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_tooltip/super_tooltip.dart';

const Key targetWidgetKey = Key('targetWidget');

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
    this.hasShadow,
    this.shadowColor,
    this.shadowBlurRadius,
    this.shadowSpreadRadius,
  }) : super(key: key);

  final bool hasShadow;
  final Color shadowColor;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;

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
          hasShadow: widget.hasShadow,
          shadowColor: widget.shadowColor,
          shadowBlurRadius: widget.shadowBlurRadius,
          shadowSpreadRadius: widget.shadowSpreadRadius,
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
        home: HomePage(
          hasShadow: null,
          shadowColor: null,
          shadowBlurRadius: null,
          shadowSpreadRadius: null,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(targetWidgetKey));
      await tester.pumpAndSettle();

      expect(find.byKey(SuperTooltip.insideCloseButtonKey), findsNothing);
      expect(find.byKey(SuperTooltip.outsideCloseButtonKey), findsNothing);
    },
  );

  group('hasShadow option', () {
    testWidgets(
      'shadow should be displayed by default',
      (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: HomePage()));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(targetWidgetKey));
        await tester.pumpAndSettle();

        final tooltipBubble = find.byKey(SuperTooltip.bubbleKey);
        expect(tooltipBubble, findsOneWidget);

        final container = tester.widget<Container>(tooltipBubble);
        final decoration = container.decoration as ShapeDecoration;
        final shadows = decoration.shadows;
        expect(shadows, isNotEmpty);
      },
    );

    testWidgets(
      'shadow should be not displayed if hasShadow is false',
      (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: HomePage(hasShadow: false)));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(targetWidgetKey));
        await tester.pumpAndSettle();

        final tooltipBubble = find.byKey(SuperTooltip.bubbleKey);
        expect(tooltipBubble, findsOneWidget);

        final container = tester.widget<Container>(tooltipBubble);
        final decoration = container.decoration as ShapeDecoration;
        final shadows = decoration.shadows;
        expect(shadows, isNull);
      },
    );

    group('shadowColor option', () {
      testWidgets(
        'shadow-color should be black by default',
        (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(home: HomePage(hasShadow: true)));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(targetWidgetKey));
          await tester.pumpAndSettle();

          final tooltipBubble = find.byKey(SuperTooltip.bubbleKey);
          expect(tooltipBubble, findsOneWidget);

          final container = tester.widget<Container>(tooltipBubble);
          final decoration = container.decoration as ShapeDecoration;
          final shadows = decoration.shadows;
          expect(shadows[0].color, equals(Colors.black54));
        },
      );

      testWidgets(
        'shadow-color should be equal to given color',
        (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(
            home: HomePage(
              hasShadow: true,
              shadowColor: Colors.green,
            ),
          ));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(targetWidgetKey));
          await tester.pumpAndSettle();

          final tooltipBubble = find.byKey(SuperTooltip.bubbleKey);
          expect(tooltipBubble, findsOneWidget);

          final container = tester.widget<Container>(tooltipBubble);
          final decoration = container.decoration as ShapeDecoration;
          final shadows = decoration.shadows;
          expect(shadows[0].color, equals(Colors.green));
        },
      );
    });

    group('shadowBlurRadius option', () {
      testWidgets(
        'Blur-radius should be equal to 10.0 by default',
        (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(home: HomePage(hasShadow: true)));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(targetWidgetKey));
          await tester.pumpAndSettle();

          final tooltipBubble = find.byKey(SuperTooltip.bubbleKey);
          expect(tooltipBubble, findsOneWidget);

          final container = tester.widget<Container>(tooltipBubble);
          final decoration = container.decoration as ShapeDecoration;
          final shadows = decoration.shadows;
          expect(shadows[0].blurRadius, equals(10.0));
        },
      );

      testWidgets(
        'Blur-radius should be equal to given value',
        (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(
            home: HomePage(
              hasShadow: true,
              shadowBlurRadius: 20.0,
            ),
          ));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(targetWidgetKey));
          await tester.pumpAndSettle();

          final tooltipBubble = find.byKey(SuperTooltip.bubbleKey);
          expect(tooltipBubble, findsOneWidget);

          final container = tester.widget<Container>(tooltipBubble);
          final decoration = container.decoration as ShapeDecoration;
          final shadows = decoration.shadows;
          expect(shadows[0].blurRadius, equals(20.0));
        },
      );
    });

    group('shadowSpreadRadius option', () {
      testWidgets(
        'Spread-radius should be equal to 5.0 by default',
        (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(home: HomePage(hasShadow: true)));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(targetWidgetKey));
          await tester.pumpAndSettle();

          final tooltipBubble = find.byKey(SuperTooltip.bubbleKey);
          expect(tooltipBubble, findsOneWidget);

          final container = tester.widget<Container>(tooltipBubble);
          final decoration = container.decoration as ShapeDecoration;
          final shadows = decoration.shadows;
          expect(shadows[0].spreadRadius, equals(5.0));
        },
      );

      testWidgets(
        'Spread-radius should be equal to given value',
        (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(
            home: HomePage(
              hasShadow: true,
              shadowSpreadRadius: 10.0,
            ),
          ));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(targetWidgetKey));
          await tester.pumpAndSettle();

          final tooltipBubble = find.byKey(SuperTooltip.bubbleKey);
          expect(tooltipBubble, findsOneWidget);

          final container = tester.widget<Container>(tooltipBubble);
          final decoration = container.decoration as ShapeDecoration;
          final shadows = decoration.shadows;
          expect(shadows[0].spreadRadius, equals(10.0));
        },
      );
    });
  });
}
