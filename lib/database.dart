class Employees {
  final String name;
  final String permissions;
  final String role;
  final double salary;
  final String uid;

  Employees({required this.name, required this.permissions, required this.role, required this.salary, required this.uid})

  factory Employees.fromFirestore(DocumentSnapshot doc) {
      
    final data = doc.data() as Map<String, dynamic>;

    return Employees(name: name, permissions: permissions, role: role, salary: salary, uid: uid)

  }
}
