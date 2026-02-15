import 'package:flutter/material.dart';
import '../services/hotel_service.dart';
import 'hotel_list_screen.dart';

class HotelFilterScreen extends StatefulWidget {
  final String selectedLocation;

  const HotelFilterScreen({super.key, required this.selectedLocation});

  @override
  State<HotelFilterScreen> createState() => _HotelFilterScreenState();
}

class _HotelFilterScreenState extends State<HotelFilterScreen> {

  String selectedRoomType = "Deluxe Room";
  int selectedRating = 3;

  List<String> amenitiesList = [
    "Gym",
    "Pool",
    "Parking Area",
    "Spa",
    "Wifi",
    "Restaurant",
  ];

  List<String> selectedAmenities = [];

  List<String> roomTypes = [
    "Deluxe Room",
    "One Bedroom Suite",
    "Junior Suite",
    "Executive Suite",
    "Presidential Suite",
    "Single Room",
    "Double / Queen",
    "Twin Room",
    "Triple Room",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filter Hotels")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text("Select Room Type",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            DropdownButton<String>(
              value: selectedRoomType,
              isExpanded: true,
              items: roomTypes.map((room) {
                return DropdownMenuItem(
                  value: room,
                  child: Text(room),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRoomType = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text("Minimum Rating",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            Slider(
              value: selectedRating.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: selectedRating.toString(),
              onChanged: (value) {
                setState(() {
                  selectedRating = value.toInt();
                });
              },
            ),

            const SizedBox(height: 20),

            const Text("Select Amenities",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            ...amenitiesList.map((amenity) {
              return CheckboxListTile(
                title: Text(amenity),
                value: selectedAmenities.contains(amenity),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedAmenities.add(amenity);
                    } else {
                      selectedAmenities.remove(amenity);
                    }
                  });
                },
              );
            }).toList(),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {

                final hotels = await HotelService().getFilteredHotels(
                  location: widget.selectedLocation,
                  roomType: selectedRoomType,
                  starRating: selectedRating,
                  selectedAmenities: selectedAmenities,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HotelListScreen(hotels: hotels),
                  ),
                );
              },
              child: const Text("Search Hotels"),
            )
          ],
        ),
      ),
    );
  }
}
