<<<<<<< HEAD
// ignore_for_file: avoid_print

=======
//Need a progressbar on top with count of number of tasks of the employee
//Listview below it with the tasks. Checkbox if checked, completed ? true : false
//Reception and admin only allowed to create a task for an employee.
>>>>>>> main
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_de_luna/database.dart';
import 'package:hotel_de_luna/services/header.dart';

class EmployeeTasks extends StatefulWidget {
  final String uid;
<<<<<<< HEAD
  final String name;
  const EmployeeTasks({super.key, required this.uid, required this.name});
=======

  const EmployeeTasks({super.key, required this.uid});
>>>>>>> main

  @override
  State<EmployeeTasks> createState() => _EmployeeTasksState();
}

class _EmployeeTasksState extends State<EmployeeTasks> {
  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFE8F4EA),
      appBar: AppDrawer.customEmpAppBar(
        context: context,
        colors: Colors.black,
        overlayStyle: SystemUiOverlayStyle.dark,
      ),
      endDrawer: const AppDrawer(),
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
              (taskSnapshot.data as List?)?.where((task) {
                return task.Uid == widget.uid;
              }).toList() ??
              [];

          print("Tasks found for this employee: ${myTasks.length}");

          int total = myTasks.length;
          int completed = myTasks.where((t) => t.completed).length;
          double progressValue = total == 0 ? 0.0 : completed / total;

          return Column(
            children: [
              const SizedBox(height: 120),

              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progressValue,
                      constraints: BoxConstraints(),
                      strokeWidth: 8,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
=======
    return StreamBuilder(
      stream: _db.employees, // Listen to the employees collection
      builder: (context, empSnapshot) {
        if (!empSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Find the currentUser profile info
        final currentUser = empSnapshot.data!.firstWhere(
          (e) => e.uid == widget.uid,
        );
        {
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Color(0xFFE8F4EA),
            appBar: AppDrawer.customAppBar(
              context: context,
              colors: Colors.white,
              overlayStyle: SystemUiOverlayStyle.light,
            ),
            endDrawer: const AppDrawer(),
            body: StreamBuilder<List<Task>>(
              stream: _db.tasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final myTasks =
                    snapshot.data
                        ?.where((t) => t.employee == widget.uid)
                        .toList() ??
                    [];

                int total = myTasks.length;
                int completed = myTasks.where((t) => t.completed).length;
                double progressValue = total == 0 ? 0.0 : completed / total;

                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 9,
                      child: Row(
                        children: [
                          CircularProgressIndicator(
                            value: progressValue,
                            strokeWidth: 8,
                            color: Colors.black,
                          ),
                          Text("${(progressValue * 100).toInt()}"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: myTasks.isEmpty
                          ? const Center(child: Text("No tasks"))
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              itemCount: myTasks.length,
                              itemBuilder: (context, index) {
                                final task = myTasks[index];

                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: CheckboxListTile(
                                    value: task.completed,
                                    onChanged: (bool? newValue) {
                                      task.completed = newValue ?? false;
                                      _db.updateTask(task);
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                    if (currentUser.permissions != "null")
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Add Tasks"),
                      ),
                  ],
                );
              },
            ),
          );
        }
      },
>>>>>>> main
    );
  }
}
