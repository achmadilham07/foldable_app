import 'package:flutter/material.dart';

class HingeNotifier extends ChangeNotifier {
  bool _hasHinge = false;

  bool get hasHinge => _hasHinge;

  set hasHinge(bool value) {
    _hasHinge = value;
    notifyListeners();
  }
}
