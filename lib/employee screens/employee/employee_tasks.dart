// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_de_luna/database.dart';
import 'package:hotel_de_luna/services/header.dart';

class EmployeeTasks extends StatefulWidget {
  final String uid;

  const EmployeeTasks({super.key, required this.uid});

  @override
  State<EmployeeTasks> createState() => _EmployeeTasksState();
}

class _EmployeeTasksState extends State<EmployeeTasks> {
  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFE8F4EA),
      appBar: AppDrawer.customAppBar(
        context: context,
        colors: Colors.black,
        overlayStyle: SystemUiOverlayStyle.dark,
      ),
      endDrawer: const AppDrawer(),
      body: StreamBuilder<List<Employee>>(
        stream: _db.Employees,
        builder: (context, empSnapshot) {
          if (!empSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Find the current employee by their UID
          final currentEmployee = empSnapshot.data!.firstWhere(
            (e) => e.Uid == widget.uid,
            orElse: () => Employee(
              Name: 'Unknown',
              Permissions: 'Unknown',
              Role: 'Employee',
              Salary: '0',
              Uid: 'Unknown',
              docId: '',
            ),
          );

          print("Current employee name: ${currentEmployee.Name}");
          print("Current employee docId: ${currentEmployee.docId}");

          return StreamBuilder<List<Tasks>>(
            stream: _db.tasks,
            builder: (context, taskSnapshot) {
              if (taskSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (taskSnapshot.hasError) {
                return Center(child: Text('Error: ${taskSnapshot.error}'));
              }

              // Filter tasks that belong to this employee
              final myTasks =
                  taskSnapshot.data?.where((task) {
                    // Get the employee reference from the task (e.g., "Employees/emp1")
                    String employeeRef = task.employee;

                    if (employeeRef.contains('/')) {
                      // Extract the document ID from the reference (e.g., "emp1")
                      String employeeDocId = employeeRef.split('/').last;

                      // Find the employee with this document ID
                      try {
                        final taskEmployee = empSnapshot.data!.firstWhere(
                          (emp) => emp.docId == employeeDocId,
                        );

                        // Check if this task's employee UID matches the current user's UID
                        return taskEmployee.Uid == widget.uid;
                      } catch (e) {
                        // No matching employee found for this reference
                        print("No employee found for docId: $employeeDocId");
                        return false;
                      }
                    } else {
                      // If it's not a reference, assume it's a direct UID comparison
                      return employeeRef == widget.uid;
                    }
                  }).toList() ??
                  [];

              print("Tasks found for this employee: ${myTasks.length}");

              int total = myTasks.length;
              int completed = myTasks.where((t) => t.completed).length;
              double progressValue = total == 0 ? 0.0 : completed / total;

              return Column(
                children: [
                  const SizedBox(height: 120),

                  // 🔹 Progress Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          value: progressValue,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${(progressValue * 100).toInt()}% Completed",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "$completed of $total tasks completed",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: myTasks.isEmpty
                        ? const Center(
                            child: Text(
                              "No tasks assigned yet!",
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: myTasks.length,
                            itemBuilder: (context, index) {
                              final task = myTasks[index];

                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Text(
                                    task.taskName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: task.completed
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  subtitle: Text(task.description),
                                  trailing: Checkbox(
                                    value: task.completed,
                                    onChanged: (value) async {
                                      final updatedTask = Tasks(
                                        id: task.id,
                                        taskName: task.taskName,
                                        description: task.description,
                                        employee: task.employee,
                                        completed: value ?? false,
                                      );

                                      await _db.updateTask(updatedTask);

                                      // No need for setState because StreamBuilder will auto-refresh
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
