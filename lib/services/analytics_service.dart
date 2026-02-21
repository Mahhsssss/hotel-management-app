// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─────────────────────────────────────────
  // 💰 REVENUE
  // ─────────────────────────────────────────

  Future<double> getTotalRevenue() async {
    try {
      final snapshot = await _db
          .collection('BOOKINGS')
          .where('paymentStatus', isEqualTo: 'success')
          .get();
      double total = 0;
      for (var doc in snapshot.docs) {
        total += (doc.data()['totalAmount'] ?? 0).toDouble();
      }
      return total;
    } catch (e) {
      print('Error in getTotalRevenue: $e');
      return 0;
    }
  }

  Future<Map<String, double>> getRevenuePerHotel() async {
    try {
      final snapshot = await _db
          .collection('BOOKINGS')
          .where('paymentStatus', isEqualTo: 'success')
          .get();
      Map<String, double> map = {};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final hotel = data['hotelName'] ?? 'Unknown';
        map[hotel] = (map[hotel] ?? 0) + (data['totalAmount'] ?? 0).toDouble();
      }
      return map;
    } catch (e) {
      print('Error in getRevenuePerHotel: $e');
      return {};
    }
  }

  Future<Map<String, double>> getRevenuePerLocation() async {
    try {
      final snapshot = await _db
          .collection('BOOKINGS')
          .where('paymentStatus', isEqualTo: 'success')
          .get();
      Map<String, double> map = {};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final loc = data['location'] ?? 'Unknown';
        map[loc] = (map[loc] ?? 0) + (data['totalAmount'] ?? 0).toDouble();
      }
      return map;
    } catch (e) {
      print('Error in getRevenuePerLocation: $e');
      return {};
    }
  }

  Future<double> getAveragePricePerNight() async {
    try {
      final snapshot = await _db.collection('BOOKINGS').get();
      if (snapshot.docs.isEmpty) return 0;
      double total = 0;
      int count = 0;
      for (var doc in snapshot.docs) {
        final price = doc.data()['pricePerNight'];
        if (price != null) {
          total += price.toDouble();
          count++;
        }
      }
      return count > 0 ? total / count : 0;
    } catch (e) {
      print('Error in getAveragePricePerNight: $e');
      return 0;
    }
  }

  // ─────────────────────────────────────────
  // 📅 BOOKINGS
  // ─────────────────────────────────────────

  Future<int> getTotalBookings() async {
    try {
      final snapshot = await _db.collection('BOOKINGS').get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error in getTotalBookings: $e');
      return 0;
    }
  }

  Future<int> getConfirmedBookings() async {
    try {
      final snapshot = await _db
          .collection('BOOKINGS')
          .where('bookingStatus', isEqualTo: 'confirmed')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error in getConfirmedBookings: $e');
      return 0;
    }
  }

  Future<int> getSuccessfulPayments() async {
    try {
      final snapshot = await _db
          .collection('BOOKINGS')
          .where('paymentStatus', isEqualTo: 'success')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error in getSuccessfulPayments: $e');
      return 0;
    }
  }

  Future<Map<String, int>> getBookingsByStatus() async {
    try {
      final snapshot = await _db.collection('BOOKINGS').get();
      Map<String, int> map = {};
      for (var doc in snapshot.docs) {
        final status = doc.data()['bookingStatus'] ?? 'unknown';
        map[status] = (map[status] ?? 0) + 1;
      }
      return map;
    } catch (e) {
      print('Error in getBookingsByStatus: $e');
      return {};
    }
  }

  Future<Map<String, int>> getBookingsByPaymentMethod() async {
    try {
      final snapshot = await _db.collection('BOOKINGS').get();
      Map<String, int> map = {};
      for (var doc in snapshot.docs) {
        final method = doc.data()['paymentMethod'] ?? 'Unknown';
        map[method] = (map[method] ?? 0) + 1;
      }
      return map;
    } catch (e) {
      print('Error in getBookingsByPaymentMethod: $e');
      return {};
    }
  }

  Future<Map<String, int>> getBookingsPerHotel() async {
    try {
      final snapshot = await _db.collection('BOOKINGS').get();
      Map<String, int> map = {};
      for (var doc in snapshot.docs) {
        final hotel = doc.data()['hotelName'] ?? 'Unknown';
        map[hotel] = (map[hotel] ?? 0) + 1;
      }
      return map;
    } catch (e) {
      print('Error in getBookingsPerHotel: $e');
      return {};
    }
  }

  Future<Map<String, int>> getBookingsPerLocation() async {
    try {
      final snapshot = await _db.collection('BOOKINGS').get();
      Map<String, int> map = {};
      for (var doc in snapshot.docs) {
        final loc = doc.data()['location'] ?? 'Unknown';
        map[loc] = (map[loc] ?? 0) + 1;
      }
      return map;
    } catch (e) {
      print('Error in getBookingsPerLocation: $e');
      return {};
    }
  }

  Future<double> getAverageNightsPerBooking() async {
    try {
      final snapshot = await _db.collection('BOOKINGS').get();
      if (snapshot.docs.isEmpty) return 0;
      int total = 0;
      int count = 0;
      for (var doc in snapshot.docs) {
        final nights = doc.data()['numberOfNights'];
        if (nights != null) {
          total += nights as int;
          count++;
        }
      }
      return count > 0 ? total / count : 0;
    } catch (e) {
      print('Error in getAverageNightsPerBooking: $e');
      return 0;
    }
  }

  Future<double> getAverageGuestsPerBooking() async {
    try {
      final snapshot = await _db.collection('BOOKINGS').get();
      if (snapshot.docs.isEmpty) return 0;
      int total = 0;
      int count = 0;
      for (var doc in snapshot.docs) {
        final guests = doc.data()['guests'];
        if (guests != null && guests is Map) {
          final guestTotal = guests['total'];
          if (guestTotal != null) {
            total += guestTotal as int;
            count++;
          }
        }
      }
      return count > 0 ? total / count : 0;
    } catch (e) {
      print('Error in getAverageGuestsPerBooking: $e');
      return 0;
    }
  }

  Future<Map<String, int>> getBookingsByRoomType() async {
    try {
      final snapshot = await _db.collection('BOOKINGS').get();
      Map<String, int> map = {};
      for (var doc in snapshot.docs) {
        final room = doc.data()['RoomID'] ?? 'Unknown';
        map[room] = (map[room] ?? 0) + 1;
      }
      return map;
    } catch (e) {
      print('Error in getBookingsByRoomType: $e');
      return {};
    }
  }

  // ─────────────────────────────────────────
  // ✅ TASKS
  // ─────────────────────────────────────────

  Future<Map<String, int>> getTaskStats() async {
    try {
      final snapshot = await _db.collection('Tasks').get();
      int total = snapshot.docs.length;
      int completed = 0;

      for (var doc in snapshot.docs) {
        final completedValue = doc.data()['completed'];
        if (completedValue == true ||
            completedValue == 'true' ||
            completedValue == 1) {
          completed++;
        }
      }

      return {
        'total': total,
        'completed': completed,
        'pending': total - completed,
      };
    } catch (e) {
      print('Error in getTaskStats: $e');
      return {'total': 0, 'completed': 0, 'pending': 0};
    }
  }

  // ─────────────────────────────────────────
  // 👤 USERS & EMPLOYEES
  // ─────────────────────────────────────────

  Future<int> getTotalUsers() async {
    try {
      final snapshot = await _db.collection('users').get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error in getTotalUsers: $e');
      return 0;
    }
  }

  Future<Map<String, int>> getUsersByRole() async {
    try {
      final snapshot = await _db.collection('users').get();
      Map<String, int> map = {};
      for (var doc in snapshot.docs) {
        final role = doc.data()['role'] ?? 'unknown';
        map[role] = (map[role] ?? 0) + 1;
      }
      return map;
    } catch (e) {
      print('Error in getUsersByRole: $e');
      return {};
    }
  }

  Future<int> getTotalCustomers() async {
    try {
      final snapshot = await _db.collection('Customers').get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error in getTotalCustomers: $e');
      return 0;
    }
  }

  Future<int> getTotalEmployees() async {
    try {
      final snapshot = await _db.collection('Employees').get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error in getTotalEmployees: $e');
      return 0;
    }
  }
}
