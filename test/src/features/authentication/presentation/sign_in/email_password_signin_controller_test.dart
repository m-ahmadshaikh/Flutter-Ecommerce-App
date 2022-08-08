@Timeout(Duration(milliseconds: 500))
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_signin_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '12345';
  group('submit', () {
    test('''Given formtype EmailPasswordControllerState.signin
            When submit method run
            Then it returns True
            and state is AsyncData<void>(null)
    ''', () async {
      FakeAuthRepository authRepository = MockAuthRepository();
      when(() => authRepository.signInWithEmailAndPassword(
          testEmail, testPassword)).thenAnswer((_) => Future.value());
      final controller = EmailPasswordSignInController(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.signIn);

      expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.signIn,
                value: const AsyncLoading<void>()),
            EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.signIn,
                value: const AsyncData<void>(null)),
          ]));
      final result = await controller.submit(testEmail, testPassword);
      expectLater(result, true);
    });

    test('''Given formtype EmailPasswordControllerState.signin
            When submit method run
            Then it returns False
            and state is AsyncError(exception)
    ''', () async {
      FakeAuthRepository authRepository = MockAuthRepository();
      final exception = Exception('Connection Failed');

      when(() => authRepository.signInWithEmailAndPassword(
          testEmail, testPassword)).thenThrow((_) => exception);
      final controller = EmailPasswordSignInController(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.signIn);
      expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.signIn,
                value: const AsyncLoading<void>()),
            predicate<EmailPasswordSignInState>(
              (state) {
                expect(state.formType, EmailPasswordSignInFormType.signIn);
                expect(state.value.hasError, true);
                return true;
              },
            )
          ]));
      final result = await controller.submit(testEmail, testPassword);
      expect(result, false);
    });

    test('''Given formtype EmailPasswordControllerState.registen
            When submit method run
            Then it returns True
            and state is AsyncData<void>(null)
    ''', () async {
      FakeAuthRepository authRepository = MockAuthRepository();

      when(() => authRepository.createUserWithEmailAndPassword(
          testEmail, testPassword)).thenAnswer((_) => Future.value());
      final controller = EmailPasswordSignInController(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.register);
      expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.register,
                value: const AsyncLoading<void>()),
            predicate<EmailPasswordSignInState>(
              (state) {
                expect(state.formType, EmailPasswordSignInFormType.register);
                expect(state.value.hasError, false);
                return true;
              },
            )
          ]));
      final result = await controller.submit(testEmail, testPassword);
      expect(result, true);
    });
  });
  group('updateFormtype', () {
    test('''Given formtype EmailPasswordControllerState.register
            When updateFormType method run
            Then it returns null
            and state is Formtype.signin
    ''', () async {
      FakeAuthRepository authRepository = MockAuthRepository();

      final controller = EmailPasswordSignInController(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.register);

      controller.updateFormType(EmailPasswordSignInFormType.signIn);
      expect(
          controller.debugState.formType, EmailPasswordSignInFormType.signIn);
    });

    test('''Given formtype EmailPasswordControllerState.signin
            When updateFormType method run
            Then it returns null
            and state is Formtype.register
    ''', () async {
      FakeAuthRepository authRepository = MockAuthRepository();

      final controller = EmailPasswordSignInController(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.signIn);

      controller.updateFormType(EmailPasswordSignInFormType.register);
      expect(
          controller.debugState.formType, EmailPasswordSignInFormType.register);
    });
  });
}
