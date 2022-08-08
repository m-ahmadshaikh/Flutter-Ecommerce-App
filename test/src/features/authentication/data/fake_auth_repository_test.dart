import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '1234';
  final testUser =
      AppUser(uid: testEmail.split('').reversed.join(), email: testEmail);
  FakeAuthRepository createAuthRepository() =>
      FakeAuthRepository(addDelay: false);
  group('FakeAuthRepository', () {
    test('current user is null', () {
      final authRepository = createAuthRepository();
      addTearDown(() {
        authRepository.dispose();
      });
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });

    test('current user is not null after signin', () async {
      final authRepository = createAuthRepository();
      addTearDown(() {
        authRepository.dispose();
      });
      await authRepository.signInWithEmailAndPassword(testEmail, testPassword);
      expect(authRepository.currentUser, testUser);

      expect(authRepository.authStateChanges(), emits(testUser));
    });
    test('current user is not null after registration', () async {
      final authRepository = createAuthRepository();
      addTearDown(() {
        authRepository.dispose();
      });
      await authRepository.createUserWithEmailAndPassword(
          testEmail, testPassword);
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
    });
    test('current user is null after signout', () async {
      final authRepository = createAuthRepository();
      addTearDown(() {
        authRepository.dispose();
      });
      await authRepository.signInWithEmailAndPassword(testEmail, testPassword);
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
      await authRepository.signOut();
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });
    test('sign in after dispose throws exception', () {
      final authRepository = createAuthRepository();
      addTearDown(() {
        authRepository.dispose();
      });
      authRepository.dispose();
      expect(
        () => authRepository.signInWithEmailAndPassword(
          testEmail,
          testPassword,
        ),
        throwsStateError,
      );
    });
  });
}
