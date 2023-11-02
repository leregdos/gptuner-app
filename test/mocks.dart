import 'package:gptuner/models/answer.dart';
import 'package:gptuner/models/prompt.dart';
import 'package:gptuner/providers/document_state.dart';
import 'package:mockito/mockito.dart';
import 'package:gptuner/providers/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthState extends Mock implements AuthState {
  @override
  Future<bool> tryAutoLogin() async {
    return super.noSuchMethod(
      Invocation.method(#tryAutoLogin, []),
      returnValue: Future.value(false), // Default value
    );
  }

  @override
  Future<void> login(String? email, String? password) async {
    return super.noSuchMethod(
      Invocation.method(#login, [email, password]),
    );
  }

  @override
  Future<void> signup(String? email, String? password, String? name,
      String? passwordConfirm) async {
    return super.noSuchMethod(
      Invocation.method(#signup, [email, password, name, passwordConfirm]),
    );
  }

  @override
  bool get isAuthenticated {
    return super.noSuchMethod(
      Invocation.method(#tryAutoLogin, []),
      returnValue: true, // Default value
    );
  }

  @override
  String? get token {
    return super.noSuchMethod(
      Invocation.method(#token, []),
      returnValue: "token", // Default value
    );
  }
}

class MockSharedPreferences extends Mock implements SharedPreferences {
  @override
  bool containsKey(String key) => super.noSuchMethod(
        Invocation.method(#containsKey, [key]),
        returnValue: false,
      );
}

class MockDocumentState extends Mock implements DocumentState {
  @override
  List<Prompt> get promptListForValidation {
    return super.noSuchMethod(
      Invocation.method(#promptListForValidation, []),
      returnValue: <Prompt>[], // Default value
    );
  }

  @override
  Map<Answer, Prompt> get answerPromptForValidation {
    return super.noSuchMethod(
      Invocation.method(#answerPromptForValidation, []),
      returnValue: <Answer, Prompt>{}, // Default value
    );
  }

  @override
  bool get noAvailablePromptForValidation {
    return super.noSuchMethod(
      Invocation.method(#noAvailablePromptForValidation, []),
      returnValue: true, // Default value
    );
  }

  @override
  bool get noAvailableAnswerForValidation {
    return super.noSuchMethod(
      Invocation.method(#noAvailableAnswerForValidation, []),
      returnValue: true, // Default value
    );
  }

  @override
  Future getPromptsForValidation(String? token) async {
    return super.noSuchMethod(
      Invocation.method(#getPromptsForValidation, [token]),
    );
  }

  @override
  Future getAnswersForValidation(String? token) async {
    return super.noSuchMethod(
      Invocation.method(#getAnswersForValidation, [token]),
    );
  }

  @override
  Future<bool> submitPrompt(
      String? userId, String? token, String? content) async {
    return super.noSuchMethod(
      Invocation.method(#submitPrompt, [userId, token, content]),
      returnValue: Future.value(true), // Default value
    );
  }
}
