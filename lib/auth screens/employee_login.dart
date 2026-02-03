import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_de_luna/employee%20screens/admin_page.dart';
import 'package:hotel_de_luna/employee%20screens/employee_page.dart';
import 'package:hotel_de_luna/employee%20screens/receptionist_page.dart';
import '../services/auth_service.dart';

class EmployeeLoginScreen extends StatelessWidget {
  const EmployeeLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();
    final password = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFE6F4EA),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Employee Access", style: TextStyle(fontSize: 30)),
            const SizedBox(height: 24),
            _field(email, "Employee Email"),
            _field(password, "Password", obscure: true),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final user = await AuthService().login(
                  email.text,
                  password.text,
                );

                if (user != null && context.mounted) {
                  if (email.text.trim() == "admin@gmail.com") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AdminPage()),
                    );
                  } else if (email.text.trim() == "receptionist@gmail.com") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReceptionistPage(),
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => EmployeePage()),
                    );
                  }
                }
              },
              child: const Text("Sign In"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back to Guest Login"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
        obscureText: obscure,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF6F3EA),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
