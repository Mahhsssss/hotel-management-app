import 'package:flutter/material.dart';
import '../models/hotel_model.dart';
//import 'payment_screen.dart';

class HotelDetailsPage extends StatelessWidget {
  final Hotel hotel;

  const HotelDetailsPage({
    super.key,
    required this.hotel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          /// IMAGE CAROUSEL
          SizedBox(
            height: 300,
            child: PageView.builder(
              itemCount: hotel.images.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  hotel.images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      hotel.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(hotel.starRating.toString()),
                        const SizedBox(width: 15),
                        Text(hotel.location),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Room Type: ${hotel.roomType}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "₹ ${hotel.price.toStringAsFixed(0)} per night",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "About this hotel",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(hotel.description),

                    const SizedBox(height: 25),

                    const Text(
                      "Amenities",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: hotel.amenities.map((amenity) {
                        return Chip(
                          label: Text(amenity),
                          backgroundColor: Colors.grey.shade200,
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        // onPressed: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (_) =>
                        //           PaymentScreen(hotel: hotel),
                        //     ),
                        //   );
                        // },
                        child: const Text(
                          "BOOK NOW",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
