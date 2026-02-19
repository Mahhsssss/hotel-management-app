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
    query = query.where('starRating', isEqualTo: starRating);

    // 5. Price Range
    if (priceCategory == "Low") {
      query = query.where('price', isLessThanOrEqualTo: 5000);
    } else if (priceCategory == "Medium") {
      query = query
          .where('price', isGreaterThan: 5000)
          .where('price', isLessThanOrEqualTo: 15000);
    } else if (priceCategory == "High") {
      query = query.where('price', isGreaterThan: 15000);
    }

    // 6. Amenities Filter (limited to 10 items per Firestore query)
    if (selectedAmenities.isNotEmpty) {
      query = query.where('amenities', arrayContainsAny: selectedAmenities);
    }

    try {
      final snapshot = await query.get();

      // 7. Map using Hotel.fromFirestore factory
      return snapshot.docs.map((doc) {
        return Hotel.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      // Fixed: use debugPrint instead of print (avoids avoid_print lint warning)
      debugPrint("Error fetching filtered hotels: $e");
      rethrow;
    }
  }
}
