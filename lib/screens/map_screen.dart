import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps/screens/no_gps_screen.dart';
import 'package:maps/widgets/map.dart' as map;
import 'package:maps/api/api.dart';
import 'package:maps/timer.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationPermission locationPermission;
  bool permissionGranted = false;
  late MapController _mapController;
  final Timer _timer = Timer();

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  Future checkPermission() async {
    locationPermission = await Geolocator.checkPermission();
    if (locationPermission.index ==
            LocationPermission.unableToDetermine.index ||
        locationPermission.index == LocationPermission.denied.index) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission.index == LocationPermission.always.index ||
          locationPermission.index == LocationPermission.whileInUse.index) {
        permissionGranted = true;
      } else {
        permissionGranted = false;
      }
    } else if (locationPermission.index ==
        LocationPermission.deniedForever.index) {
      permissionGranted = false;
    } else {
      permissionGranted = true;
    }
  }

  Future<LatLng> getCurrentLocation() async {
    Position? position;
    await checkPermission();
    if (!permissionGranted || !await checkGpsEnabled()) {
      Fluttertoast.showToast(
          msg: "Check your GPS properties!", toastLength: Toast.LENGTH_LONG);
      await Future.delayed(const Duration(milliseconds: 2000));
      exit(0);
    } else {
      position = await Geolocator.getCurrentPosition();
    }
    return LatLng(position.latitude, position.longitude);
  }

  Future<bool> checkGpsEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Maps'),
          centerTitle: true,
          actions: [
            ChangeNotifierProvider(
              create: (context) => Timer(),
              child: Padding(
                padding: const EdgeInsets.only(right: 80),
                child: Consumer<Timer>(
                  builder: (context, value, child) {
                    if (value.working) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Icon(Icons.donut_small);
                    }
                  },
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _mapController.moveAndRotate(await getCurrentLocation(), 12, 0);
          },
          child: const Icon(Icons.location_searching_sharp),
        ),
        body: FutureBuilder(
          future: getCurrentLocation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return map.Map(
                centerCoordinates: snapshot.data!,
                mapController: _mapController,
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
