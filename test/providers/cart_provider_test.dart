import 'package:art_marketplace/models/post.dart';
import 'package:art_marketplace/providers/auth_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:art_marketplace/providers/cart_provider.dart';
import 'package:art_marketplace/services/cart_service.dart';
//import 'package:supabase_flutter/supabase_flutter.dart';
import '../helpers/test_data.dart';

class MockCartService extends Mock implements CartService {}

class MockAuthProvider extends Mock implements AuthProvider {}
//نسخه مزيفه من السيرفيس عشان التيست ما يتواصل مع قاعدة البيانات بشكل مباشر ويفحص البروفايدر فقط
//بتمثل السيرفس الحقيقية بس بدون ما تنفذ أي كود حقيقي.

//class FakePost extends Fake implements Post {}
//نحتاج نمرر منتج وهمي داخل الاختبارات لاحقاً، بنحتاج نعرف لـ mocktail كيف يتعامل مع كلاس الـ Post.
//بستخدم فيك بوست لو كان كلاسه معقد و جواته مراجع او قاعدة بيانات معقده

void main() {
  late MockCartService mockCartService;
  late MockAuthProvider mockAuthProvider;
  late CartProvider cartProvider;
  setUpAll(() {
    registerFallbackValue(TestPost(id: '0', price: 12.0));
    registerFallbackValue(<Post>[]);
  });
  setUp(() {
    mockCartService = MockCartService();
    mockAuthProvider = MockAuthProvider();
    when(() => mockAuthProvider.currentUserId).thenReturn('user');
    when(() => mockCartService.saveLocalItems(any())).thenAnswer((_) async {});
    cartProvider = CartProvider(
      mockCartService,
      authProvider: mockAuthProvider,
    );
  });

  test('Initial state check', () {
    expect(cartProvider.cartItems.isEmpty, true);
  });
  group('add to cart', () {
    test('adds item, calls service with current user, and notifies', () async {
      final item = TestPost(id: '0', price: 1.0);
      when(
        () => mockCartService.addToCart(
          item: any(named: 'item'),
          userid: any(named: 'userid'),
        ),
      ).thenAnswer((_) async {});

      var notified = 0;
      cartProvider.addListener(() => notified++);
      await cartProvider.addToCart(item);
      expect(cartProvider.cartItems, item);
      expect(cartProvider.errorMessage, isEmpty);
      expect(notified, 1);
      verify(
        () => mockCartService.addToCart(item: item, userid: 'user'),
      ).called(1);
    });
  });
}
