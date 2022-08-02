import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductRepository {
  final List<Product> _products = kTestProducts;

  Product? getProduct({required String id}) {
    return _products.firstWhere((product) => product.id == id);
  }

  List<Product> getProductsList() {
    return _products;
  }

  Stream<List<Product>> watchProductsList() async* {
    await Future.delayed(const Duration(seconds: 3));
    yield _products;
  }

  Stream<Product?> watchProduct({required String id}) {
    return watchProductsList()
        .map((products) => products.firstWhere((product) => product.id == id));
  }

  Future<List<Product>> fetchProductList() async {
    return Future.value(_products);
  }
}

final productsRepositoryProvider =
    Provider.autoDispose<FakeProductRepository>((ref) {
  return FakeProductRepository();
});

final productsListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  final fakeRepositoryProvider = ref.watch(productsRepositoryProvider);
  return fakeRepositoryProvider.watchProductsList();
});

final productsListFutureProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  final fakeRepositoryProvider = ref.watch(productsRepositoryProvider);
  return fakeRepositoryProvider.fetchProductList();
});

final productsStreamProvider =
    StreamProvider.family.autoDispose<Product?, String>((ref, id) {
  final fakeRepositoryProvider = ref.watch(productsRepositoryProvider);
  return fakeRepositoryProvider.watchProduct(id: id);
});
