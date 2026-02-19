// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/hotel_model.dart';

class HotelService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Hotel>> getFilteredHotels({
    required String location,
    required String roomType,
    required int starRating,
    required String priceCategory,
    required List<String> selectedAmenities,
  }) async {
    // 1. Start with the collection reference
    Query<Map<String, dynamic>> query = _db.collection('hotels');

    // 2. Apply Location Filter
    if (location.isNotEmpty) {
      query = query.where('location', isEqualTo: location.toUpperCase());
    }

    // 3. Room Type Filter
    query = query.where('roomType', isEqualTo: roomType);

    // 4. Star Rating
    query = query.where('starRating', isGreaterThanOrEqualTo: starRating);

    // 5. Price Range
    if (priceCategory == "Low") {
      query = query.where('price', isLessThanOrEqualTo: 5000);
    } else if (priceCategory == "Medium") {
      query = query.where('price', isLessThanOrEqualTo: 15000);
    } else if (priceCategory == "High") {
      query = query.where('price', isGreaterThan: 15000);
    }

    // 6. Amenities Filter
    if (selectedAmenities.isNotEmpty) {
      try {
        print("=== FILTER CRITERIA ===");
        print("Location: $location");
        print("Room Type: $roomType");
        print("Star Rating: $starRating");
        print("Price Category: $priceCategory");
        print("Amenities selected: $selectedAmenities");

        final snapshot = await query.get();

        // DEBUG: Print results
        print("=== RESULTS ===");
        print("Number of hotels found: ${snapshot.docs.length}");

        // Print first few hotels to see their details
        for (var i = 0; i < snapshot.docs.length && i < 3; i++) {
          var doc = snapshot.docs[i];
          var data = doc.data();
          print("Hotel ${i + 1}: ${data['name'] ?? 'Unknown'}");
          print("  Location: ${data['location']}");
          print("  Room Type: ${data['roomType']}");
          print("  Price: ${data['price']}");
          print("  Star Rating: ${data['starRating']}");
          print("  Amenities: ${data['amenities']}");
        }

        // 7. Map the data using your Hotel.fromFirestore factory
        return snapshot.docs.map((doc) {
          return Hotel.fromFirestore(doc.data(), doc.id);
        }).toList();
      } catch (e) {
        print("❌ Error fetching filtered hotels: $e");

        // Check if it's an index error
        if (e.toString().contains('requires an index')) {
          print(
            "⚠️ Firestore index required! Check the error message for the index creation link.",
          );
        }

        // Rethrow to handle the error in HotelFilterScreen
        rethrow;
      }
    }
    return [];
  }

  // Optional: Method to test amenities filter alone
  Future<List<Hotel>> testAmenitiesOnly(List<String> amenities) async {
    try {
      Query<Map<String, dynamic>> query = _db.collection('hotels');

      if (amenities.isNotEmpty) {
        query = query.where('amenities', arrayContainsAny: amenities);
      }

      final snapshot = await query.get();

      print("=== AMENITIES ONLY TEST ===");
      print("Testing amenities: $amenities");
      print("Hotels found: ${snapshot.docs.length}");

      return snapshot.docs.map((doc) {
        return Hotel.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print("Error in amenities test: $e");
      rethrow;
    }
  }

  // Optional: Method to get all hotels (no filters)
  Future<List<Hotel>> getAllHotels() async {
    try {
      final snapshot = await _db.collection('hotels').get();

      return snapshot.docs.map((doc) {
        return Hotel.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching all hotels: $e");
      rethrow;
    }
  }
}
