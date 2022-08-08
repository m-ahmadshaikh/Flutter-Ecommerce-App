import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeAuthRepository {
  final addDelay;
  final _authState = InMemoryStore<AppUser?>(null);

  FakeAuthRepository({this.addDelay = true});
  Stream<AppUser?> authStateChanges() => _authState.stream();
  AppUser? get currentUser => _authState.value;

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    if (currentUser == null) {
      _authState.value = _createCurrentUser(email);
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);

    _authState.value = _createCurrentUser(email);
  }

  AppUser _createCurrentUser(String email) {
    return AppUser(uid: email.split('').reversed.join(), email: email);
  }

  Future<void> signOut() async {
    _authState.value = null;
  }

  void dispose() => _authState.close();
}

final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  final authRepository = FakeAuthRepository();
  ref.onDispose(() => authRepository.dispose());
  return authRepository;
});

final authStateProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return authRepository.authStateChanges();
});
