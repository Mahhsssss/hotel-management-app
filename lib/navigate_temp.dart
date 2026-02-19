import 'package:flutter/material.dart';
import 'package:hotel_de_luna/employee%20screens/employee/employee_main.dart';
import 'package:hotel_de_luna/employee%20screens/employee/employee_tasks.dart';
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
        ),
      ),
    );
  }
}
