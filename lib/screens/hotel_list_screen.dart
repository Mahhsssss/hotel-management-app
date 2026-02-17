import 'package:flutter/material.dart';
import 'package:hotel_de_luna/models/hotel_model.dart';

class HotelListScreen extends StatelessWidget {
  final List<Hotel> hotels;

  const HotelListScreen({super.key, required this.hotels});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Hotels")),
      body: ListView.builder(
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          final hotel = hotels[index];

          return ListTile(
            leading: Image.asset(
              hotel.images.first,
              width: 60,
              fit: BoxFit.cover,
            ),

            title: Text(hotel.name),
            subtitle: Text("₹${hotel.price}  |  ⭐${hotel.starRating}"),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => HotelDetailsPage(hotel: hotel),
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}
