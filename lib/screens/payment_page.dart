import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/hotel_model.dart';
import '../models/booking_data.dart';
import 'payment_success_page.dart';

class PaymentPage extends StatefulWidget {
  final Hotel hotel;
  final BookingData bookingData; // ← replaces checkIn/checkOut/adults/children
  final int totalAmount; // ← replaces totalPrice

  const PaymentPage({
    super.key,
    required this.hotel,
    required this.bookingData,
    required this.totalAmount,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int selectedTab = 0;
  bool isLoading = false;
  String errorMessage = '';

  static const String upiId = 'hoteldeLuna@upi';

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';

  // ── Save to Firestore matching BOOKINGS schema, then navigate ─
  Future<void> _saveBookingAndNavigate(String paymentMethod) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      final data = widget.bookingData;
      final hotel = widget.hotel;

      debugPrint('▶ Saving booking...');

      final docRef = FirebaseFirestore.instance.collection('BOOKINGS').doc();

      // Fields match your BOOKINGS database schema exactly:
      // CustomerID, HotelID, RoomID (from screenshots)
      // + extra fields for a complete booking record
      await docRef.set({
        // Core schema fields from DB screenshots
        'CustomerID': user?.uid ?? 'guest',
        'HotelID': hotel.id,
        'RoomID': hotel.roomType,

        // Full booking details
        'hotelName': hotel.name,
        'location': hotel.location,
        'checkIn': _fmt(data.checkIn),
        'checkOut': _fmt(data.checkOut),
        'numberOfNights': data.numberOfNights,
        'guests': {
          'adults': data.adults,
          'children': data.children,
          'total': data.totalGuests,
        },
        'selectedAmenities': data.selectedAmenities,
        'pricePerNight': hotel.price,
        'totalAmount': widget.totalAmount,
        'paymentMethod': paymentMethod,
        'paymentStatus': 'success',
        'bookingStatus': 'confirmed',
        'createdAt': Timestamp.now(),
      });

      debugPrint('✅ Booking saved! ID = ${docRef.id}');

      if (!mounted) return;
      setState(() => isLoading = false);

      // Navigate to success — only after successful Firestore write
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentSuccessPage(
            bookingId: docRef.id,
            hotelName: hotel.name,
            bookingData: widget.bookingData,
            totalAmount: widget.totalAmount,
          ),
        ),
      );
    } catch (e) {
      debugPrint('❌ Error: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
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

          // ── Loading overlay ───────────────────────────────────
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

  // ── Error box — unchanged ────────────────────────────────────
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

  // ── Order Summary Card — same layout, updated to use bookingData ─
  Widget _orderSummaryCard() {
    final data = widget.bookingData;
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
                '${data.checkInDisplay}  →  ${data.checkOutDisplay}',
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
                '${data.adults} Adult${data.adults > 1 ? 's' : ''}'
                '${data.children > 0 ? ', ${data.children} Child${data.children > 1 ? 'ren' : ''}' : ''}',
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
                '₹ ${widget.totalAmount}',
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

  // ── Tab Row — exact original with AnimatedContainer + icon ───
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

  // ── Google Pay Section — unchanged ───────────────────────────
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
                'Pay  ₹${widget.totalAmount}  via Google Pay',
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

  // ── UPI Section — QR Code version ───────────────────────────
  Widget _upiSection() {
    // Standard UPI deep-link format — works with GPay, PhonePe, Paytm, etc.
    // Format: upi://pay?pa=UPI_ID&pn=NAME&am=AMOUNT&cu=INR&tn=NOTE
    final String upiUrl =
        'upi://pay?pa=$upiId&pn=Hotel%20De%20Luna&am=${widget.totalAmount}&cu=INR&tn=Hotel%20Booking';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Scan & Pay via UPI',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Amount: ₹${widget.totalAmount}',
            style: const TextStyle(
              fontSize: 17,
              color: Color(0xFF388E3C),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),

          // ── QR Code ───────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF388E3C), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: QrImageView(
              data: upiUrl,
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Color(0xFF1B5E20),
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Color(0xFF1B5E20),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── UPI ID below QR with copy button ─────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF388E3C), width: 1.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  color: Color(0xFF388E3C),
                  size: 18,
                ),
                const SizedBox(width: 8),
                const Text(
                  upiId,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                    letterSpacing: 0.5,
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
                    size: 18,
                    color: Color(0xFF388E3C),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _stepTile('1', 'Open GPay, PhonePe, Paytm or any UPI app'),
          _stepTile('2', 'Tap "Scan QR" and scan the code above'),
          _stepTile('3', 'Confirm the amount and complete payment'),
          _stepTile('4', 'Come back and tap the button below'),

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
