import 'package:flutter/material.dart';
import '../models/hotel_model.dart';
import 'hotel_details_page.dart';

class HotelListScreen extends StatelessWidget {
  final List<Hotel> hotels;
  const HotelListScreen({super.key, required this.hotels});

  @override
  Widget build(BuildContext context) {
    // Theme colors to match your Filter and Details pages
    const Color primaryGreen = Color(0xFF388E3C);
    const Color lightGreenBg = Color(0xFFE8F5E9);

    return Scaffold(
      backgroundColor: lightGreenBg, // Consistent light green background
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Available Hotels",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: hotels.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    "No hotels found matching your search.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                final hotel = hotels[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => HotelDetailsPage(hotels: hotel),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hotel Image
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              child: Image.asset(
                                hotel.images.first,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Price Badge
                            Positioned(
                              top: 15,
                              right: 15,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryGreen,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "₹ ${hotel.price}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Hotel Details
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    hotel.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Serif',
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                        size: 20,
                                      ),
                                      Text(
                                        " ${hotel.starRating}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.grey[600],
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    hotel.location,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Amenities Preview
                              Wrap(
                                spacing: 8,
                                children: hotel.amenities.take(3).map((a) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: lightGreenBg,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      a,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: primaryGreen,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
