import 'package:art_marketplace/models/post.dart';

Post TestPost({String id = 'id', String title = 'title', double price = 10.0}) {
  return Post(
    id: id,
    artistId: 'artistId',
    title: title,
    price: price,
    description: 'description',
    imageUrl: 'imageUrl',
    createdAt: 'createdAt',
  );
}
