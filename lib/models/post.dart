import 'package:art_marketplace/models/cartItemModel.dart';

import 'app_user.dart';

class Post {
  final String id;
  final String artistId;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  final String createdAt;
  final AppUser? profile;
  Post({
    required this.id,
    required this.artistId,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.profile,
  });
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] ?? '',
      artistId: map['user_id'] ?? '',
      title: map['title'] ?? ' ',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] ?? ' ',
      imageUrl: map['image_url'] ?? '',
      createdAt: map['created_at'] ?? '',
      profile: map['profiles'] != null
          ? AppUser.fromMap(map['profiles'])
          : null,
    );
  }
  factory Post.fromCartItem(Cartitemmodel cartItem) {
    return Post(
      id: cartItem.id,
      artistId: cartItem.artistId,
      title: cartItem.title,
      price: cartItem.price,
      description: cartItem.description,
      imageUrl: cartItem.imageUrl,
      createdAt: cartItem.createdAt,
      profile: AppUser(
        id: cartItem.artistId,
        username: cartItem.username ?? '',
        bio: '',
        profilePicture: cartItem.userProfilePicture ?? 'Unknown User',
        socialLink: '',
        location: '',
        joinedDate: '',
        followers: 0,
        following: 0,
      ),
    );
  }
}
