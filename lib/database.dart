// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

// --- MODELS ---

class Employee {
  final String docId;
  final String Name;
  final String Permissions;
  final String Role;
  final String Salary;
  final String Uid;

  Employee({
    required this.docId,
    required this.Name,
    required this.Permissions,
    required this.Role,
    required this.Salary,
    required this.Uid,
  });

  factory Employee.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Employee(
      docId: doc.id,
      Uid: data['Uid']?.toString() ?? 'Unknown',
      Name: data['Name']?.toString() ?? 'Unknown',
      Permissions: data['Permissions']?.toString() ?? 'None',
      Role: data['Role']?.toString() ?? 'Employee',
      Salary: data['Salary']?.toString() ?? 'none',
    );
  }

  String toStringValue(dynamic value) {
    if (value == null) return 'Unknown';
    if (value is String) return value;
    if (value is int) return value.toString(); // Convert int to String
    if (value is double) return value.toString(); // Convert double to String
    return value.toString(); // Fallback
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': Name,
      'Permissions': Permissions,
      'Role': Role,
      'Salary': Salary,
      'Uid': Uid,
    };
  }
}

class Tasks {
  String employee;
  String taskName;
  String description;
  bool completed;
  String id;
  String Uid; // Internal ID for database operations

  Tasks({
    required this.taskName,
    required this.description,
    required this.employee,
    required this.completed,
    required this.id,
    required this.Uid,
  });

  factory Tasks.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Tasks(
      id: doc.id,
      Uid: data['Uid'] ?? '',
      taskName: data['Tasks name'] ?? '',
      description: data['description'] ?? '',
      employee: data['employee'] ?? '',
      completed: data['completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Tasks name': taskName,
      'description': description,
      'employee': employee,
      'completed': completed,
      'Uid': Uid,
    };
  }
}

// --- DATABASE SERVICE ---

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. ACCESS EMPLOYEES
  Stream<List<Employee>> get Employees {
    return _db
        .collection('Employees')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Employee.fromFirestore(doc)).toList(),
        );
  }

  // 2. ACCESS TASKS
  Stream<List<Tasks>> get tasks {
    return _db
        .collection('Tasks')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Tasks.fromFirestore(doc)).toList(),
        );
  }

  Future<void> addTask(
    String Uid,
    String name,
    String desc,
    String empName,
  ) async {
    await _db.collection('Tasks').add({
      'Uid': Uid,
      'Tasks name': name,
      'description': desc,
      'employee': empName,
      'completed': false,
    });
  }

  Future<void> updateEmployee(Employee employee) async {
    await _db
        .collection('Employees')
        .doc(employee.Uid)
        .update(employee.toMap());
  }

  Future<Employee?> getEmpFromUid(String Uid) async {
    if (Uid.isEmpty) {
      print("Error: UID is empty");
      return null;
    }

    try {
      var query = await FirebaseFirestore.instance
          .collection('Employees')
          .where('Uid', isEqualTo: Uid)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        print("No employee with UID $Uid");
        return null;
      }

      var doc = query.docs.first;
      var data = doc.data() as Map<String, dynamic>;

      return Employee(
        docId: doc.id,
        Uid: data['Uid']?.toString() ?? 'Unknown',
        Name: data['Name']?.toString() ?? 'Unknown',
        Permissions: data['Permissions']?.toString() ?? 'None',
        Role: data['Role']?.toString() ?? 'Employee',
        Salary: data['Salary']?.toString() ?? 'none',
      );
    } catch (e) {
      print('Error fetching employee by UID $Uid: $e');
      return null;
    }
  }

  Future<void> updateTask(Tasks Tasks) async {
    await _db.collection('Tasks').doc(Tasks.id).update(Tasks.toMap());
  }
}
