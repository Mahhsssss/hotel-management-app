import 'package:flutter/material.dart';
import 'package:hotel_de_luna/hotel%20screens/hotel_homepage.dart';
import '../services/auth_service.dart';
import 'guest_signup.dart';
import 'employee_login.dart';

class GuestLoginScreen extends StatelessWidget {
  const GuestLoginScreen({super.key});

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
            const Text(
              "Welcome Back",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _field(email, "Email"),
            const SizedBox(height: 16),
            _field(password, "Password", obscure: true),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                try {
                  await AuthService().login(email.text, password.text);

                  if (!context.mounted) return;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HotelHomepage()),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Login failed: ${e.toString()}")),
                  );
                }
              },
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GuestSignupScreen()),
                );
              },
              child: const Text("Create Account"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmployeeLoginScreen(),
                  ),
                );
              },
              child: const Text("Are you an employee?"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint, {bool obscure = false}) {
    return TextField(
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
    );
  }
}
