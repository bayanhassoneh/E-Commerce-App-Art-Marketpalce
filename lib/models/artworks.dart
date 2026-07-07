class Artwork {
  final String id;
  final String artistId;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  final String createdAt;

  Artwork({
    required this.id,
    required this.artistId,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });
  factory Artwork.fromMap(Map<String, dynamic> map) {
    return Artwork(
      id: map['id'] ?? '',
      artistId: map['artist_id'] ?? '',
      title: map['title'] ?? ' ',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] ?? ' ',
      imageUrl: map['image_url'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }
}
