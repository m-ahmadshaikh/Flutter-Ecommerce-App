import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/more_menu_button.dart';
import 'package:ecommerce_app/src/features/products/presentation/products_list/product_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'features/authentication/auth_robot.dart';
import 'mocks.dart';

class Robot {
  final WidgetTester tester;
  final AuthRobot auth;
  Robot(this.tester) : auth = AuthRobot(tester);

  Future<void> pumpMyApp() async {
    final authRepository = FakeAuthRepository(addDelay: false);
    final productReposiotry = FakeProductRepository(addDelay: false);
    await tester.pumpWidget(ProviderScope(overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      productsRepositoryProvider.overrideWithValue(productReposiotry)
    ], child: const MyApp()));
    await tester.pumpAndSettle();
  }

  void expectNProducts() {
    final finder = find.byType(ProductCard);
    expect(finder, findsNWidgets(kTestProducts.length));
  }

  Future<void> openPopUpMenu() async {
    final popUpMenu = find.byType(MoreMenuButton);
    // expect(popUpMenu, findsOneWidget);
    final ev = popUpMenu.evaluate();
    if (ev.isNotEmpty) {
    await  tester.tap(popUpMenu);
     await  tester.pumpAndSettle();
    }
  }
}
