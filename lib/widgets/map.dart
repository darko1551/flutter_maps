// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps/models/restaurant.dart';
import 'package:maps/api/api.dart';
import 'package:maps/screens/restaurant_detail.dart';
import 'package:maps/timer.dart' as tajmer;

class Map extends StatefulWidget {
  LatLng centerCoordinates;
  MapController mapController;
  Map({
    Key? key,
    required this.centerCoordinates,
    required this.mapController,
  }) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  Future<List<Marker>>? markerList;
  final tajmer.Timer _timer = tajmer.Timer();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.mapController,
      options: MapOptions(
        onPositionChanged: (position, hasGesture) async {
          if (!_timer.working) {
            _timer.startWorking();
            await Future.delayed(const Duration(milliseconds: 1500), () {
              markerList = getMarkers(widget.mapController.center);
            });
            _timer.stopWorking();
          }
        },
        onMapReady: () {
          markerList = getMarkers(widget.mapController.center);
        },
        center: widget.centerCoordinates,
        zoom: 12,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
        FutureBuilder(
          future: markerList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MarkerLayer(
                markers: snapshot.data!,
              );
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }

  Future<List<Marker>> getMarkers(LatLng coordinates,
      [double zoom = 12]) async {
    List<Marker> markers = [];
    if (widget.mapController.zoom >= zoom) {
      List<Restaurant> restaurants = await Api().getRestaurants(coordinates);
      restaurants.forEach((element) {
        markers.add(Marker(
          point: element.coordinates,
          width: 30,
          height: 30,
          builder: (context) => IconButton(
            icon: const Icon(Icons.donut_large_rounded),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RestaurantDetailScreen(restaurant: element),
                  ));
            },
          ),
        ));
      });
    }
    setState(() {});
    return markers;
  }
}
