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
                      EmployeeTasks(uid: 'cWwfeKu3ElQOWMGDstDsBsDONeq1'),
                ),
              ),
              child: Text("Go to Employee tasks"),
            ),
            // ElevatedButton(
            //   onPressed: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => AdminMain()),
            //   ),
            //   child: Text("Go to Admin Profile page"),
            // ),
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
