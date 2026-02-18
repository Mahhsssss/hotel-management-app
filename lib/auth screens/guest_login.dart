import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../hotel screens/hotel_homepage.dart';
import 'guest_signup.dart';
import 'employee_login.dart';

class GuestLoginScreen extends StatefulWidget {
  const GuestLoginScreen({super.key});

  @override
  State<GuestLoginScreen> createState() => _GuestLoginScreenState();
}

class _GuestLoginScreenState extends State<GuestLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ── MAIN LOGIN FUNCTION ────────────────────────────────────
  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // ── Step 1: Basic validation ───────────────────────────
    if (email.isEmpty) {
      _showError('Please enter your email address');
      return;
    }
    if (password.isEmpty) {
      _showError('Please enter your password');
      return;
    }

    // ── Step 2: Show loading ───────────────────────────────
    setState(() => isLoading = true);

    try {
      // ── Step 3: Sign in with Firebase Auth ────────────────
      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      debugPrint('✅ Login success. UID = ${credential.user!.uid}');

      // ── Step 4: Navigate to Hotel Homepage ─────────────────
      if (!mounted) return;
      setState(() => isLoading = false);

      // Use pushReplacement so back button doesn't go back to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HotelHomepage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);

      // Convert Firebase error codes to human-readable messages
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email. Please sign up first.';
          break;
        case 'wrong-password':
          message = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'invalid-credential':
          // Newer Firebase versions use this instead of wrong-password
          message = 'Email or password is incorrect. Please try again.';
          break;
        case 'user-disabled':
          message = 'This account has been disabled. Contact support.';
          break;
        case 'too-many-requests':
          message =
              'Too many failed attempts. Please wait a moment and try again.';
          break;
        case 'network-request-failed':
          message = 'No internet connection. Please check your network.';
          break;
        default:
          message = 'Login failed: ${e.message}';
      }

      _showError(message);
      debugPrint('❌ FirebaseAuthException: ${e.code} — ${e.message}');
    } catch (e) {
      setState(() => isLoading = false);
      _showError('Something went wrong. Please try again.');
      debugPrint('❌ Unexpected error: $e');
    }
  }

  // ── Show error as Snackbar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
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

            // Email field
            _field(
              emailController,
              "Email",
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Password field with show/hide toggle
            _passwordField(),

            const SizedBox(height: 24),

            // Login button — spinner when loading
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA6C94A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: isLoading ? null : _login,
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Color(0xFF0B1F17),
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        "Login",
                        style: TextStyle(
                          color: Color(0xFF0B1F17),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            // Create Account link
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GuestSignupScreen()),
                );
              },
              child: const Text(
                "Create Account",
                style: TextStyle(color: Color(0xFF388E3C)),
              ),
            ),

            // Employee login link
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmployeeLoginScreen(),
                  ),
                );
              },
              child: const Text(
                "Are you an employee?",
                style: TextStyle(color: Color(0xFF388E3C)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Standard text input field ──────────────────────────────
  Widget _field(
    TextEditingController c,
    String hint, {
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: c,
      obscureText: obscure,
      keyboardType: keyboardType,
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

  // ── Password field with show/hide eye icon ─────────────────
  Widget _passwordField() {
    return TextField(
      controller: passwordController,
      obscureText: obscurePassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF6F3EA),
        hintText: 'Password',
        hintStyle: const TextStyle(color: Color(0xFF7FA89A)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF7FA89A),
          ),
          onPressed: () => setState(() => obscurePassword = !obscurePassword),
        ),
      ),
    );
  }
}
