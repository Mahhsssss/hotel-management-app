import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:hotel_de_luna/employee%20screens/employee/employee_main.dart';
import 'package:hotel_de_luna/employee%20screens/employee/employee_tasks.dart';
import 'package:hotel_de_luna/hotel%20screens/hotel_homepage.dart';
=======
import 'package:hotel_de_luna/auth screens/guest_login.dart';
import 'package:hotel_de_luna/employee screens/admin_page.dart';
import 'package:hotel_de_luna/employee screens/employee_page.dart';
import 'package:hotel_de_luna/employee screens/receptionist_page.dart';
import 'package:hotel_de_luna/hotel screens/hotel_homepage.dart';
import 'package:hotel_de_luna/models/booking_data.dart';
import 'package:hotel_de_luna/models/hotel_model.dart';
import 'package:hotel_de_luna/screens/explore_page.dart';
import 'package:hotel_de_luna/screens/final_booking_details_page.dart';
>>>>>>> main

import 'package:hotel_de_luna/screens/location_choose.dart';

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
<<<<<<< HEAD
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("This is a tester page to skip login etc.. "),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HotelHomepage()),
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
                MaterialPageRoute(builder: (context) => const ExplorePage()),
              ),
              child: Text("Go to explore page"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ExplorePage()),
              ),
              child: Text("Go to explore page"),
            ),
          ],
=======
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Dev Navigation Page",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GuestLoginScreen(),
                  ),
                ),
                child: const Text("Go to Guest Login Page"),
              ),

              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HotelHomepage(),
                  ),
                ),
                child: const Text("Go to Hotel HomePage"),
              ),

              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminPage()),
                ),
                child: const Text("Go to Admin Page"),
              ),

              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReceptionistPage(),
                  ),
                ),
                child: const Text("Go to Receptionist Page"),
              ),

              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmployeePage()),
                ),
                child: const Text("Go to Employee Page"),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FinalBookingDetailsPage(
                        hotel: dummyHotel,
                        bookingData: dummyBookingData, // ← fixed
                      ),
                    ),
                  );
                },
                child: const Text("Go to Final Booking Page"),
              ),

              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExplorePage()),
                ),
                child: const Text("Go to Explore Page"),
              ),
            ],
          ),
>>>>>>> main
        ),
      ),
    );
  }
}
