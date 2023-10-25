import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gptuner/features/home/home_screen.dart';
import 'package:gptuner/providers/auth_state.dart';
import 'package:gptuner/providers/document_state.dart';
import 'package:gptuner/theme/app_theme.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'mocks.dart';

void main() {
  late MockDocumentState mockDocumentState;
  late MockAuthState mockAuthState;

  setUp(() {
    mockDocumentState = MockDocumentState();
    mockAuthState = MockAuthState();
    when(mockDocumentState.noAvailableAnswerForValidation)
        .thenAnswer((_) => true);
    when(mockDocumentState.noAvailablePromptForValidation)
        .thenAnswer((_) => true);
    when(mockDocumentState.answerPromptForValidation).thenAnswer((_) => {});
    when(mockDocumentState.promptListForValidation).thenAnswer((_) => []);
    when(mockAuthState.token).thenAnswer((_) => "token");
    when(mockDocumentState.getAnswersForValidation(any))
        .thenAnswer((_) async {});
    when(mockDocumentState.getPromptsForValidation(any))
        .thenAnswer((_) async {});
  });

  group('HomeScreen', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthState()),
            ChangeNotifierProvider(create: (_) => DocumentState()),
          ],
          child: MaterialApp(
            theme: AppTheme.getTheme(),
            home: const HomeScreen(),
          ),
        ),
      );

      expect(find.text('Welcome to GPTuner'), findsOneWidget);
      expect(find.text('Submit Prompt'), findsOneWidget);
      expect(find.text('Submit Demonstration'), findsOneWidget);
      expect(find.text('Validate Submissions'), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets(
        'navigates to SubmitPromptScreen when Submit Prompt button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthState()),
            ChangeNotifierProvider(create: (_) => DocumentState()),
          ],
          child: MaterialApp(
            theme: AppTheme.getTheme(),
            home: const HomeScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Submit Prompt'));
      await tester.pumpAndSettle();

      expect(find.text('Prompt Submission'), findsOneWidget);
    });

    testWidgets(
        'navigates to SubmitDemonstrationScreen when Submit Demonstration button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthState()),
            ChangeNotifierProvider(create: (_) => DocumentState()),
          ],
          child: MaterialApp(
            theme: AppTheme.getTheme(),
            home: const HomeScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Submit Demonstration'));
      await tester.pumpAndSettle();

      expect(find.text('Demonstration Submission'), findsOneWidget);
    });

    testWidgets(
        'navigates to ValidateSubmissionsScreen when Validate Submissions button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthState()),
            ChangeNotifierProvider(create: (_) => DocumentState()),
          ],
          child: MaterialApp(
            theme: AppTheme.getTheme(),
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.tap(find.text('Validate Submissions'));
      await tester.pump(const Duration(seconds: 10));

      expect(find.text('Validate Submissions'), findsOneWidget);
    });

    testWidgets('opens drawer when icon button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthState()),
            ChangeNotifierProvider(create: (_) => DocumentState()),
          ],
          child: MaterialApp(
            theme: AppTheme.getTheme(),
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(find.byType(Drawer), findsOneWidget);
    });
  });
}
