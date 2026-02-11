import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TermsConditionsPage(),
    );
  }
}

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // soft green background
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                children: [

                  // Top Green Icon
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.verified_user_rounded,
                      size: 50,
                      color: Colors.green.shade700,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Title
                  Text(
                    "Terms & Conditions",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Divider
                  Container(
                    height: 3,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Scrollable Terms
                  const Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        """
Welcome to GreenStay Hotel App.

By accessing or using our application, you agree to the following terms:

1. Booking Policy
All bookings are subject to room availability and payment confirmation.

2. Payment Policy
All payments must be completed securely through the app.

3. Cancellation Policy
Cancellations must be made 24 hours prior to check-in.

4. Check-in & Check-out
Check-in: 2:00 PM
Check-out: 11:00 AM

5. User Responsibility
Users must provide accurate booking information.

6. Privacy Policy
Your personal data is securely stored and protected.

7. Liability
The hotel is not responsible for personal loss unless due to negligence.

By continuing to use this app, you accept these terms.
                        """,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
