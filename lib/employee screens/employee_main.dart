// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_de_luna/auth%20screens/employee_login.dart';
import 'package:hotel_de_luna/services/employee_service.dart';
import 'package:hotel_de_luna/employee%20screens/employee_tasks.dart';
import 'package:hotel_de_luna/employee%20screens/manage_employees.dart';
import 'package:hotel_de_luna/services/header.dart';

// ignore_for_file: avoid_print

class EmployeeMain extends StatelessWidget {
  final String uid;
  final DatabaseService _db = DatabaseService();

  EmployeeMain({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF5), // Soft off-white background
      appBar: AppDrawer.customEmpAppBar(
        context: context,
        colors: const Color.fromARGB(255, 50, 83, 50), // Deep forest green
        overlayStyle: SystemUiOverlayStyle.dark,
        title: "Employee Dashboard",
      ),
      body: StreamBuilder<List<Employee>>(
        stream: _db.Employees,
        builder: (context, empSnapshot) {
          if (empSnapshot.hasError) {
            print("🔴 ERROR: ${empSnapshot.error}");
          }

          if (empSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 50, 83, 50),
              ),
            );
          }

          if (empSnapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${empSnapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          if (!empSnapshot.hasData || empSnapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.people_outline,
                      size: 50,
                      color: Color.fromARGB(255, 50, 83, 50),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No employees found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 100, 100, 100),
                    ),
                  ),
                ],
              ),
            );
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

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE8F4EA), // Soft mint
                  Color(0xFFF8FAF5), // Off-white
                ],
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                children: [
                  // Profile Section with Glass Effect
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 50, 83, 50),
                          Color.fromARGB(255, 70, 110, 70),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Profile Picture with Ring
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white30,
                          ),
                          child: const CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage(
                              "assets/images/no_profile.webp",
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Welcome Text
                        Text(
                          "Welcome back,",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          currentUser.Name != 'Unknown'
                              ? currentUser.Name
                              : 'Employee',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),

                        // Role Badge
                        if (currentUser.Permissions != "none") ...[
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.admin_panel_settings,
                                  size: 16,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${currentUser.Permissions} Access',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Quick Actions Header
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 50, 50, 50),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Tasks Card
                  _buildMenuCard(
                    context,
                    icon: Icons.task_alt,
                    title: "My Tasks",
                    subtitle: "View and manage your assigned tasks",
                    color1: const Color.fromARGB(255, 50, 83, 50),
                    color2: const Color.fromARGB(255, 70, 110, 70),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EmployeeTasks(uid: uid, name: currentUser.Name),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // Manage Employees Card (if permission allows)
                  if (currentUser.Permissions != "none")
                    _buildMenuCard(
                      context,
                      icon: Icons.people_alt,
                      title: "Manage Employees",
                      subtitle: "View and manage employee accounts",
                      color1: const Color.fromARGB(255, 100, 80, 60),
                      color2: const Color.fromARGB(255, 120, 100, 80),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ManageEmployees(uid: currentUser.Uid),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 30),

                  // Log Out Button (Styled differently)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Signed out successfully'),
                              backgroundColor: Colors.green.shade600,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmployeeLoginScreen(),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        "Sign Out",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Footer Text
                  Text(
                    'Hotel de Luna • Employee Portal',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color1,
    required Color color2,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container with Gradient
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color1, color2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 15),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 50, 50, 50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.arrow_forward_ios, color: color1, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
