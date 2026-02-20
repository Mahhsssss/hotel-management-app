import 'package:flutter/material.dart';
import 'package:hotel_de_luna/employee%20screens/employee_main.dart';
import 'package:hotel_de_luna/hotel%20screens/hotel_homepage.dart';
import 'package:hotel_de_luna/models/booking_data.dart';
import 'package:hotel_de_luna/models/hotel_model.dart';
import 'package:hotel_de_luna/screens/explore_page.dart';

class NavigateTemp extends StatelessWidget {
  const NavigateTemp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for testing
    final dummyHotel = Hotel(
      id: "test1",
      name: "Test Hotel",
      location: "ANDHERI",
      price: 2000,
      starRating: 4,
      description: "This is a test hotel description.",
      roomType: "Deluxe Room",
      amenities: ["WiFi", "Pool", "Breakfast"],
      images: ["assets/images/onboarding/hotel_room.webp"],
    );

    final dummyBookingData = BookingData(
      location: "ANDHERI",
      checkIn: DateTime.now().add(const Duration(days: 1)),
      checkOut: DateTime.now().add(const Duration(days: 3)),
      adults: 2,
      children: 0,
      selectedAmenities: [],
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("This is a tester page to skip login etc.. "),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HotelHomepage()),
              ),
              child: Text("Go to Hotel HomePage"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EmployeeMain(uid: 'cWwfeKu3ElQOWMGDstDsBsDONeq1'),
                ),
              ),
              child: Text("Go to Employee profile page"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EmployeeMain(uid: 'zGUjfG1SV9PUtI23zVB6UQIQ3wY2'),
                ),
              ),
              child: Text("Go to Receptionist Profile page"),
            ),

            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EmployeeMain(uid: 'P0se35cjagderlKRH3m2TrRb1JK2'),
                ),
              ),
              child: Text("Go to Admin Profile page"),
            ),

            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExplorePage()),
              ),
              child: Text("Go to explore page"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExplorePage()),
              ),
              child: Text("Go to explore page"),
            ),
          ],
        ),
      ),
    );
  }
}
