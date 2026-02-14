import 'package:flutter/material.dart';
import 'package:hotel_de_luna/employee%20screens/admin/admin_main.dart';
import 'package:hotel_de_luna/employee%20screens/employee/employee_main.dart';
import 'package:hotel_de_luna/employee%20screens/reception/reception_main.dart';
// import 'package:hotel_de_luna/employee%20screens/admin_page.dart';
// import 'package:hotel_de_luna/employee%20screens/employee_page.dart';
// import 'package:hotel_de_luna/employee%20screens/receptionist_page.dart';
import 'package:hotel_de_luna/hotel%20screens/hotel_homepage.dart';

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
                MaterialPageRoute(builder: (context) => const EmployeeMain()),
              ),
              child: Text("Go to Employee profile page"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReceptionMain()),
              ),
              child: Text("Go to Receptionist profile"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminMain()),
              ),
              child: Text("Go to Admin Profile page"),
            ),
          ],
        ),
      ),
    );
  }
}
