import 'package:http/http.dart';
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
  bool get isAuthenticated {
    return super.noSuchMethod(
      Invocation.method(#tryAutoLogin, []),
      returnValue: true, // Default value
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

class MockHttpResponse extends Mock implements Response {}
