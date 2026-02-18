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

    // 3. Room Type Filter
    query = query.where('roomType', isEqualTo: roomType);

    // 4. Star Rating
    // isEqualTo here to match the specific star selected, 
    // isGreaterThanOrEqualTo if you want that star nd above.
    query = query.where('starRating', isEqualTo: starRating);

    // 5. Price Range 
    if (priceCategory == "Low") {
      query = query.where('price', isLessThanOrEqualTo: 5000);
    } else if (priceCategory == "Medium") {
      // Note: Firestore might require an index for multiple range comparisons
      query = query.where('price', isGreaterThan: 5000)
                   .where('price', isLessThanOrEqualTo: 15000);
    } else if (priceCategory == "High") {
      query = query.where('price', isGreaterThan: 15000);
    }

    // 6. Amenities Filter
    // arrayContainsAny is limited to 10 items per query
    if (selectedAmenities.isNotEmpty) {
      query = query.where('amenities', arrayContainsAny: selectedAmenities);
    }

    try {
      final snapshot = await query.get();
      
      // 7. Map the data using your updated Hotel.fromFirestore factory
      return snapshot.docs.map((doc) {
        return Hotel.fromFirestore(doc.data(), doc.id);
      }).toList();
      
    } catch (e) {
      print("Error fetching filtered hotels: $e");
      // Rethrow to handle the error in (HotelFilterScreen)
      rethrow; 
    }
  }
}