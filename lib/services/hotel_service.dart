// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
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

    // 3. Room Type Filter - ONLY APPLY IF NOT EMPTY
    if (roomType.isNotEmpty) {
      query = query.where('roomType', isEqualTo: roomType);
    }

    // 4. Star Rating
    query = query.where('starRating', isGreaterThanOrEqualTo: starRating);

    // 5. Price Range
    if (priceCategory == "Low") {
      query = query.where('price', isLessThanOrEqualTo: 5000);
    } else if (priceCategory == "Medium") {
      query = query
          .where('price', isLessThanOrEqualTo: 15000)
          .where('price', isGreaterThan: 5000);
    } else if (priceCategory == "High") {
      query = query.where('price', isGreaterThan: 15000);
    }

    // 6. Amenities Filter
    if (selectedAmenities.isNotEmpty) {
      query = query.where('amenities', arrayContainsAny: selectedAmenities);
    }

    try {
      print("=== FILTER CRITERIA ===");
      print("Location: $location");
      print("Room Type: ${roomType.isEmpty ? 'ALL ROOMS' : roomType}");
      print("Star Rating: $starRating");
      print("Price Category: $priceCategory");
      print("Amenities selected: $selectedAmenities");

      final snapshot = await query.get();

      print("=== RESULTS ===");
      print("Number of hotels found: ${snapshot.docs.length}");

      return snapshot.docs.map((doc) {
        return Hotel.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print("❌ Error fetching filtered hotels: $e");
      rethrow;
    }
  }

  Future<List<Hotel>> getAllHotels() async {
    try {
      final snapshot = await _db.collection('hotels').get();
      return snapshot.docs.map((doc) {
        return Hotel.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching all hotels: $e");
      return [];
    }
  }
}
