import 'package:flutter/material.dart';
import 'package:gptuner/environment_config.dart';

class AuthState with ChangeNotifier {
  String hostUrl = EnvConfig.instance.hostUrl;
  String? _token;
  DateTime? _expiryDate;

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  bool get isAuthenticated {
    return token != null;
  }

  Future<void> login(String email, String password) async {
    // Send a POST request to your API with email and password.
    // Upon success, store the JWT token and its expiry date.
    // For simplicity, I'll use pseudo-code below:
    // final response = await http.post(url, body: { email, password });
    // _token = response.data.token;
    // _expiryDate = response.data.expiryDate;
    notifyListeners();
  }

  Future<void> signup(
      String email, String password, String confirmPassword) async {
    // Send a POST request to your API with email and password.
    // Upon success, store the JWT token and its expiry date.
    // For simplicity, I'll use pseudo-code below:
    // final response = await http.post(url, body: { email, password });
    // _token = response.data.token;
    // _expiryDate = response.data.expiryDate;
    notifyListeners();
  }

  void logout() {
    _token = null;
    _expiryDate = null;
    notifyListeners();
  }
}
