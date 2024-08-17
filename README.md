# super_tooltip

[![Static code analysis](https://github.com/bensonarafat/super_tooltip/actions/workflows/dart.yml/badge.svg)](https://github.com/bensonarafat/super_tooltip/actions/workflows/dart.yml)
[![pub package](https://img.shields.io/pub/v/super_tooltip.svg)](https://pub.dartlang.org/packages/super_tooltip)

`SuperTooltip` It is super flexible and allows you to display ToolTips in the overlay of the screen. It gives you more flexibility over the Flutter standard `Tooltip`. You have the option to make the whole screen covered with a background color. Tapping on the background closes the Tooltip.

<img src="https://github.com/bensonarafat/super_tooltip/blob/master/screenshots/screenshot1.gif?raw=true" width="250"/>

## Installing

Run this command:

With Flutter:

```
 flutter pub add super_tooltip
```

This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

```
dependencies:
  super_tooltip: latest
```

Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

Now in your Dart code, you can use:

```
import 'package:super_tooltip/super_tooltip.dart';
```

# Getting Started

You have to make your Widget a `StatefulWidget` and you just need to create a controller to manage state of tooltips, you can do so by defining an instance of a `SuperTooltipController` and pass it through to constructor.

```dart
  final _controller = SuperTooltipController();

  child: SuperTooltip(
    _controller: tooltipController,
    // ...
    )

    void makeTooltip() {
        _controller.showTooltip();
    }
```

You need to wrap `SuperTooltip` with a `GestureDetector`, `MouseRegion` or `InkWell` that is responsible for showing and hiding the content. Further handling of the tooltip state can be managed explicitly through a controller

```dart
    child: GestureDetector(
      onTap: () async {
        await _controller.showTooltip();
      },
      child: SuperTooltip(
        showBarrier: true,
        controller: _controller,
        content: const Text(
          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr,",
          softWrap: true,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        child: Container(
          width: 40.0,
          height: 40.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    ),
```

`SuperTooltip` just need one required argument which is the content. You can pass a child Widget which can be an icon to represent the what should be clicked. As showed in the example below.

```dart
SuperTooltip(
    content: const Text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr",
    softWrap: true,
    style: TextStyle(
        color: Colors.white,
        ),
    ),
    child: Container(
        width: 40.0,
        height: 40.0,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
        ),
        child: Icon(
            Icons.add,
            color: Colors.white,
        ),
    ),
),
```

Change the background by passing the `backgroundColor`.

```dart
SuperTooltip(
    backgroundColor: Color(0xff2f2d2f),
    //....
),
```

Change Popup direction to `TooltipDirection.right`, `TooltipDirection.left`, `TooltipDirection.bottom` and `TooltipDirection.up`

```dart
SuperTooltip(
    popupDirection: TooltipDirection.right,
    //...
)
```

For passing custom shape for popup or pass custom decoration,you can use the `decorationBuilder` which will give you access target property

```dart
SuperTooltip(
    decorationBuilder:(target){
      return ShapeDecoration(
        //...
        shape: CustomShape(
          //...
          target: target,
        ),
      );
    }
    //...
)
```

<img src="https://github.com/bensonarafat/super_tooltip/blob/master/screenshots/screenshot2.png?raw=true" width="250"/>

## Barrier

If you'd like to keep the user from dismissing the tooltip by clicking on the barrier, you can change `showBarrier` to `true` which means pressing on the scrim area will not immediately hide the tooltip.

```dart
SuperTooltip(
    showBarrier: true,
    barrierColor: Colors.red,
    //...
)
```

## Blur

If you'd like to also show blur behind the pop up, you can do that by making the `showDropBoxFilter` to `true` you must also enable `showBarrier` then set `sigmaX` and `sigmaY`

```dart
SuperTooltip(
    showBarrier: true,
    showDropBoxFilter: true,
    sigmaX: 10,
    sigmaY: 10,
    //...
)
```

<img src="https://github.com/bensonarafat/super_tooltip/blob/master/screenshots/screenshot3.gif?raw=true" width="250"/>

If you'd like to simply react to open or close states, you can pass through `onHide` or `onShow` callbacks to the default constructor.

```dart
SuperTooltip(
  onDismiss: () {
    // Maybe continue tutorial?
  },
  onShow: () {
    // Start animation?
  }
),
```

To hide the tooltip when the user tap the back button. Wrap your `GestureDetector` widget with `WillPopScope` widget passing a callback function to `onWillPop` like the example below

```dart
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: GestureDetector(
        onTap: () async {
          await _controller.showTooltip();
        },
        // ..
      ),
    );
```

Create a callback function to dismiss

```dart
  Future<bool> _willPopCallback() async {
    // If the tooltip is open we don't pop the page on a backbutton press
    // but close the ToolTip
    if (_controller.isVisible) {
      await _controller.hideTooltip();
      return false;
    }
    return true;
  }
```

## Example app

Find the example app [here](https://github.com/bensonarafat/super_tooltip/tree/master/example).

<a href="https://github.com/bensonarafat/super_tooltip/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=bensonarafat/super_tooltip" />
</a>

Made with [contrib.rocks](https://contrib.rocks).

## Contributing

Contributions are welcome.
In case of any problems look at [existing issues](https://github.com/bensonarafat/super_tooltip/issues), if you cannot find anything related to your problem then open an issue.
Create an issue before opening a [pull request](https://github.com/bensonarafat/super_tooltip/pulls) for non-trivial fixes.
In case of trivial fixes open a [pull request](https://github.com/bensonarafat/super_tooltip/pulls) directly.

<!-- readme: contributors -start -->
<!-- readme: contributors -end -->
