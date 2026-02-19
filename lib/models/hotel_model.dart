class Hotel {
  final String id;
  final String name;
  final String location;
  final int price;
  final int starRating;
  final String description;
  final String roomType;
  final List<String> amenities;
  final List<String> images;

  Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.starRating,
    required this.description,
    required this.roomType,
    required this.amenities,
    required this.images,
  });

  // --- Factory for Firestore / Database ---
  factory Hotel.fromFirestore(Map<String, dynamic> data, String id) {
    return Hotel(
      id: id,
      name: data['name'] ?? 'Luxury Stay',
      location: data['location'] ?? 'Unknown Location',
      // Ensuring number safety for both Int and Double from Firestore
      price: (data['price'] ?? 0).toInt(),
      starRating: (data['starRating'] ?? 0).toInt(),
      description: data['description'] ?? 'No description available.',
      roomType: data['roomType'] ?? 'Standard Room',
      // Dynamic list mapping
      amenities: List<String>.from(data['amenities'] ?? []),
      images: List<String>.from(data['images'] ?? []),
    );
  }

  // --- Helper for UI price display ---
  String get formattedPrice => "₹ $price";

  // --- Map Object for saving back to Database if needed ---
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'price': price,
      'starRating': starRating,
      'description': description,
      'roomType': roomType,
      'amenities': amenities,
      'images': images,
    };
  }
}
