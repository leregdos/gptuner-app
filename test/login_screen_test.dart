import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gptuner/providers/auth_state.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:gptuner/features/login/login_screen.dart';
import 'mocks.dart';

void main() {
  late MockAuthState mockAuthState;
  late MockSharedPreferences mockSharedPreferences;
  late MockHttpResponse mockResponse;

  setUp(() {
    mockAuthState = MockAuthState();
    mockSharedPreferences = MockSharedPreferences();
    mockResponse = MockHttpResponse();

    when(mockSharedPreferences.containsKey('jwtToken')).thenReturn(false);
    when(mockSharedPreferences.containsKey('expiryDate')).thenReturn(false);
    when(mockSharedPreferences.getString('jwtToken')).thenReturn('test_token');
    when(mockSharedPreferences.getString('expiryDate')).thenReturn(
        DateTime.now().add(const Duration(hours: 1)).toIso8601String());
    when(mockAuthState.tryAutoLogin()).thenAnswer((_) async => false);
    when(mockAuthState.login(any, any)).thenAnswer((_) async {});
    when(mockAuthState.isAuthenticated).thenAnswer((_) => false);
  });

  Widget makeTestableWidget({required Widget child}) {
    return ChangeNotifierProvider<AuthState>(
      create: (_) => mockAuthState,
      child: MaterialApp(home: child),
    );
  }

  testWidgets('LoginScreen renders and has basic UI elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(child: const LoginScreen()));

    // Check for presence of UI elements
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.byIcon(Icons.email), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);
    expect(find.text('Show/Hide password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text("Don't have an account?"), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('LoginScreen performs login on button tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(child: const LoginScreen()));

    // Fill in the email and password fields
    await tester.enterText(
        find.byKey(const Key("emailField")), 'test@example.com');
    await tester.enterText(
        find.byKey(const Key("passwordField")), 'password123');

    // Tap on the login button
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify if the login method was called exactly once
    verify(mockAuthState.login('test@example.com', 'password123')).called(1);
  });
}
