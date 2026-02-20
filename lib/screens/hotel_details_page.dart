// lib/screens/hotel_details_page.dart
//
// LOGIC CHANGES ONLY — UI IS IDENTICAL TO ORIGINAL:
// 1. Added `bookingData` constructor parameter.
// 2. CRASH FIX: Replaced Stack > Expanded (illegal in Flutter)
//    with Column > SizedBox + Expanded (valid). Visual is identical.
// 3. Passes `bookingData` to FinalBookingDetailsPage.
// Everything else — every widget, colour, padding — is unchanged.

import 'package:flutter/material.dart';
import '../models/hotel_model.dart';
import '../models/booking_data.dart';
import 'final_booking_details_page.dart';

class HotelDetailsPage extends StatefulWidget {
  final Hotel hotels;
  final BookingData bookingData; // ← NEW

  const HotelDetailsPage({
    super.key,
    required this.hotels,
    required this.bookingData, // ← NEW
  });

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  int currentIndex = 0;
  final PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hotel = widget.hotels;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      // FIX: Column instead of Stack so Expanded is valid.
      // The screen still looks exactly the same:
      //   top 300px → image carousel
      //   rest      → white rounded scrollable card
      body: Column(
        children: [
          // IMAGE CAROUSEL — unchanged
          SizedBox(
            height: 300,
            child: PageView.builder(
              controller: pageController,
              itemCount: hotel.images.isNotEmpty ? hotel.images.length : 1,
              itemBuilder: (context, index) {
                if (hotel.images.isEmpty) {
                  return Container(color: Colors.grey[300]);
                }
                return Image.asset(
                  hotel.images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.grey[300]),
                );
              },
            ),
          ),

          // Expanded is now valid (parent is Column, not Stack)
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Everything below is copy-pasted from original ──
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
                        _buildInfoPill(Icons.star, hotel.starRating.toString()),
                        const SizedBox(width: 10),
                        _buildInfoPill(Icons.hotel, hotel.roomType),
                      ],
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "About",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      hotel.description,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Amenities",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: hotel.amenities.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemBuilder: (ctx, i) => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              hotel.amenities[i],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Gallery",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // BOOK NOW — only change: now passes bookingData forward
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F5F45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FinalBookingDetailsPage(
                                hotel: hotel,
                                bookingData: widget.bookingData, // ← NEW
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "BOOK NOW",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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

  // Unchanged from original
  Widget _buildInfoPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
