import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hotel_model.dart';

class HotelService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Hotel>> getFilteredHotels({
    required String location,
    required String roomType,
    required int starRating,
    required List<String> selectedAmenities,
  }) async {

    Query<Map<String, dynamic>> query = _db
        .collection('hotels')
        .where('location', isEqualTo: location)
        .where('starRating', isGreaterThanOrEqualTo: starRating)
        .where('roomType', isEqualTo: roomType);

    if (selectedAmenities.isNotEmpty) {
      query = query.where(
        'amenities',
        arrayContainsAny: selectedAmenities,
      );
    }

    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) => Hotel.fromFirestore(doc.data(), doc.id))
        .toList();
  }
}
