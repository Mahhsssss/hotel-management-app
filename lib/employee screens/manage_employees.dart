// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_de_luna/services/database.dart';
import 'package:hotel_de_luna/employee%20screens/employee_tasks.dart';
import 'package:hotel_de_luna/services/header.dart';

class ManageEmployees extends StatelessWidget {
  final String uid;
  ManageEmployees({super.key, required this.uid});

  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppDrawer.customEmpAppBar(
        context: context,
        colors: Colors.black,
        overlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: StreamBuilder<List<Employee>>(
        stream: _db.Employees,
        builder: (context, empSnapshot) {
          if (empSnapshot.hasError) {
            print("🔴 ERROR: ${empSnapshot.error}");
          }

          if (empSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!empSnapshot.hasData || empSnapshot.data!.isEmpty) {
            return const Center(child: Text('No employees found'));
          }

          final employee_list =
              empSnapshot.data?.where((employee) {
                // Filter out admins AND current user
                final isNotAdmin =
                    employee.Permissions != 'all' &&
                    !(employee.Permissions?.contains('all') ?? false);

                final isNotCurrentUser = employee.Uid != uid;

                return isNotAdmin && isNotCurrentUser;
              }).toList() ??
              [];

          print("Total number of employees ${employee_list.length}");

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: employee_list.length,
              itemBuilder: (context, index) {
                final currentEmployee = employee_list[index];

                return EmployeeMenu(
                  employee: currentEmployee,
                  name: currentEmployee.Name,
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
          );
        },
      ),
    );
  }
}

class EmployeeMenu extends StatelessWidget {
  final employee;
  final String name;
  final VoidCallback onTap;

  const EmployeeMenu({
    super.key,
    required this.employee,
    required this.name,
    required this.onTap,
  });

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
          onPressed: onTap,
          child: Row(
            children: [
              Icon(Icons.person, size: 20),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  name,
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
