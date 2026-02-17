import 'package:cloud_firestore/cloud_firestore.dart';

// --- MODELS ---

class Employee {
  final String name;
  final String permissions;
  final String role;
  final String salary;
  final String uid;

  Employee({
    required this.name,
    required this.permissions,
    required this.role,
    required this.salary,
    required this.uid,
  });

  factory Employee.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Employee(
      uid: data['uid'] ?? 'Unknown',
      name: data['name'] ?? 'Unknown',
      permissions: data['permissions'] ?? 'None',
      role: data['role'] ?? 'Employee',
      salary: data['salary'] ?? 'none',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'permissions': permissions,
      'role': role,
      'salary': salary,
      'uid': uid,
    };
  }
}

class Task {
  String employee;
  String taskName;
  String description;
  bool completed;
  String id; // Internal ID for database operations

  Task({
    required this.taskName,
    required this.description,
    required this.employee,
    required this.completed,
    required this.id,
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      taskName: data['Task name'] ?? '',
      description: data['description'] ?? '',
      employee: data['employee'] ?? '',
      completed: data['completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Task name': taskName,
      'description': description,
      'employee': employee,
      'completed': completed,
    };
  }
}

// --- DATABASE SERVICE ---

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. ACCESS EMPLOYEES
  Stream<List<Employee>> get employees {
    return _db
        .collection('employees')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Employee.fromFirestore(doc)).toList(),
        );
  }

  // 2. ACCESS TASKS
  Stream<List<Task>> get tasks {
    return _db
        .collection('tasks')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList(),
        );
  }

  Future<void> addTask(String name, String desc, String empName) async {
    await _db.collection('tasks').add({
      'Task name': name,
      'description': desc,
      'employee': empName,
      'completed': false,
    });
  }

  Future<void> updateEmployee(Employee employee) async {
    await _db
        .collection('employees')
        .doc(employee.uid)
        .update(employee.toMap());
  }

  Future<void> updateTask(Task task) async {
    await _db.collection('tasks').doc(task.id).update(task.toMap());
  }
}
