import 'dart:ui';

import 'package:flutter/material.dart';

/// Extension method that helps with working with the hinge directly.
extension MediaQueryHinge on MediaQueryData {
  DisplayFeature? get hinge {
    for (final DisplayFeature e in displayFeatures) {
      if (e.type == DisplayFeatureType.hinge) {
        return e;
      }
    }
    return null;
  }

  bool get hasHinge => hinge != null;
}
