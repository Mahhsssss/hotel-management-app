import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class GuestSignupScreen extends StatelessWidget {
  const GuestSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Transparent status bar
        statusBarIconBrightness:
            Brightness.dark, // White icons for dark backgrounds
      ),

      child: Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              // 🌲 FULL SCREEN GREEN GRADIENT BACKGROUND
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3F5F45),
                      Color.fromARGB(255, 145, 202, 145),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              // CONTENT
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 100),

                      Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: const Color(0xFFF3F1EA),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            "assets/images/logo3.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Create Your Account",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF3F1EA),
                        ),
                      ),

                      const SizedBox(height: 60),

                      // 🏨 FORM CONTAINER
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F1EA),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _field(nameController, "Full Name"),
                            const SizedBox(height: 18),
                            _field(emailController, "Email"),
                            const SizedBox(height: 18),
                            _field(
                              passwordController,
                              "Password",
                              obscure: true,
                            ),
                            const SizedBox(height: 28),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3F5F45),
                                foregroundColor: const Color(0xFFF3F1EA),
                                minimumSize: const Size(double.infinity, 56),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
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

                                  // Show success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Account created successfully!',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  Navigator.pop(context);
                                } catch (e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                "Create Account",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Back to Login",
                                style: TextStyle(color: Color(0xFF3F5F45)),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint, {bool obscure = false}) {
    return TextField(
      controller: c,
      obscureText: obscure,
      style: const TextStyle(color: Color(0xFF3F5F45)),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE9E6DD),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
