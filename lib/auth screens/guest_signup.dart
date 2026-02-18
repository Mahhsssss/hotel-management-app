// ============================================================
// FILE LOCATION: lib/auth screens/guest_signup.dart
// REPLACE your existing guest_signup.dart with this file
// ============================================================
// WHAT WAS ADDED (UI is completely unchanged):
//   1. Loading state with spinner on button
//   2. Firebase Auth — creates email/password account
//   3. Firestore — saves to Customers collection with your exact schema:
//      - Name
//      - Email ID
//      - userId (same as Firebase Auth UID)
//   4. Error handling — shows readable error messages
//   5. Password validation (min 6 chars)
//   6. Name validation (can't be empty)
// ============================================================

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuestSignupScreen extends StatefulWidget {
  const GuestSignupScreen({super.key});

  @override
  State<GuestSignupScreen> createState() => _GuestSignupScreenState();
}

class _GuestSignupScreenState extends State<GuestSignupScreen> {
  // Controllers — read whatever the user typed
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Controls the loading spinner on the button
  bool isLoading = false;

  // Controls password visibility toggle
  bool obscurePassword = true;

  // Clean up controllers when screen is closed
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ── MAIN SIGNUP FUNCTION ───────────────────────────────────
  Future<void> _signup() async {
    // ── Step 1: Basic validation ───────────────────────────
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty) {
      _showError('Please enter your full name');
      return;
    }
    if (email.isEmpty) {
      _showError('Please enter your email address');
      return;
    }
    if (password.isEmpty) {
      _showError('Please enter a password');
      return;
    }
    if (password.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }

    // ── Step 2: Show loading spinner ───────────────────────
    setState(() => isLoading = true);

    try {
      // ── Step 3: Create account in Firebase Auth ────────────
      // This creates the login credentials (email + password)
      final UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // credential.user is the newly created user object
      // credential.user!.uid is their unique ID from Firebase
      final String uid = credential.user!.uid;

      debugPrint('✅ Auth account created. UID = $uid');

      // ── Step 4: Save user details to Firestore ─────────────
      // Collection: Customers
      // Document ID: the Firebase Auth UID (so they match exactly)
      // This matches your database schema from the screenshot
      await FirebaseFirestore.instance
          .collection('Customers') // exact collection name from your DB
          .doc(uid) // document ID = UID
          .set({
            'Name': name, // field: Name
            'Email ID': email, // field: Email ID (matches your schema)
            'userId': uid, // field: userId (same as UID)
            'createdAt': Timestamp.now(),
          });

      debugPrint('✅ Customer saved to Firestore');

      // ── Step 5: Navigate back to login ────────────────────
      if (!mounted) return;
      setState(() => isLoading = false);

      // Show a quick success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Please log in.'),
          backgroundColor: Color(0xFF388E3C),
          duration: Duration(seconds: 2),
        ),
      );

      // Go back to the login screen
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // ── Firebase Auth specific errors ──────────────────────
      // Firebase gives us a code — we convert it to a friendly message
      setState(() => isLoading = false);

      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered. Try logging in.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'weak-password':
          message = 'Password is too weak. Use at least 6 characters.';
          break;
        case 'network-request-failed':
          message = 'No internet connection. Please check your network.';
          break;
        default:
          message = 'Signup failed: ${e.message}';
      }
      _showError(message);
      debugPrint('❌ FirebaseAuthException: ${e.code} — ${e.message}');
    } catch (e) {
      // ── Any other unexpected errors ────────────────────────
      setState(() => isLoading = false);
      _showError('Something went wrong. Please try again.');
      debugPrint('❌ Unexpected error: $e');
    }
  }

  // ── Show error as a SnackBar ───────────────────────────────
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ── BUILD — UI is EXACTLY the same as before ───────────────
  @override
  Widget build(BuildContext context) {
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

            // Name field
            _inputField(nameController, "Full Name"),
            const SizedBox(height: 16),

            // Email field
            _inputField(emailController, "Email"),
            const SizedBox(height: 16),

            // Password field with show/hide toggle
            _passwordField(),

            const SizedBox(height: 32),

            // Create Account button — shows spinner when loading
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
                // Disable button while loading so user can't tap twice
                onPressed: isLoading ? null : _signup,
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
                        "Create Account",
                        style: TextStyle(
                          color: Color(0xFF0B1F17),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Input field widget (same style as before) ──────────────
  Widget _inputField(
    TextEditingController controller,
    String hint, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: hint == "Email"
          ? TextInputType.emailAddress
          : TextInputType.text,
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
        // Eye icon to toggle password visibility
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
