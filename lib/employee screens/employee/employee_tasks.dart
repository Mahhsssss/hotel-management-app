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
      body: StreamBuilder<List<Task>>(
        stream: _db.tasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final myTasks =
              snapshot.data?.where((t) => t.employee == widget.uid).toList() ??
              [];

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

              // 🔹 Tasks List
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
                                  final updatedTask = Task(
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
