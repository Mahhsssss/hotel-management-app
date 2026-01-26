import 'package:flutter/material.dart';
import 'package:hotel_de_luna/hotel%20screens/hotel_homepage.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class GuestSignupScreen extends StatelessWidget {
  const GuestSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFE6F4EA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6F4EA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0B1F17)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Create Your Account",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0B1F17),
              ),
            ),
            const SizedBox(height: 32),

            _inputField(nameController, "Full Name"),
            const SizedBox(height: 16),
            _inputField(emailController, "Email"),
            const SizedBox(height: 16),
            _inputField(passwordController, "Password", obscure: true),

            const SizedBox(height: 32),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA6C94A),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () async {
                try {
                  final user = await AuthService().signup(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );

                  await FirestoreService().saveUser(
                    uid: user!.uid,
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    role: 'guest',
                  );

                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HotelHomepage()),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: const Text(
                "Create Account",
                style: TextStyle(
                  color: Color(0xFF0B1F17),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(
    TextEditingController controller,
    String hint, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF6F3EA),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF7FA89A)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
