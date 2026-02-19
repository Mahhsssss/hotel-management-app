// lib/models/booking_data.dart
//
// Simple data carrier passed between every booking screen.
// One object instead of 8+ separate constructor parameters.

class BookingData {
  final String location;
  final DateTime checkIn;
  final DateTime checkOut;
  final int adults;
  final int children;
  final List<String> selectedAmenities;

  // Filled in on FinalBookingDetailsPage
  String userName;
  String userEmail;
  String userPhone;

  BookingData({
    required this.location,
    required this.checkIn,
    required this.checkOut,
    required this.adults,
    required this.children,
    required this.selectedAmenities,
    this.userName = '',
    this.userEmail = '',
    this.userPhone = '',
  });

  int get totalGuests => adults + children;
  int get numberOfNights => checkOut.difference(checkIn).inDays;

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String get checkInDisplay => _fmt(checkIn);
  String get checkOutDisplay => _fmt(checkOut);
}
