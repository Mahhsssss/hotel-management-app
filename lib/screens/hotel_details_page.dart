import 'package:flutter/material.dart';
import 'package:hotel_de_luna/models/booking_data.dart';
import 'package:hotel_de_luna/screens/final_booking_details_page.dart';
import '../models/hotel_model.dart';

class HotelDetailsPage extends StatefulWidget {
  final Hotel hotels; // Note: parameter name is 'hotels' (plural)
  final BookingData bookingData;

  const HotelDetailsPage({
    super.key,
    required this.hotels,
    required this.bookingData,
  });

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final hotel = widget.hotels; // This is a single Hotel object

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    // Image Carousel
                    SizedBox(
                      height: 400,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: hotel.images.isEmpty
                            ? 1
                            : hotel.images.length,
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          if (hotel.images.isEmpty) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: Icon(Icons.image, size: 100),
                              ),
                            );
                          }

                          final imagePath = hotel.images[index];

                          return ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(30),
                            ),
                            child: imagePath.startsWith("http")
                                ? Image.network(
                                    imagePath,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 80,
                                        ),
                                      );
                                    },
                                  )
                                : Image.asset(
                                    imagePath,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                          );
                        },
                      ),
                    ),

                    // Back Button
                    Positioned(
                      top: 50,
                      left: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.black45,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),

                    // Hotel Name
                    Positioned(
                      bottom: 70,
                      left: 25,
                      child: Text(
                        hotel.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Dot Indicator
                    Positioned(
                      bottom: 25,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          hotel.images.isEmpty ? 1 : hotel.images.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: currentIndex == index ? 14 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: currentIndex == index
                                  ? Colors.white
                                  : Colors.white54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ================= CONTENT =================
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Rating + Room Type
                    Row(
                      children: [
                        _buildInfoPill(Icons.star, hotel.starRating.toString()),
                        const SizedBox(width: 10),
                        _buildInfoPill(Icons.hotel, hotel.roomType),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // About Section
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

                    // Location Section (added since you have location field)
                    const Text(
                      "Location",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Text(
                          hotel.location,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Amenities
                    const Text(
                      "Amenities",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Bulleted list of amenities
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: List.generate(hotel.amenities.length, (
                          index,
                        ) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Bullet point
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 4,
                                    right: 12,
                                  ),
                                  child: const Icon(
                                    Icons.circle,
                                    size: 8,
                                    color: Color(0xFF3F5F45),
                                  ),
                                ),
                                // Amenity text
                                Expanded(
                                  child: Text(
                                    hotel.amenities[index],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Gallery Section
                    const Text(
                      "Gallery",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: hotel.images.length,
                        itemBuilder: (context, index) {
                          final img = hotel.images[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: img.startsWith("http")
                                  ? Image.network(
                                      img,
                                      width: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              width: 120,
                                              color: Colors.grey.shade300,
                                              child: const Icon(
                                                Icons.broken_image,
                                              ),
                                            );
                                          },
                                    )
                                  : Image.asset(
                                      img,
                                      width: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              width: 120,
                                              color: Colors.grey.shade300,
                                              child: const Icon(
                                                Icons.broken_image,
                                              ),
                                            );
                                          },
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),

          // ================= BOTTOM BOOKING BAR =================
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Starting from",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "₹ ${hotel.price} /per night", // price is int, no null check needed
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // FIX: Navigate to the page, don't just create it
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FinalBookingDetailsPage(
                            hotel: hotel,
                            bookingData:
                                widget.bookingData, // Use widget.bookingData
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F5F45),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "BOOK NOW",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
