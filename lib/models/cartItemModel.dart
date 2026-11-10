import 'package:isar/isar.dart';
import 'post.dart';
import 'app_user.dart';
part 'cartItemModel.g.dart';
//نفس اسم الملف

@collection
class Cartitemmodel {
  Id isarId = Isar.autoIncrement;
  @Index(unique: true)
  late String id;
  late String artistId;
  late String title;
  late double price;
  late String description;
  late String imageUrl;
  late String createdAt;
  late AppUser? profile;
  Cartitemmodel({
    required this.id,
    required this.artistId,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.profile,
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
      profile: post.profile,
    );
  }
}
