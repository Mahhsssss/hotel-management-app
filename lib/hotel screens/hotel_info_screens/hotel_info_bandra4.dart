import 'package:flutter/material.dart';

class HotelDetailsPage_two_c extends StatefulWidget {
  const HotelDetailsPage_two_c({super.key});

  @override
  State<HotelDetailsPage_two_c> createState() => _HotelDetailsPageState_two_c();
}

class _HotelDetailsPageState_two_c extends State<HotelDetailsPage_two_c> {
  int currentIndex = 0;

  final List<String> hotelImages = [
    "assets/bandra_img/bandra_r3.webp",
    "assets/bandra_img/bandra_r1.webp",
    "assets/bandra_img/bandra_r2.webp",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F5EC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🖼 IMAGE SLIDER WITH SCALE ANIMATION (LIKE IMAGE)
            // 🖼 IMAGE SLIDER
            Stack(
              children: [
                SizedBox(
                  height: 280,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.9),
                    itemCount: hotelImages.length,
                    onPageChanged: (index) {
                      setState(() => currentIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (_, __, ___) => FullScreenImage(
                                imagePath: hotelImages[index],
                                tag: 'hotelImage$index',
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'hotelImage$index',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Image.asset(
                              hotelImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // BACK BUTTON
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.black38,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),



            const SizedBox(height: 16),

            // HOTEL NAME
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Hotel De Luna",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // INFO CHIPS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  infoChip(Icons.star, "4.9"),
                  infoChip(Icons.cloud, "Cloudy"),
                  infoChip(Icons.location_on, "Lagos"),
                  infoChip(Icons.thermostat, "26°C"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ABOUT
            sectionHeader("About", "See more"),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Luxury hotel offering premium rooms with modern interiors, "
                "excellent views, and world-class services.",
                style: TextStyle(color: Colors.black54),
              ),
            ),

            const SizedBox(height: 24),

            // 🏨 AMENITIES SECTION
            sectionHeader("Amenities", ""),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: const [
                  AmenityCard(
                    image: "assets/images/wifi.jpg",
                    label: "Wi-Fi",
                  ),
                  AmenityCard(
                    image: "assets/images/pool.jpg",
                    label: "Pool",
                  ),
                  AmenityCard(
                    image: "assets/images/parking.webp",
                    label: "Parking",
                  ),
                  AmenityCard(
                    image: "assets/images/restaurant.webp",
                    label: "Restaurant",
                  ),
                  AmenityCard(
                    image: "assets/images/gym.webp",
                    label: "Gym",
                  ),
                  AmenityCard(
                    image: "assets/images/spa.webp",
                    label: "Spa",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            //  REVIEWS SECTION
            sectionHeader("Reviews", "See all"),
            const ReviewTile(
              name: "Aarav Mehta",
              rating: 5,
              review:
                  "Amazing stay! The rooms were super clean and the staff was very friendly.",
            ),
            const ReviewTile(
              name: "Neha Sharma",
              rating: 4,
              review:
                  "Great location and beautiful view. Food could be slightly better.",
            ),
            const ReviewTile(
              name: "Rahul Verma",
              rating: 5,
              review:
                  "One of the best hotels I’ve stayed at. Totally worth the price!",
            ),

            const SizedBox(height: 24),

            // PRICE + BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Starting from",
                          style: TextStyle(color: Colors.black54)),
                      SizedBox(height: 4),
                      Text(
                        "\$750 / night",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9BCB3B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26, vertical: 14),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "BOOK NOW",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

//  INFO CHIP
Widget infoChip(IconData icon, String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 6),
        Text(text),
      ],
    ),
  );
}

// SECTION HEADER
Widget sectionHeader(String title, String action) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
        if (action.isNotEmpty)
          Text(action, style: const TextStyle(color: Colors.green)),
      ],
    ),
  );
}

// AMENITY CARD
class AmenityCard extends StatelessWidget {
  final String image;
  final String label;

  const AmenityCard({
    super.key,
    required this.image,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// REVIEW TILE
class ReviewTile extends StatelessWidget {
  final String name;
  final int rating;
  final String review;

  const ReviewTile({
    super.key,
    required this.name,
    required this.rating,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Row(
                  children: List.generate(
                    rating,
                    (index) => const Icon(Icons.star,
                        size: 16, color: Colors.orange),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
class FullScreenImage extends StatelessWidget {
  final String imagePath;
  final String tag;

  const FullScreenImage({
    super.key,
    required this.imagePath,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragDown: (_) => Navigator.pop(context),
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: tag,
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Image.asset(imagePath),
                ),
              ),
            ),

            // CLOSE BUTTON
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

