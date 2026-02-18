import 'package:flutter/material.dart';
import 'package:hotel_de_luna/auth screens/guest_login.dart';
import 'package:hotel_de_luna/employee screens/admin_page.dart';
import 'package:hotel_de_luna/employee screens/employee_page.dart';
import 'package:hotel_de_luna/employee screens/receptionist_page.dart';
import 'package:hotel_de_luna/hotel screens/hotel_homepage.dart';
import 'package:hotel_de_luna/models/hotel_model.dart';
import 'package:hotel_de_luna/screens/final_booking_details_page.dart';

class NavigateTemp extends StatelessWidget {
  const NavigateTemp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("This is a tester page to skip login etc.. "),

            // ✅ NEW LOGIN BUTTON
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
                MaterialPageRoute(builder: (context) => const HotelHomepage()),
              ),
              child: const Text("Go to Hotel HomePage"),
            ),

            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminPage()),
              ),
              child: const Text("Go to admin page"),
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
                final dummyHotel = Hotel(
                  id: "test1",
                  name: "Test Hotel",
                  location: "Mumbai",
                  price: 2000,
                  starRating: 4,
                  description: "This is a test hotel description.",
                  roomType: "Deluxe",
                  amenities: ["WiFi", "Pool", "Breakfast"],
                  images: ["assets/images/onboarding/hotel_room.webp"],
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FinalBookingDetailsPage(hotel: dummyHotel),
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
              child: Text("Go to explore Page"),
            ),
          ],
        ),
      ),
    );
  }
}
