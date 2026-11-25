import 'package:isar/isar.dart';
import 'post.dart';
import 'package:art_marketplace/core/utils/isar_helpers.dart';
part 'cartItemModel.g.dart';
//نفس اسم الملف

@collection
class Cartitemmodel {
  Id get isarId => fastHash(id);
  // @Index(unique: true)
  late String id;
  late String artistId;
  late String title;
  late double price;
  late String description;
  late String imageUrl;
  late String createdAt;
  late String? username;
  late String? userProfilePicture;
  Cartitemmodel({
    required this.id,
    required this.artistId,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.username,
    required this.userProfilePicture,
  });
  factory Cartitemmodel.fromPost(Post post) {
    return Cartitemmodel(
      id: post.id,
      artistId: post.artistId,
      title: post.title,
      price: post.price,
      description: post.description,
      imageUrl: post.imageUrl,
      createdAt: post.createdAt,
      username: post.profile?.username,
      userProfilePicture: post.profile?.profilePicture,
    );
  }
}
