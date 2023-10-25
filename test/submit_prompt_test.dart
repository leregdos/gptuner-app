import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gptuner/features/submit_prompt/submit_prompt.dart';
import 'package:gptuner/models/user.dart';
import 'package:gptuner/providers/auth_state.dart';
import 'package:gptuner/providers/document_state.dart';
import 'package:gptuner/shared/widgets/custom_loader.dart';
import 'package:gptuner/theme/app_theme.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'mocks.dart';

void main() {
  group('SubmitPromptScreen', () {
    late AuthState mockAuthState;
    late DocumentState mockDocumentState;

    setUp(() {
      mockAuthState = MockAuthState();
      mockDocumentState = MockDocumentState();
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthState>.value(value: mockAuthState),
            ChangeNotifierProvider<DocumentState>.value(
                value: mockDocumentState),
          ],
          child: const MaterialApp(
            home: SubmitPromptScreen(),
          ),
        ),
      );

      expect(find.text('Prompt Submission'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('submit button is disabled when text field is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthState>.value(value: mockAuthState),
            ChangeNotifierProvider<DocumentState>.value(
                value: mockDocumentState),
          ],
          child: const MaterialApp(
            home: SubmitPromptScreen(),
          ),
        ),
      );

      final submitButton = tester.widget<Container>(find.byKey(
        const Key("submitButtonContainer"),
      ));
      final decoration = submitButton.decoration as BoxDecoration;
      expect(decoration.color, AppTheme.getTheme().disabledColor);
    });

    testWidgets('submit button is enabled when text field is not empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthState>.value(value: mockAuthState),
            ChangeNotifierProvider<DocumentState>.value(
                value: mockDocumentState),
          ],
          child: const MaterialApp(
            home: SubmitPromptScreen(),
          ),
        ),
      );

      final textField = find.byType(TextField).first;
      await tester.enterText(textField, 'Test prompt');
      await tester.pump();
      final submitButton = tester.widget<Container>(find.byKey(
        const Key("submitButtonContainer"),
      ));
      final decoration = submitButton.decoration as BoxDecoration;
      expect(decoration.color, AppTheme.getTheme().backgroundColor);
    });

    testWidgets(
        'submit button calls submitPrompt on tap when text field is not empty',
        (WidgetTester tester) async {
      when(mockAuthState.user).thenReturn(
          User(uid: '123', email: "test@example.com", name: "John Doe"));
      when(mockAuthState.token).thenReturn('token');
      when(mockDocumentState.submitPrompt(any, any, any))
          .thenAnswer((_) async => true);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthState>.value(value: mockAuthState),
            ChangeNotifierProvider<DocumentState>.value(
                value: mockDocumentState),
          ],
          child: const MaterialApp(
            home: SubmitPromptScreen(),
          ),
        ),
      );

      final textField = find.byType(TextField).first;
      await tester.enterText(textField, 'Test prompt');

      final submitButton = find.text('Submit').first;
      await tester.tap(submitButton);

      verify(mockDocumentState.submitPrompt('123', 'token', 'Test prompt'))
          .called(1);
    });

    testWidgets(
        'submit button does not call submitPrompt on tap when text field is empty',
        (WidgetTester tester) async {
      when(mockAuthState.user).thenReturn(User(uid: '123'));
      when(mockAuthState.token).thenReturn('token');
      when(mockDocumentState.submitPrompt(any, any, any))
          .thenAnswer((_) async => true);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthState>.value(value: mockAuthState),
            ChangeNotifierProvider<DocumentState>.value(
                value: mockDocumentState),
          ],
          child: const MaterialApp(
            home: SubmitPromptScreen(),
          ),
        ),
      );

      final submitButton = find.text('Submit').first;
      await tester.tap(submitButton);

      verifyNever(mockDocumentState.submitPrompt(any, any, any));
    });

    testWidgets('submit button hides loader after submitting prompt',
        (WidgetTester tester) async {
      when(mockAuthState.user).thenReturn(User(uid: '123'));
      when(mockAuthState.token).thenReturn('token');
      when(mockDocumentState.submitPrompt(any, any, any))
          .thenAnswer((_) async => true);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthState>.value(value: mockAuthState),
            ChangeNotifierProvider<DocumentState>.value(
                value: mockDocumentState),
          ],
          child: const MaterialApp(
            home: SubmitPromptScreen(),
          ),
        ),
      );

      final textField = find.byType(TextField).first;
      await tester.enterText(textField, 'Test prompt');

      final submitButton = find.text('Submit').first;
      await tester.tap(submitButton);

      await tester.pumpAndSettle();

      expect(find.byKey(const Key("customLoader")), findsNothing);
    });

    testWidgets('submit button clears text field after submitting prompt',
        (WidgetTester tester) async {
      when(mockAuthState.user).thenReturn(User(uid: '123'));
      when(mockAuthState.token).thenReturn('token');
      when(mockDocumentState.submitPrompt(any, any, any))
          .thenAnswer((_) async => true);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthState>.value(value: mockAuthState),
            ChangeNotifierProvider<DocumentState>.value(
                value: mockDocumentState),
          ],
          child: const MaterialApp(
            home: SubmitPromptScreen(),
          ),
        ),
      );

      final textField = find.byType(TextField).first;
      final textFieldWidget = tester.widget<TextField>(textField);
      final TextEditingController controller = textFieldWidget.controller!;

      await tester.enterText(textField, 'Test prompt');

      final submitButton = find.text('Submit').first;
      await tester.tap(submitButton);

      await tester.pumpAndSettle();

      expect(controller.text, isEmpty);
    });
  });
}
