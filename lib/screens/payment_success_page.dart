// lib/screens/payment_success_page.dart
//
// LOGIC CHANGES ONLY — UI IS IDENTICAL TO ORIGINAL:
// 1. Now receives `bookingData` + `totalAmount` instead of
//    separate checkIn/checkOut/totalPrice params.
// 2. Shows same rows as original + guests and amenities.
// Every widget, animation, colour, style is unchanged.

import 'package:flutter/material.dart';
import '../models/booking_data.dart';
import '../hotel screens/hotel_homepage.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String bookingId;
  final String hotelName;
  final BookingData bookingData; // ← replaces checkIn/checkOut
  final int totalAmount; // ← replaces totalPrice

  const PaymentSuccessPage({
    super.key,
    required this.bookingId,
    required this.hotelName,
    required this.bookingData,
    required this.totalAmount,
  });

  String get shortId => bookingId.length >= 8
      ? bookingId.substring(0, 8).toUpperCase()
      : bookingId.toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const Spacer(),
              _checkIcon(),
              const SizedBox(height: 24),
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F5F45),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Your booking is confirmed 🎉',
                style: TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _bookingCard(),
              const Spacer(),
              _backToHomeButton(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Unchanged from original
  Widget _checkIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) =>
          Transform.scale(scale: value, child: child),
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          color: const Color(0xFF3F5F45),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3F5F45).withValues(alpha: 0.35),
              blurRadius: 24,
              spreadRadius: 4,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(Icons.check_rounded, size: 75, color: Colors.white),
      ),
    );
  }

  Widget _bookingCard() {
    final data = bookingData;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _detailRow(
            icon: Icons.confirmation_number_outlined,
            label: 'Booking ID',
            value: shortId,
            valueColor: const Color(0xFF3F5F45),
          ),
          _divider(),
          _detailRow(
            icon: Icons.hotel_outlined,
            label: 'Hotel',
            value: hotelName,
          ),
          _divider(),
          _detailRow(
            icon: Icons.login_outlined,
            label: 'Check-in',
            value: data.checkInDisplay,
          ),
          _divider(),
          _detailRow(
            icon: Icons.logout_outlined,
            label: 'Check-out',
            value: data.checkOutDisplay,
          ),
          _divider(),
          _detailRow(
            icon: Icons.people_outline,
            label: 'Guests',
            value:
                '${data.adults} Adult${data.adults > 1 ? 's' : ''}'
                '${data.children > 0 ? ', ${data.children} Child${data.children > 1 ? 'ren' : ''}' : ''}',
          ),
          if (data.selectedAmenities.isNotEmpty) ...[
            _divider(),
            _detailRow(
              icon: Icons.star_outline,
              label: 'Amenities',
              value: data.selectedAmenities.join(', '),
            ),
          ],
          _divider(),
          _detailRow(
            icon: Icons.currency_rupee,
            label: 'Amount Paid',
            value: '₹ $totalAmount',
            valueColor: const Color(0xFF3F5F45),
          ),
        ],
      ),
    );
  }

  // Unchanged from original
  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF3F5F45), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: valueColor ?? Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, thickness: 1);

  // Unchanged from original
  Widget _backToHomeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3F5F45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 3,
        ),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => HotelHomepage()),
            (route) => false,
          );
        },
        child: const Text(
          '🏠   Back to Home',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
