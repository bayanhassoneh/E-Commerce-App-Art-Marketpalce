import 'package:isar/isar.dart';
import 'post.dart';
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
  late String imageUrl;
  Cartitemmodel({
    required this.id,
    required this.artistId,
    required this.title,
    required this.price,
    required this.imageUrl,
  });
  factory Cartitemmodel.fromPost(Post post) {
    return Cartitemmodel(
      id: post.id,
      artistId: post.artistId,
      title: post.title,
      price: post.price,
      imageUrl: post.imageUrl,
    );
  }
}
