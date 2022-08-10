import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/src/robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized(); 
  testWidgets('Sign IN and Sign OUT Flow ', (tester) async {
    final r = Robot(tester);
    await r.pumpMyApp();
    r.expectNProducts();
    await r.openPopUpMenu();
    await r.auth.openEmailAndPasswordSignInScreen();
    await r.auth.signInWithEmailAndPassword();
    r.expectNProducts();
    await r.openPopUpMenu();
    await r.auth.openAccountScreen();
    await r.auth.tapLogoutButton();
    await r.auth.tapDialogLogoutButton();
    r.expectNProducts();
  });
}
