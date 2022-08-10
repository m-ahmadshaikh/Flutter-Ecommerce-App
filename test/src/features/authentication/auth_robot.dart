import 'package:ecommerce_app/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class AuthRobot {
  final WidgetTester tester;

  AuthRobot(this.tester);

  Future<void> pumpAccountScreen({FakeAuthRepository? authRepository}) async {
    await tester.pumpWidget(ProviderScope(
        overrides: [
          if (authRepository != null)
            authRepositoryProvider.overrideWithValue(authRepository)
        ],
        child: const MaterialApp(
          home: AccountScreen(),
        )));
  }

  Future<void> tapLogoutButton() async {
    final logoutButton = find.text('Logout');
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    await tester.pump();
  }

  void expectLogoutDialogFound() {
    final alertDialog = find.text('Are you sure?');
    expect(alertDialog, findsOneWidget);
  }

  Future<void> tapCancelButton() async {
    final cancel = find.text('Cancel');
    await tester.tap(cancel);
    await tester.pump();
  }

  void expectLogoutDialogNotFound() async {
    final alertDialog = find.text('Are you sure?');

    expect(alertDialog, findsNothing);
  }

  void expectError() async {
    final alertDialog = find.text('Error');

    expect(alertDialog, findsOneWidget);
  }

  void expectNoError() async {
    final alertDialog = find.text('Error');

    expect(alertDialog, findsNothing);
  }

  Future<void> tapDialogLogoutButton() async {
    final logoutButton = find.byKey(kDialogDefaultKey);
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    await tester.pump();
  }

  void expectCircularProgressIndicator() {
    final circularIndicator = find.byType(CircularProgressIndicator);
    expect(circularIndicator, findsOneWidget);
  }

  Future<void> tapEmailAndPasswordSubmitButton() async {
    final primaryButton = find.byType(PrimaryButton);
    expect(primaryButton, findsOneWidget);
    await tester.tap(primaryButton);
    await tester.pump();
  }

  Future<void> pumpEmailAndPasswordSignInContents(
      {required EmailPasswordSignInFormType formType,
      required FakeAuthRepository authRepository,
      VoidCallback? onSignedIn}) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(authRepository)],
      child: MaterialApp(
          home: Scaffold(
              body: EmailPasswordSignInContents(
        formType: formType,
        onSignedIn: onSignedIn,
      ))),
    ));
  }

  Future<void> enterEmail({required String email}) async {
    final emailWidget = find.byKey(EmailPasswordSignInScreen.emailKey);
    expect(emailWidget, findsOneWidget);
    await tester.enterText(emailWidget, email);
  }

  Future<void> enterPassword({required String password}) async {
    final emailWidget = find.byKey(EmailPasswordSignInScreen.passwordKey);
    expect(emailWidget, findsOneWidget);
    await tester.enterText(emailWidget, password);
  }
}
