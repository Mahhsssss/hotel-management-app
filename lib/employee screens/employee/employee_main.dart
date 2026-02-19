<<<<<<< HEAD
// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_de_luna/database.dart';
import 'package:hotel_de_luna/employee%20screens/employee/employee_tasks.dart';
import 'package:hotel_de_luna/employee%20screens/employee/manage_employees.dart';
import 'package:hotel_de_luna/services/header.dart';

// ignore_for_file: avoid_print

=======
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_de_luna/services/database.dart';
import 'package:hotel_de_luna/employee%20screens/employee/employee_tasks.dart';
import 'package:hotel_de_luna/services/header.dart';

>>>>>>> main
class EmployeeMain extends StatelessWidget {
  final String uid;
  final DatabaseService _db = DatabaseService();

  EmployeeMain({super.key, required this.uid});
<<<<<<< HEAD

=======
>>>>>>> main
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppDrawer.customAppBar(
        context: context,
        colors: Colors.black,
        overlayStyle: SystemUiOverlayStyle.dark,
      ),
<<<<<<< HEAD
      body: StreamBuilder<List<Employee>>(
        stream: _db.Employees,
        builder: (context, empSnapshot) {
          if (empSnapshot.hasError) {
            print("🔴 ERROR: ${empSnapshot.error}");
          }

          if (empSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (empSnapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${empSnapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!empSnapshot.hasData || empSnapshot.data!.isEmpty) {
            return const Center(child: Text('No employees found in database'));
          }

          final currentUser = empSnapshot.data!.firstWhere(
            (e) => e.Uid == uid,
            orElse: () => Employee(
              docId: 'Unknown',
              Name: 'Unknown',
              Permissions: 'Unknown',
              Role: 'Unknown',
              Salary: 'Unknown',
              Uid: uid,
            ),
          );
          print("Current user name: ${currentUser.Name}");
=======
      endDrawer: const AppDrawer(),
      body: StreamBuilder<List<Employee>>(
        stream: _db.employees,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final currentUser = snapshot.data!.firstWhere((e) => e.uid == uid);
>>>>>>> main

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const ProfilePic(),
                const SizedBox(height: 40),

<<<<<<< HEAD
                Text(
                  "Welcome, ${currentUser.Name != 'Unknown' ? currentUser.Name : 'Employee'}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                ProfileMenu(
                  text: "My Account",
                  icon: Icons.person,
                  press: () => {},
                ),

=======
>>>>>>> main
                ProfileMenu(
                  text: "Tasks",
                  icon: Icons.task,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
<<<<<<< HEAD
                        builder: (context) =>
                            EmployeeTasks(uid: uid, name: currentUser.Name),
=======
                        builder: (context) => EmployeeTasks(uid: uid),
>>>>>>> main
                      ),
                    );
                  },
                ),
<<<<<<< HEAD

                ProfileMenu(
                  text: "Schedule",
                  icon: Icons.calendar_month,
                  press: () {},
                ),

                if (currentUser.Permissions != "none")
                  ProfileMenu(
                    text: "Manage Employees",
                    icon: Icons.people,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ManageEmployees(uid: currentUser.Uid),
                        ),
                      );
                    },
                  ),
                ProfileMenu(
                  text: "Log Out",
                  icon: Icons.logout,
                  press: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                ),
=======
                if (currentUser.permissions != "none")
                  ProfileMenu(
                    text: "Manage Employees",
                    icon: Icons.calendar_month,
                    press: () {},
                  ),

                ProfileMenu(text: "Log Out", icon: Icons.login, press: () {}),
>>>>>>> main
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
<<<<<<< HEAD
            backgroundImage: AssetImage("assets/images/no_profile.webp"),
=======
            backgroundImage: AssetImage(
              "assets/images/onboarding/placeholder.webp",
            ),
>>>>>>> main
          ),
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.text,
    required this.icon,
    this.press,
  });

  final String text;
  final IconData icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 9,
      decoration: BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 50, 83, 50),
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: const Color(0xFFF5F6F9),
          ),
          onPressed: press,
          child: Row(
            children: [
              Icon(icon, size: 15),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 15,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 50, 83, 50),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
