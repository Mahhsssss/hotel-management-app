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

    // 2. Apply Location Filter (equality only)
    if (location.isNotEmpty) {
      query = query.where('location', isEqualTo: location.toUpperCase());
    }

    // 3. Room Type Filter (equality only - skip if "All Rooms")
    if (roomType.isNotEmpty && roomType != "All Rooms") {
      query = query.where('roomType', isEqualTo: roomType);
    }

    // ⚠️ NO RANGE FILTERS IN FIRESTORE!
    // We'll handle starRating and price in Dart after fetching

    // 4. Amenities Filter (arrayContainsAny is fine - it's not a range)
    if (selectedAmenities.isNotEmpty) {
      query = query.where('amenities', arrayContainsAny: selectedAmenities);
    }

    try {
      print("=== FILTER CRITERIA ===");
      print("Location: $location");
      print("Room Type: ${roomType.isEmpty ? 'ALL ROOMS' : roomType}");
      print("Star Rating (min): $starRating");
      print("Price Category: $priceCategory");
      print("Amenities selected: $selectedAmenities");

      // Get ALL hotels that match the equality filters
      final snapshot = await query.get();

      print("=== HOTELS BEFORE CLIENT FILTERING ===");
      print("Raw results: ${snapshot.docs.length}");

      // Convert to Hotel objects
      List<Hotel> allHotels = snapshot.docs.map((doc) {
        return Hotel.fromFirestore(doc.data(), doc.id);
      }).toList();

      // Apply ALL range filters in Dart
      List<Hotel> filteredHotels = allHotels.where((hotel) {
        // Filter by star rating (>=)
        if (hotel.starRating < starRating) return false;

        // Filter by price category
        if (priceCategory == "Low" && hotel.price > 5000) return false;
        if (priceCategory == "Medium" &&
            (hotel.price <= 5000 || hotel.price > 15000))
          return false;
        if (priceCategory == "High" && hotel.price <= 15000) return false;

        // All filters passed
        return true;
      }).toList();

      print("=== FINAL RESULTS ===");
      print("Hotels after client filtering: ${filteredHotels.length}");

      return filteredHotels;
    } catch (e) {
      print("❌ Error fetching filtered hotels: $e");
      return []; // Return empty list instead of crashing
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
