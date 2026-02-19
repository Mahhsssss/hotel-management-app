import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_de_luna/employee%20screens/employee_main.dart';
import 'package:hotel_de_luna/services/header.dart';
import '../services/auth_service.dart';

class EmployeeLoginScreen extends StatelessWidget {
  const EmployeeLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();
    final password = TextEditingController();
    final AuthService auth = AuthService(); // Create single instance

    return Scaffold(
      appBar: AppDrawer.customEmpAppBar(
        context: context,
        colors: Colors.black,
        overlayStyle: SystemUiOverlayStyle.dark,
      ),
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
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                );

                try {
                  final user = await auth.login(
                    email.text.trim(),
                    password.text.trim(),
                  );

                  // Close loading dialog
                  if (context.mounted) Navigator.pop(context);

                  if (user != null) {
                    String uid = user.uid;
                    print("✅ Login successful! UID: $uid"); // Debug print

                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmployeeMain(uid: uid),
                        ),
                      );
                    }
                  } else {
                    // Show error message
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Login failed. Check your credentials.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
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
