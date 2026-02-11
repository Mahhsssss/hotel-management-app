import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_de_luna/services/header.dart';

class EmployeePage extends StatelessWidget {
  const EmployeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFFE8F4EA),
      appBar: AppDrawer.customAppBar(
        context: context,
        colors: const Color.fromARGB(255, 0, 0, 0),
        overlayStyle: SystemUiOverlayStyle.light,
      ),
      endDrawer: const AppDrawer(),
      body: Column(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(
              "assets/images/onboarding/placeholder.webp",
            ),
            radius: 12,
            backgroundColor: Colors.black,
          ),

          Text("Employee Name"),
        ],
      ),
    );
  }
}
