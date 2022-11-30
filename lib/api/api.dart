import 'package:http/http.dart';
import 'package:maps/models/restaurant.dart';
import 'dart:convert';
import 'package:latlong2/latlong.dart';

Map<String, String> requestHeaders = {
  'Content-type': 'application/json',
  'X-RapidAPI-Key': 'eac6c30f70msh94c987f21ac978dp1a0d10jsn8abb79398a40',
  'X-RapidAPI-Host': 'travel-advisor.p.rapidapi.com'
};

class Api {
  String restaurantsURL =
      "https://travel-advisor.p.rapidapi.com/restaurants/list-by-latlng";

  Future<List<Restaurant>> getRestaurants(LatLng coordinates) async {
    restaurantsURL +=
        "?latitude=${coordinates.latitude}&longitude=${coordinates.longitude}&distance${10}&limit${30}";

    Response res = await get(
      Uri.parse(restaurantsURL),
      headers: requestHeaders,
    );
    if (res.statusCode == 200) {
      Map<dynamic, dynamic> body = jsonDecode(res.body);
      List<dynamic> data = body['data'];

      List<Restaurant> restaurants =
          data.where((item) => checkIfNotNull(item)).map((dynamic item) {
        return Restaurant.fromJson(item);
      }).toList();

      return restaurants;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  bool checkIfNotNull(dynamic item) {
    try {
      if (item["name"] == null ||
          item["latitude"] == null ||
          item["longitude"] == null ||
          item["distance"] == null ||
          item["is_closed"] == null ||
          item["address"] == null ||
          item["phone"] == null ||
          item["rating"] == null ||
          item['photo']['images']['original']['url'] == null) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
