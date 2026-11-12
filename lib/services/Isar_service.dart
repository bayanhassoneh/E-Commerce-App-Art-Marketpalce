import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:art_marketplace/models/cartItemModel.dart';

class IsarService {
  static late Isar isar;

  static Future<void> initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([CartitemmodelSchema], directory: dir.path);
    //CartitemmodelSchema هو الجدول او لسكيما جوات القاعدة المحليه  لما بعمل مودلز تانيه بسميهم جنبه كمان
  }
}
