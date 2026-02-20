// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_de_luna/services/employee_service.dart';
import 'package:hotel_de_luna/employee%20screens/employee_tasks.dart';
import 'package:hotel_de_luna/services/header.dart';

class ManageEmployees extends StatelessWidget {
  final String uid;
  ManageEmployees({super.key, required this.uid});

  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF5), // Soft off-white background
      appBar: AppDrawer.customEmpAppBar(
        context: context,
        colors: const Color.fromARGB(255, 50, 83, 50), // Deep forest green
        overlayStyle: SystemUiOverlayStyle.dark,
        title: "Manage Employees",
      ),
      body: Container(
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
        child: StreamBuilder<List<Employee>>(
          stream: _db.Employees,
          builder: (context, empSnapshot) {
            if (empSnapshot.hasError) {
              print("🔴 ERROR: ${empSnapshot.error}");
              return Center(
                child: Text(
                  'Error: ${empSnapshot.error}',
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            }

            if (empSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 50, 83, 50),
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

            final employee_list =
                empSnapshot.data?.where((employee) {
                  // Filter out admins AND current user
                  final isNotAdmin =
                      employee.Permissions != 'all' &&
                      !(employee.Permissions.contains('all') ?? false);

                  final isNotCurrentUser = employee.Uid != uid;

                  return isNotAdmin && isNotCurrentUser;
                }).toList() ??
                [];

            print("Total number of employees ${employee_list.length}");

            return Column(
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 50, 83, 50),
                                  Color.fromARGB(255, 70, 110, 70),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.people_alt,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Team Members',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 50, 50, 50),
                                  ),
                                ),
                                Text(
                                  '${employee_list.length} active employees',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Employee List
                Expanded(
                  child: employee_list.isEmpty
                      ? Center(
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
                                  Icons.person_off,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'No other employees to manage',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 100, 100, 100),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: employee_list.length,
                          itemBuilder: (context, index) {
                            final currentEmployee = employee_list[index];

                            // Alternate card colors for visual interest
                            final bool isEven = index % 2 == 0;

                            return EmployeeMenu(
                              employee: currentEmployee,
                              name: currentEmployee.Name,
                              role: currentEmployee.Role,
                              permissions: currentEmployee.Permissions,
                              isEven: isEven,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmployeeTasks(
                                    uid: currentEmployee.Uid,
                                    name: currentEmployee.Name,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class EmployeeMenu extends StatelessWidget {
  final Employee employee;
  final String name;
  final String role;
  final String permissions;
  final bool isEven;
  final VoidCallback onTap;

  const EmployeeMenu({
    super.key,
    required this.employee,
    required this.name,
    required this.role,
    required this.permissions,
    required this.isEven,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: const Color.fromARGB(255, 50, 83, 50).withOpacity(0.1),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Profile Avatar with Gradient
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isEven
                          ? const [
                              Color.fromARGB(255, 50, 83, 50),
                              Color.fromARGB(255, 70, 110, 70),
                            ]
                          : const [
                              Color.fromARGB(255, 100, 80, 60),
                              Color.fromARGB(255, 120, 100, 80),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                // Employee Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 50, 50, 50),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                255,
                                50,
                                83,
                                50,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              role,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 50, 83, 50),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              permissions,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow Button
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: isEven
                        ? const Color.fromARGB(255, 50, 83, 50)
                        : const Color.fromARGB(255, 100, 80, 60),
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
