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

  factory Hotel.fromFirestore(Map<String, dynamic> data, String id) {
    return Hotel(
      id: id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      price: data['price'] ?? 0,
      starRating: data['starRating'] ?? 0,
      description: data['description'] ?? '',
      roomType: data['roomType'] ?? '',
      amenities: List<String>.from(data['amenities'] ?? []),
      images: List<String>.from(data['images'] ?? []),
    );
  }
}
