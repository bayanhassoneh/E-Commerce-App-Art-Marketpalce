import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:art_marketplace/providers/cart_provider.dart';
import 'package:art_marketplace/services/cart_service.dart';
import 'package:art_marketplace/models/post.dart';

class MockCartService extends Mock implements cartservice {}

class FackPost extends Fake implements Post {}

void main() {
  late MockCartService mockCartService;
  late CartProvider cartProvider;

  setUp(() {
    mockCartService = MockCartService();
    cartProvider = CartProvider(mockCartService);
  });

  test('Initial state check', () {
    expect(cartProvider.cartItems.isEmpty, true);
  });
}
