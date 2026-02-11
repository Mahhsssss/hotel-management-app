import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F4), // light green background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const SizedBox(height: 20),

              // Green Icon
              Icon(
                Icons.verified_rounded,
                size: 80,
                color: Colors.green.shade700,
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                "Terms & Conditions",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),

              const SizedBox(height: 20),

              // Scrollable Terms
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    """
Welcome to GreenStay Hotel App.

By accessing or using our application, you agree to comply with and be bound by the following terms and conditions.

1. Booking Policy
All room bookings are subject to availability. Confirmation will be sent via email or SMS after successful payment.

2. Payment Policy
Payments must be completed through the secure payment gateway provided in the app. GreenStay is not responsible for third-party transaction issues.

3. Cancellation Policy
Cancellations must be made at least 24 hours before check-in time. Late cancellations may result in charges.

4. Check-in / Check-out
Standard check-in time is 2:00 PM and check-out time is 11:00 AM. Early check-in or late check-out is subject to availability.

5. User Responsibilities
Users must provide accurate personal details during booking. Any misuse of the app may result in account suspension.

6. Privacy
We value your privacy. Personal information is stored securely and will not be shared without consent.

7. Liability
GreenStay is not liable for any loss, damage, or injury occurring during your stay unless caused by proven negligence.

By continuing to use this app, you acknowledge that you have read and agreed to these terms.
                    """,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
