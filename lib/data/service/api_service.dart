import 'dart:convert';

import '../model/locations.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Locations> getGoogleOffices() async {
    const googleLocationsURL =
        'https://about.google/static/data/locations.json';

    // Retrieve the locations of Google offices
    try {
      final response = await http.get(Uri.parse(googleLocationsURL));
      if (response.statusCode == 200) {
        return Locations.fromJson(json.decode(response.body));
      } else {
        throw Exception("Server error");
      }
    } catch (e) {
      throw Exception("Error");
    }
  }
}
