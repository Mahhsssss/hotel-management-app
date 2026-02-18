// ============================================================
// FILE LOCATION: lib/screens/final_booking_details_page.dart
// ============================================================

import 'package:flutter/material.dart';
import '../models/hotel_model.dart';
import 'payment_page.dart';

class FinalBookingDetailsPage extends StatefulWidget {
  final Hotel hotel;

  const FinalBookingDetailsPage({super.key, required this.hotel});

  @override
  State<FinalBookingDetailsPage> createState() =>
      _FinalBookingDetailsPageState();
}

class _FinalBookingDetailsPageState extends State<FinalBookingDetailsPage> {
  // These store the user's selected dates
  DateTime? checkIn;
  DateTime? checkOut;

  // Guest counts
  int adults = 1;
  int children = 0;

  // ── Calculated fields ──────────────────────────────────────
  int get numberOfNights {
    if (checkIn == null || checkOut == null) return 0;
    return checkOut!.difference(checkIn!).inDays;
  }

  int get totalPrice => numberOfNights * widget.hotel.price;

  // ── Date picker helper ─────────────────────────────────────
  Future<void> _pickDate(bool isCheckIn) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? (checkIn ?? now)
          : (checkOut ?? (checkIn ?? now).add(const Duration(days: 1))),
      firstDate: now,
      lastDate: DateTime(2030),
      builder: (context, child) {
        // Give the date picker your app's green color
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF388E3C)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkIn = picked;
          // Reset checkout if it now falls before the new check-in
          if (checkOut != null && !checkOut!.isAfter(picked)) {
            checkOut = null;
          }
        } else {
          checkOut = picked;
        }
      });
    }
  }

  // ── Build ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF388E3C),
        title: const Text(
          'Booking Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Hotel Summary Card ──────────────────────────
            _hotelSummaryCard(),
            const SizedBox(height: 24),

            // ── 2. Date Selection ──────────────────────────────
            _sectionTitle('Select Dates'),
            Row(
              children: [
                Expanded(
                  child: _dateTile(
                    label: 'Check-in',
                    date: checkIn,
                    onTap: () => _pickDate(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dateTile(
                    label: 'Check-out',
                    date: checkOut,
                    onTap: () => _pickDate(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── 3. Guest Selection ─────────────────────────────
            _sectionTitle('Guests'),
            _guestCard(),
            const SizedBox(height: 24),

            // ── 4. Price Summary (only shown when dates selected)
            if (numberOfNights > 0) ...[
              _sectionTitle('Price Summary'),
              _priceSummaryCard(),
              const SizedBox(height: 24),
            ],

            // ── 5. Proceed Button ──────────────────────────────
            _proceedButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ── Widget helpers ─────────────────────────────────────────

  Widget _hotelSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.hotel.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                widget.hotel.location,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(width: 14),
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                '${widget.hotel.starRating} Stars',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.hotel.roomType,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF388E3C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '₹ ${widget.hotel.price} per night',
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF388E3C),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _dateTile({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF388E3C), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF388E3C),
                ),
                const SizedBox(width: 6),
                Text(
                  date == null
                      ? 'Select'
                      : '${date.day}/${date.month}/${date.year}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: date == null ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _guestCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _guestRow(
            label: 'Adults',
            count: adults,
            onDecrement: adults > 1 ? () => setState(() => adults--) : null,
            onIncrement: () => setState(() => adults++),
          ),
          const Divider(height: 1),
          _guestRow(
            label: 'Children',
            count: children,
            onDecrement: children > 0 ? () => setState(() => children--) : null,
            onIncrement: () => setState(() => children++),
          ),
        ],
      ),
    );
  }

  Widget _guestRow({
    required String label,
    required int count,
    required VoidCallback? onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: const Color(0xFF388E3C),
                onPressed: onDecrement,
              ),
              SizedBox(
                width: 30,
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: const Color(0xFF388E3C),
                onPressed: onIncrement,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _summaryRow(
            '₹${widget.hotel.price}  ×  $numberOfNights night${numberOfNights > 1 ? 's' : ''}',
            '₹$totalPrice',
          ),
          const Divider(height: 20),
          _summaryRow('Total Amount', '₹$totalPrice', bold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    final style = TextStyle(
      fontSize: bold ? 17 : 15,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          value,
          style: style.copyWith(
            color: bold ? const Color(0xFF388E3C) : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _proceedButton() {
    return SizedBox(
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
        onPressed: () {
          // Validation — make sure dates are picked
          if (checkIn == null || checkOut == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select check-in and check-out dates'),
              ),
            );
            return;
          }
          if (numberOfNights < 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Check-out date must be after check-in date'),
              ),
            );
            return;
          }

          // Navigate to payment page with all booking data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentPage(
                hotel: widget.hotel,
                checkIn: checkIn!,
                checkOut: checkOut!,
                adults: adults,
                children: children,
                totalPrice: totalPrice,
              ),
            ),
          );
        },
        child: const Text(
          'Proceed to Payment  →',
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
