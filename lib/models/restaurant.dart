import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class Restaurant {
  final String name;
  final LatLng coordinates;
  final double distance;
  final bool closed;
  final String adress;
  final String phone;
  final double rating;
  final String photoUrl;

  Restaurant(
      {required this.name,
      required this.coordinates,
      required this.distance,
      required this.closed,
      required this.adress,
      required this.phone,
      required this.rating,
      required this.photoUrl});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
        name: json['name'] as String,
        coordinates: LatLng(
            double.parse(json["latitude"]), double.parse(json["longitude"])),
        distance: double.parse(json["distance"]),
        closed: json["is_closed"] == "true" ? true : false,
        adress: json['address'] as String,
        phone: json['phone'] as String,
        rating: double.parse(json["rating"]),
        photoUrl: json['photo']['images']['original']['url'] as String);
  }
}
