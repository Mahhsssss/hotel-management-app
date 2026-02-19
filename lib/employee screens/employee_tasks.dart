// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_de_luna/services/database.dart';
import 'package:hotel_de_luna/services/header.dart';

class EmployeeTasks extends StatefulWidget {
  final String uid;
  final String name;

  const EmployeeTasks({super.key, required this.uid, required this.name});

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
      appBar: AppDrawer.customEmpAppBar(
        context: context,
        colors: Colors.black,
        overlayStyle: SystemUiOverlayStyle.dark,
        title: "Employee Tasks",
      ),
      body: StreamBuilder<List<Tasks>>(
        stream: _db.tasks,
        builder: (context, taskSnapshot) {
          if (taskSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (taskSnapshot.hasError) {
            return Center(child: Text('Error: ${taskSnapshot.error}'));
          }

          final myTasks =
              taskSnapshot.data?.where((task) {
                return task.Uid == widget.uid;
              }).toList() ??
              [];

          List<Tasks> uncompleted_tasks = [];
          List<Tasks> completed_tasks = [];

          for (var task in myTasks) {
            if (task.completed) {
              completed_tasks.add(task);
            } else {
              uncompleted_tasks.add(task);
            }
          }

          final sortedTasks = [...uncompleted_tasks, ...completed_tasks];

          print("Tasks found for this employee: ${myTasks.length}");

          int total = myTasks.length;
          int completed = myTasks.where((t) => t.completed).length;
          double progressValue = total == 0 ? 0.0 : completed / total;

          return Column(
            children: [
              const SizedBox(height: 120),

              // Display employee name
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Employee: ${widget.name}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Progress indicator
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

              // Task list
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
                          final task = sortedTasks[index];

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
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(task.description),
                                  const SizedBox(height: 4),
                                  // Display who assigned the task using FutureBuilder
                                  FutureBuilder<String>(
                                    future: _db.getEmployeeNameFromRef(
                                      task.employee,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text(
                                          'Assigned by: Loading...',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                            fontStyle: FontStyle.italic,
                                          ),
                                        );
                                      }
                                      return Text(
                                        'Assigned by: ${snapshot.data ?? 'Unknown'}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              trailing: Checkbox(
                                value: task.completed,
                                onChanged: (value) async {
                                  final updatedTask = Tasks(
                                    Uid: task.Uid,
                                    id: task.id,
                                    taskName: task.taskName,
                                    description: task.description,
                                    employee:
                                        task.employee, // Keep the reference
                                    completed: value ?? false,
                                  );

                                  await _db.updateTask(updatedTask);
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
      ),
    );
  }
}
