import 'package:flutter/material.dart';
import 'package:foldable_app/data/model/locations.dart';
import 'package:foldable_app/data/service/api_service.dart';

class LocationNotifier extends ChangeNotifier {
  final ApiService apiService;
  LocationNotifier(this.apiService);

  bool _isLoading = false;
  Locations? _location;
  String _message = "";

  bool get isLoading => _isLoading;

  String get message => _message;

  Locations? get location => _location;

  Future<void> getLocation() async {
    try {
      _isLoading = true;
      notifyListeners();

      _location = await apiService.getGoogleOffices();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _message = "error";
      _isLoading = false;
      notifyListeners();
    }
  }
}
