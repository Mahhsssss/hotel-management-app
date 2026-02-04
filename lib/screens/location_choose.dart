import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  // Original list (never changes)
  final List<Map<String, String>> allLocations = [
    {"name": "ANDHERI", "image": "assets/iamges/andheri.webp"},
    {"name": "BORIVALI", "image": "assets/images/borivali.webp"},
    {"name": "BANDRA", "image": "assets/images/bandra.webp"},
    {"name": "CHURCHGATE", "image": "assets/images/churchgate.webp"},
  ];

  // List shown on UI (changes with search)
  late List<Map<String, String>> filteredLocations;

  @override
  void initState() {
    super.initState();
    filteredLocations = allLocations;
  }

  // 🔍 Search logic
  void searchLocation(String query) {
    final results = allLocations.where((location) {
      final name = location["name"]!.toLowerCase();
      final input = query.toLowerCase();
      return name.contains(input);
    }).toList();

    setState(() {
      filteredLocations = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF6EE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Explore",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              // 🔍 SEARCH BAR
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: searchLocation, // 👈 magic happens here
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Search destinations...",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                "${filteredLocations.length} destinations found",
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: GridView.builder(
                  itemCount: filteredLocations.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.70,
                  ),
                  itemBuilder: (context, index) {
                    return DestinationCard(
                      title: filteredLocations[index]["name"]!,
                      image: filteredLocations[index]["image"]!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DestinationCard extends StatelessWidget {
  final String image;
  final String title;

  const DestinationCard({
    super.key,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              image,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
