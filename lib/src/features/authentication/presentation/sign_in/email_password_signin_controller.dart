import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailPasswordSignInController
    extends StateNotifier<EmailPasswordSignInState> {
  final FakeAuthRepository authRepository;

  EmailPasswordSignInController(
      {required this.authRepository,
      required EmailPasswordSignInFormType formType})
      : super(EmailPasswordSignInState(formType: formType));

  Future<bool> submit(String email, String password) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _authenticate(email, password));
    state = state.copyWith(value: value);
    return value.hasError == false;
  }

  Future<void> _authenticate(String email, String password) {
    if (state.formType == EmailPasswordSignInFormType.signIn) {
      return authRepository.signInWithEmailAndPassword(email, password);
    } else {
      return authRepository.createUserWithEmailAndPassword(email, password);
    }
  }

  void updateFormType(EmailPasswordSignInFormType formType) {
    state =
        state.copyWith(formType: formType, value: const AsyncValue.data(null));
  }
}

final emailPasswordSignInControllerProvider = StateNotifierProvider.family
    .autoDispose<EmailPasswordSignInController, EmailPasswordSignInState,
        EmailPasswordSignInFormType>((ref, formType) {
  final auth = ref.watch(authRepositoryProvider);

  return EmailPasswordSignInController(
      authRepository: auth, formType: formType);
});
