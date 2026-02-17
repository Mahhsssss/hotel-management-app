import 'package:flutter/material.dart';
import 'package:hotel_de_luna/employee%20screens/admin_page.dart';
import 'package:hotel_de_luna/employee%20screens/employee_page.dart';
import 'package:hotel_de_luna/employee%20screens/receptionist_page.dart';
import 'package:hotel_de_luna/hotel%20screens/hotel_homepage.dart';
import 'package:hotel_de_luna/screens/location_choose.dart';

class NavigateTemp extends StatelessWidget {
  const NavigateTemp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                MaterialPageRoute(builder: (context) => const AdminPage()),
              ),
              child: Text("Go to admin page"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReceptionistPage(),
                ),
              ),
              child: Text("Go to Receptionist Page"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmployeePage()),
              ),
              child: Text("Go to Employee Page"),
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
