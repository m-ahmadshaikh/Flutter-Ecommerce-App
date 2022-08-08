import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FakeProductRepository makeProductsRepository() =>
      FakeProductRepository(addDelay: false);
  group('Fake Authentication repository tests', () {
    test('getProductsList returns Global List', () {
      final productRepository = makeProductsRepository();
      expect(productRepository.getProductsList(), kTestProducts);
    });
    test('getProduct(100) returns null ', () {
      final productRepository = makeProductsRepository();
      expect(productRepository.getProduct(id: '100'), null);
    });

    test('fetchProductList() returns Global List', () async {
      final productRepository = makeProductsRepository();
      expect(await productRepository.fetchProductList(), kTestProducts);
    });

    test('watchProductList() returns Global List', () {
      final productRepository = makeProductsRepository();
      expect(productRepository.watchProductsList(), emits(kTestProducts));
    });
    test('watchProductList(100) returns null', () {
      final productRepository = makeProductsRepository();
      expect(productRepository.watchProduct(id: '100'), emits(null));
    });
  });
}
