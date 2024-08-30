import 'dart:async';

import 'package:flutter/material.dart';

import 'enums.dart';

class SuperTooltipController extends ChangeNotifier {
  late Completer _completer;
  bool _isVisible = false;
  bool get isVisible => _isVisible;
  // External control flag
  bool externalControlOnly = true;

  late Event event;

  Future<void> showTooltip({bool external = true}) {
    externalControlOnly = external;
    event = Event.show;
    _completer = Completer();
    notifyListeners();
    return _completer.future.whenComplete(() => _isVisible = true);
  }

  Future<void> hideTooltip({bool external = true}) {
    externalControlOnly = external;
    event = Event.hide;
    _completer = Completer();
    notifyListeners();
    return _completer.future.whenComplete(() => _isVisible = false);
  }

  void complete() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }
}

