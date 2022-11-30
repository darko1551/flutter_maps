import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maps/models/restaurant.dart';

class RestaurantDetailScreen extends StatelessWidget {
  RestaurantDetailScreen({super.key, required this.restaurant});
  late Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Image.network(restaurant.photoUrl),
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 30),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            restaurant.name,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.home_outlined),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        restaurant.adress,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(Icons.social_distance_outlined),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      restaurant.distance.toString(),
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(Icons.door_back_door_outlined),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      restaurant.closed ? "Oppened" : "Closed",
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(Icons.phone_android_outlined),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      restaurant.phone,
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(Icons.star_outline),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      restaurant.rating.toString(),
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    ));
  }
}
