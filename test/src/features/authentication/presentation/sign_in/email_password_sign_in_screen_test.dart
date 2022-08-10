import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '12345';
  MockAuthRepository authRepository = MockAuthRepository();
  setUp(() {
    authRepository = MockAuthRepository();
  });

  group('signin', () {
    testWidgets('''
    GIVEN FORMTYPE IS SIGNIN
    WHEN TAP ON SIGNIN BUTTON
    THEN SIGINWITHEMAILANDPASSWORD IS NOT CALLED
''', (tester) async {
      final r = AuthRobot(tester);
      await r.pumpEmailAndPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
      );
      await r.tapEmailAndPasswordSubmitButton();
    });
    verifyNever(
      () => authRepository.signInWithEmailAndPassword(any(), any()),
    );
    testWidgets('''
    GIVEN FORMTYPE IS SIGNIN
    WHEN ENTER EMAIL AND PASSWORD 
    AND TAP ON SIGNIN BUTTON
    THEN SIGINWITHEMAILANDPASSWORD IS CALLED
    AND NO ERROR IS SHOWN
''', (tester) async {
      final r = AuthRobot(tester);
      var didSignIn = false;
      when(
        () =>
            authRepository.signInWithEmailAndPassword(testEmail, testPassword),
      ).thenAnswer((invocation) => Future.value());
      await r.pumpEmailAndPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
        onSignedIn: () => didSignIn = true,
      );
      await r.enterEmail(email: testEmail);
      await r.enterPassword(password: testPassword);

      await r.tapEmailAndPasswordSubmitButton();

      verify(
        () =>
            authRepository.signInWithEmailAndPassword(testEmail, testPassword),
      ).called(1);

      r.expectNoError();
      expect(didSignIn, true);
    });
  });
}
