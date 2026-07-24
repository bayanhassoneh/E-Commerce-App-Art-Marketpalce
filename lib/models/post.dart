class Post {
  final String id;
  final String artistId;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  final String createdAt;

  Post({
    required this.id,
    required this.artistId,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
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
