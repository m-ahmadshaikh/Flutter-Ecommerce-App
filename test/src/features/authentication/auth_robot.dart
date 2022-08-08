import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen.dart';
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
}
