import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gptuner/providers/auth_state.dart';
import 'package:gptuner/theme/app_theme.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:gptuner/features/signup/signup_screen.dart';
import 'mocks.dart';

void main() {
  group('SignupScreen', () {
    late MockAuthState mockAuthState;

    setUp(() {
      mockAuthState = MockAuthState();
      when(mockAuthState.signup(any, any, any, any)).thenAnswer((_) async {});
      when(mockAuthState.isAuthenticated).thenAnswer((_) => false);
    });

    testWidgets('renders all fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthState>.value(value: mockAuthState),
          ],
          child: const MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.byType(InkWell), findsNWidgets(2));
    });

    testWidgets('disables button when form is invalid',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthState>.value(value: mockAuthState),
          ],
          child: const MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      final nameField = find.byKey(const Key('nameFieldSignup'));
      final emailField = find.byKey(const Key('emailFieldSignup'));
      final passwordField = find.byKey(const Key('passwordFieldSignup'));
      final confirmPasswordField =
          find.byKey(const Key('passwordConfirmFieldSignup'));

      // Fill in the form with invalid data
      await tester.enterText(nameField, '');
      await tester.enterText(emailField, 'invalid-email');
      await tester.enterText(passwordField, 'password');
      await tester.enterText(confirmPasswordField, 'different-password');

      await tester.pump();

      final button = tester.widget<Container>(find.byKey(
        const Key("signupButtonContainer"),
      ));
      final decoration = button.decoration as BoxDecoration;
      // Ensure the button is disabled
      expect(decoration.color, AppTheme.getTheme().disabledColor);
    });

    testWidgets('enables button when form is valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthState>.value(value: mockAuthState),
          ],
          child: const MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      final nameField = find.byKey(const Key('nameFieldSignup'));
      final emailField = find.byKey(const Key('emailFieldSignup'));
      final passwordField = find.byKey(const Key('passwordFieldSignup'));
      final confirmPasswordField =
          find.byKey(const Key('passwordConfirmFieldSignup'));

      // Fill in the form with valid data
      await tester.enterText(nameField, 'John Doe');
      await tester.enterText(emailField, 'john.doe@example.com');
      await tester.enterText(passwordField, 'password');
      await tester.enterText(confirmPasswordField, 'password');

      await tester.pump();

      final button = tester.widget<Container>(find.byKey(
        const Key("signupButtonContainer"),
      ));
      final decoration = button.decoration as BoxDecoration;
      // Ensure the button is enabled
      expect(decoration.color, AppTheme.getTheme().colorScheme.background);
    });

    testWidgets('calls signup method when form is submitted',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthState>.value(value: mockAuthState),
          ],
          child: const MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      final nameField = find.byKey(const Key('nameFieldSignup'));
      final emailField = find.byKey(const Key('emailFieldSignup'));
      final passwordField = find.byKey(const Key('passwordFieldSignup'));
      final confirmPasswordField =
          find.byKey(const Key('passwordConfirmFieldSignup'));
      final button = find.byKey(const Key('signupButton'));

      // Fill in the form with valid data
      await tester.enterText(nameField, 'John Doe');
      await tester.enterText(emailField, 'john.doe@example.com');
      await tester.enterText(passwordField, 'password');
      await tester.enterText(confirmPasswordField, 'password');

      // Submit the form
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Ensure the signup method was called with the correct arguments
      verify(mockAuthState.signup(
        'john.doe@example.com',
        'password',
        'John Doe',
        'password',
      )).called(1);
    });
  });
}
