//Need a progressbar on top with count of number of tasks of the employee
//Listview below it with the tasks. Checkbox if checked, completed ? true : false
//Reception and admin only allowed to create a task for an employee.
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
    );
  }
}
