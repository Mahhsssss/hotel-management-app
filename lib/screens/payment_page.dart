// FILE LOCATION: lib/screens/payment_page.dart
// PASTE THIS — replaces your current file completely
// NO qr_flutter needed. NO withOpacity. Loading is an overlay not full screen.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/hotel_model.dart';
import 'payment_success_page.dart';

class PaymentPage extends StatefulWidget {
  final Hotel hotel;
  final DateTime checkIn;
  final DateTime checkOut;
  final int adults;
  final int children;
  final int totalPrice;

  const PaymentPage({
    super.key,
    required this.hotel,
    required this.checkIn,
    required this.checkOut,
    required this.adults,
    required this.children,
    required this.totalPrice,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int selectedTab = 0;
  bool isLoading = false;
  String errorMessage = ''; // shown on screen if something fails

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
  static const String upiId = 'hoteldeLuna@upi';

  Future<void> _saveBookingAndNavigate(String paymentMethod) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      // Print to terminal so you can see what's happening
      debugPrint('▶ Trying to save booking...');
      debugPrint(
        '▶ Logged in user: ${user?.uid ?? "NOT LOGGED IN — saving as guest"}',
      );
      debugPrint('▶ Hotel: ${widget.hotel.name}');
      debugPrint('▶ Price: ${widget.totalPrice}');

      final docRef = FirebaseFirestore.instance.collection('bookings').doc();

      await docRef.set({
        'hotelName': widget.hotel.name,
        'hotelId': widget.hotel.id,
        'userId': user?.uid ?? 'guest',
        'price': widget.totalPrice,
        'guests': {'adults': widget.adults, 'children': widget.children},
        'dates': {
          'checkIn': _fmt(widget.checkIn),
          'checkOut': _fmt(widget.checkOut),
        },
        'paymentMethod': paymentMethod,
        'paymentStatus': 'paid',
        'createdAt': Timestamp.now(),
      });

      debugPrint('✅ Booking saved! ID = ${docRef.id}');

      if (!mounted) return;
      setState(() => isLoading = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentSuccessPage(
            bookingId: docRef.id,
            hotelName: widget.hotel.name,
            checkIn: widget.checkIn,
            checkOut: widget.checkOut,
            totalPrice: widget.totalPrice,
          ),
        ),
      );
    } catch (e) {
      debugPrint('❌ ERROR saving booking: $e');

      if (!mounted) return;
      setState(() {
        isLoading = false;
        // Show error directly on screen — never gets hidden
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _handleGooglePay() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    await Future.delayed(const Duration(seconds: 2));
    await _saveBookingAndNavigate('Google Pay');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF388E3C),
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      // Stack lets loading overlay sit ON TOP — not replace the whole screen
      body: Stack(
        children: [
          // ── Main scrollable content ──────────────────────────
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _orderSummaryCard(),
                const SizedBox(height: 24),

                // ── Error box — visible on screen if write fails ─
                if (errorMessage.isNotEmpty) _errorBox(),

                const Text(
                  'Choose Payment Method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                _tabRow(),
                const SizedBox(height: 20),
                if (selectedTab == 0) _googlePaySection(),
                if (selectedTab == 1) _upiSection(),
                const SizedBox(height: 30),
              ],
            ),
          ),

          // ── Loading overlay — appears on top when saving ─────
          if (isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.55),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      'Processing payment...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please wait',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Error box shown directly on screen ─────────────────────
  Widget _errorBox() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text(
                'Payment Failed',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: TextStyle(color: Colors.red.shade800, fontSize: 13),
          ),
          const SizedBox(height: 8),
          const Text(
            '👉 Fix: Go to Firebase Console → Firestore → Rules\n'
            '   and change to: allow read, write: if true;',
            style: TextStyle(color: Colors.black87, fontSize: 12, height: 1.6),
          ),
        ],
      ),
    );
  }

  // ── Order Summary Card ─────────────────────────────────────
  Widget _orderSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.hotel.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                '${_fmt(widget.checkIn)}  →  ${_fmt(widget.checkOut)}',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.people, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                '${widget.adults} Adult${widget.adults > 1 ? 's' : ''}'
                '${widget.children > 0 ? ', ${widget.children} Child${widget.children > 1 ? 'ren' : ''}' : ''}',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹ ${widget.totalPrice}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF388E3C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Tab Row ────────────────────────────────────────────────
  Widget _tabRow() {
    return Row(
      children: [
        _tabButton(label: 'Google Pay', index: 0, icon: Icons.payment),
        const SizedBox(width: 12),
        _tabButton(label: 'UPI / Bank', index: 1, icon: Icons.account_balance),
      ],
    );
  }

  Widget _tabButton({
    required String label,
    required int index,
    required IconData icon,
  }) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF388E3C) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF388E3C), width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF388E3C),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF388E3C),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Google Pay Section ─────────────────────────────────────
  Widget _googlePaySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'G\nPay',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A73E8),
                  height: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Pay with Google Pay',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Fast, secure, and simple.\nTap the button below to pay instantly.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A73E8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
              ),
              onPressed: isLoading ? null : _handleGooglePay,
              child: Text(
                'Pay  ₹${widget.totalPrice}  via Google Pay',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── UPI Section ────────────────────────────────────────────
  Widget _upiSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance,
              color: Color(0xFF388E3C),
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Pay via UPI / Bank Transfer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Amount: ₹${widget.totalPrice}',
            style: const TextStyle(
              fontSize: 17,
              color: Color(0xFF388E3C),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF388E3C), width: 1.5),
            ),
            child: Column(
              children: [
                const Text(
                  'UPI ID',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      upiId,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B5E20),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(const ClipboardData(text: upiId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('UPI ID copied!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.copy_rounded,
                        size: 20,
                        color: Color(0xFF388E3C),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _stepTile('1', 'Open PhonePe, Paytm, GPay, or any UPI app'),
          _stepTile('2', 'Enter UPI ID above and the amount'),
          _stepTile('3', 'Complete the payment in your UPI app'),
          _stepTile('4', 'Come back here and tap the button below'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF388E3C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
              ),
              onPressed: isLoading
                  ? null
                  : () => _saveBookingAndNavigate('UPI Transfer'),
              child: const Text(
                '✓  I have completed the payment',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepTile(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Color(0xFF388E3C),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                text,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
