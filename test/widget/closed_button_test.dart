import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_tooltip/super_tooltip.dart';

const Key targetWidgetKey = Key('targetWidget');

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
    this.showCloseButton,
    this.closeButtonColor,
    this.closeButtonSize,
  }) : super(key: key);

  final ShowCloseButton showCloseButton;
  final Color closeButtonColor;
  final double closeButtonSize;

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
          showCloseButton: widget.showCloseButton,
          closeButtonColor: widget.closeButtonColor,
          closeButtonSize: widget.closeButtonSize,
          content: const Material(child: Text('Lorem ipsum...')),
          child: Container(
            key: targetWidgetKey,
            width: 40.0,
            height: 40.0,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
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
          showCloseButton: null,
          closeButtonColor: null,
          closeButtonSize: null,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(targetWidgetKey));
      await tester.pumpAndSettle();

      expect(find.byKey(SuperTooltip.insideCloseButtonKey), findsNothing);
      expect(find.byKey(SuperTooltip.outsideCloseButtonKey), findsNothing);
    },
  );

  group('showCloseButton option', () {
    testWidgets(
      'Close-button should not be displayed by default',
      (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: HomePage()));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(targetWidgetKey));
        await tester.pumpAndSettle();

        expect(find.byKey(SuperTooltip.insideCloseButtonKey), findsNothing);
        expect(find.byKey(SuperTooltip.outsideCloseButtonKey), findsNothing);
      },
    );

    testWidgets(
      'Close-button should not be displayed for ShowCloseButton.none value',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: HomePage(showCloseButton: ShowCloseButton.none)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(targetWidgetKey));
        await tester.pumpAndSettle();

        expect(find.byKey(SuperTooltip.insideCloseButtonKey), findsNothing);
        expect(find.byKey(SuperTooltip.outsideCloseButtonKey), findsNothing);
      },
    );

    testWidgets(
      'Close-button should be displayed inside of tooltip bubble for ShowCloseButton.inside value',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: HomePage(showCloseButton: ShowCloseButton.inside)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(targetWidgetKey));
        await tester.pumpAndSettle();

        expect(find.byKey(SuperTooltip.insideCloseButtonKey), findsOneWidget);
        expect(find.byKey(SuperTooltip.outsideCloseButtonKey), findsNothing);
      },
    );

    testWidgets(
      'Close-button should be displayed inside of tooltip bubble for ShowCloseButton.outside value',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: HomePage(showCloseButton: ShowCloseButton.outside)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(targetWidgetKey));
        await tester.pumpAndSettle();

        expect(find.byKey(SuperTooltip.insideCloseButtonKey), findsNothing);
        expect(find.byKey(SuperTooltip.outsideCloseButtonKey), findsOneWidget);
      },
    );
  });

  group('closeButtonColor option', () {
    testWidgets(
      'Close-button color should be black by default',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: HomePage(showCloseButton: ShowCloseButton.inside)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(targetWidgetKey));
        await tester.pumpAndSettle();

        final insideCloseButton = find.byKey(SuperTooltip.insideCloseButtonKey);
        expect(insideCloseButton, findsOneWidget);

        final button = tester.widget<IconButton>(insideCloseButton);
        final icon = button.icon as Icon;
        expect(icon.color, equals(Colors.black));

        expect(find.byKey(SuperTooltip.outsideCloseButtonKey), findsNothing);
      },
    );

    testWidgets(
      'Close-button color should be equal to given value',
      (WidgetTester tester) async {
        final buttonColor = Colors.green;

        await tester.pumpWidget(
          MaterialApp(
              home: HomePage(
            showCloseButton: ShowCloseButton.inside,
            closeButtonColor: buttonColor,
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(targetWidgetKey));
        await tester.pumpAndSettle();

        final insideCloseButton = find.byKey(SuperTooltip.insideCloseButtonKey);
        expect(insideCloseButton, findsOneWidget);

        final button = tester.widget<IconButton>(insideCloseButton);
        final icon = button.icon as Icon;
        expect(icon.color, equals(buttonColor));

        expect(find.byKey(SuperTooltip.outsideCloseButtonKey), findsNothing);
      },
    );
  });

  group('closeButtonSize option', () {
    testWidgets(
      'Close-button size should be 30.0 by default',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: HomePage(showCloseButton: ShowCloseButton.inside)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(targetWidgetKey));
        await tester.pumpAndSettle();

        final insideCloseButton = find.byKey(SuperTooltip.insideCloseButtonKey);
        expect(insideCloseButton, findsOneWidget);

        final button = tester.widget<IconButton>(insideCloseButton);
        final icon = button.icon as Icon;
        expect(icon.size, equals(30.0));

        expect(find.byKey(SuperTooltip.outsideCloseButtonKey), findsNothing);
      },
    );

    testWidgets(
      'Close-button size should be equal to given value',
      (WidgetTester tester) async {
        final buttonColor = Colors.green;

        await tester.pumpWidget(
          MaterialApp(
            home: HomePage(
              showCloseButton: ShowCloseButton.inside,
              closeButtonColor: buttonColor,
              closeButtonSize: 20.0,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(targetWidgetKey));
        await tester.pumpAndSettle();

        final insideCloseButton = find.byKey(SuperTooltip.insideCloseButtonKey);
        expect(insideCloseButton, findsOneWidget);

        final button = tester.widget<IconButton>(insideCloseButton);
        final icon = button.icon as Icon;
        expect(icon.size, equals(20.0));

        expect(find.byKey(SuperTooltip.outsideCloseButtonKey), findsNothing);
      },
    );
  });
}
