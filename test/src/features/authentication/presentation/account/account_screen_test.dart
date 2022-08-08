import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  testWidgets('Cancel Logout', (tester) async {
    final r = AuthRobot(tester);
    await r.pumpAccountScreen();
    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapCancelButton();
    r.expectLogoutDialogNotFound();
  });
  testWidgets('Confirm Logout, Success', (tester) async {
    final r = AuthRobot(tester);
    await r.pumpAccountScreen();
    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapDialogLogoutButton();
    r.expectLogoutDialogNotFound();
    r.expectNoError();
  });

  testWidgets('Confirm Logout, Failure', (tester) async {
    final r = AuthRobot(tester);
    final authRepository = MockAuthRepository();
    when(
      () => authRepository.authStateChanges(),
    ).thenAnswer((invocation) =>
        Stream.value(const AppUser(uid: '123', email: 'test@test.com')));
    final exception = Exception('Connection Failed');
    when(
      () => authRepository.signOut(),
    ).thenThrow(exception);

    await r.pumpAccountScreen(authRepository: authRepository);
    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapDialogLogoutButton();
    r.expectError();
  });
}
