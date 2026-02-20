// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_de_luna/services/employee_service.dart';
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
      backgroundColor: const Color(0xFFF8FAF5), // Soft off-white background
      appBar: AppDrawer.customEmpAppBar(
        context: context,
        colors: const Color.fromARGB(255, 50, 83, 50), // Deep forest green
        overlayStyle: SystemUiOverlayStyle.dark,
        title: "Employee Tasks",
      ),
      body: StreamBuilder<List<Tasks>>(
        stream: _db.tasks,
        builder: (context, taskSnapshot) {
          if (taskSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 50, 83, 50),
              ),
            );
          }

          if (taskSnapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${taskSnapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
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
            child: Column(
              children: [
                const SizedBox(height: 120),

                // Employee welcome card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 50, 83, 50),
                        Color.fromARGB(255, 70, 110, 70),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person_outline, color: Colors.white),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome back,',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              widget.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Progress card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Daily Progress',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 50, 50, 50),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                255,
                                50,
                                83,
                                50,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$completed/$total',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 50, 83, 50),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        children: [
                          Container(
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: progressValue,
                            child: Container(
                              height: 12,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 70, 110, 70),
                                    Color.fromARGB(255, 50, 83, 50),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(
                                      255,
                                      50,
                                      83,
                                      50,
                                    ).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "${(progressValue * 100).toInt()}% Complete",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Section header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Tasks',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 50, 50, 50),
                        ),
                      ),
                      if (myTasks.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              255,
                              50,
                              83,
                              50,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            '${uncompleted_tasks.length} pending',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 50, 83, 50),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Task list
                Expanded(
                  child: myTasks.isEmpty
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
                                  Icons.task_outlined,
                                  size: 50,
                                  color: Color.fromARGB(255, 50, 83, 50),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "No tasks assigned yet!",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 100, 100, 100),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Your tasks will appear here",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
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
                          itemCount: sortedTasks.length,
                          itemBuilder: (context, index) {
                            final task = sortedTasks[index];
                            final isUncompleted =
                                index < uncompleted_tasks.length;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
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
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: isUncompleted
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.7),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isUncompleted
                                            ? [
                                                const Color.fromARGB(
                                                  255,
                                                  50,
                                                  83,
                                                  50,
                                                ),
                                                const Color.fromARGB(
                                                  255,
                                                  70,
                                                  110,
                                                  70,
                                                ),
                                              ]
                                            : [
                                                Colors.grey.shade400,
                                                Colors.grey.shade500,
                                              ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Icon(
                                      isUncompleted
                                          ? Icons.play_arrow
                                          : Icons.check,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    task.taskName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      decoration: task.completed
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: task.completed
                                          ? Colors.grey.shade500
                                          : const Color.fromARGB(
                                              255,
                                              50,
                                              50,
                                              50,
                                            ),
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        task.description,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      FutureBuilder<String>(
                                        future: _db.getEmployeeNameFromRef(
                                          task.employee,
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return _buildAssignedBySkeleton();
                                          }
                                          return Row(
                                            children: [
                                              Icon(
                                                Icons.person_outline,
                                                size: 14,
                                                color: Colors.grey.shade500,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Assigned by: ${snapshot.data ?? 'Unknown'}',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade500,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  trailing: Transform.scale(
                                    scale: 1.2,
                                    child: Checkbox(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      activeColor: const Color.fromARGB(
                                        255,
                                        50,
                                        83,
                                        50,
                                      ),
                                      value: task.completed,
                                      onChanged: (value) async {
                                        final updatedTask = Tasks(
                                          Uid: task.Uid,
                                          id: task.id,
                                          taskName: task.taskName,
                                          description: task.description,
                                          employee: task.employee,
                                          completed: value ?? false,
                                        );

                                        await _db.updateTask(updatedTask);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAssignedBySkeleton() {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 100,
          height: 11,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
