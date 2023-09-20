import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gptuner/environment_config.dart';
import 'package:gptuner/models/user.dart';
import 'package:gptuner/shared/utils/functions.dart';
import 'package:gptuner/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthState with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  User? user;
  String hostUrl = EnvConfig.instance.hostUrl;

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

  Future<void> _storeTokenAndExpiryDate(
      String token, DateTime expiryDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', token);
    await prefs.setString('expiryDate', expiryDate.toIso8601String());
  }

  Future<void> _removeTokenAndExpiryDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
    await prefs.remove('expiryDate');
  }

  static const Map<String, String> _headers = {
    "Content-Type": "application/json",
    "Accept-Encoding": "gzip,deflate,br",
  };

  Future<http.Response> _sendRequest(String endpoint,
      {String method = 'GET',
      Map<String, String>? headers,
      dynamic body}) async {
    final uri = Uri.parse('$hostUrl$endpoint');
    headers = {..._headers, ...?headers};

    if (method == 'POST') {
      return await http.post(uri, headers: headers, body: jsonEncode(body));
    } else if (method == 'PATCH') {
      return await http.patch(uri, headers: headers, body: jsonEncode(body));
    } else {
      return await http.get(uri, headers: headers);
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('jwtToken') || !prefs.containsKey('expiryDate')) {
      return false;
    }

    final token = prefs.getString('jwtToken')!;
    final expiryDate = DateTime.parse(prefs.getString('expiryDate')!);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    final response = await _sendRequest("api/v1/users/getCurrentUser",
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      _token = token;
      _expiryDate = expiryDate;
      if (jsonDecode(response.body)["user"] != null) {
        user = User.fromJson(jsonDecode(response.body)['user']);
      }
      return true;
    } else if (response.statusCode == 401) {
      showSnackbar(
          "There has been an authorization error. Please log in again.",
          backgroundColor: AppTheme.getTheme().errorColor);
    } else {
      showSnackbar("There has been a server error. Please try again later.",
          backgroundColor: AppTheme.getTheme().errorColor);
    }
    notifyListeners();
    return false;
  }

  Future<void> signup(String email, String password, String name,
      String passwordConfirm) async {
    Map<String, String> body = {
      'email': email,
      'password': password,
      'name': name,
      'passwordConfirm': passwordConfirm
    };
    final response =
        await _sendRequest("api/v1/users/signup", method: "POST", body: body);
    if (response.statusCode == 201) {
      if (response.headers.containsKey('set-cookie')) {
        _token = response.headers['set-cookie']!.split(';')[0].substring(4);
        _expiryDate = parseJWTExpiry(
            response.headers['set-cookie']!.split(';')[2].substring(9));
        await _storeTokenAndExpiryDate(_token!, _expiryDate!);
      }
      if (jsonDecode(response.body)["user"] != null) {
        user = User.fromJson(jsonDecode(response.body)['user']);
      }
      showSnackbar("Account creation successful.",
          backgroundColor: Colors.green);
      notifyListeners();
    } else {
      if (jsonDecode(response.body)["message"] != null) {
        String message = jsonDecode(response.body)["message"];
        if (message.substring(0, 6) == "E11000") {
          showSnackbar("Email already exists. Please try again.",
              backgroundColor: AppTheme.getTheme().errorColor);
        } else {
          showSnackbar("There has been a server error. Please try again later.",
              backgroundColor: AppTheme.getTheme().errorColor);
        }
      } else {
        showSnackbar("There has been a server error. Please try again later.",
            backgroundColor: AppTheme.getTheme().errorColor);
      }
    }
  }

  Future<void> login(String email, String password) async {
    Map<String, String> body = {
      'email': email,
      'password': password,
    };
    final response =
        await _sendRequest("api/v1/users/login", method: "POST", body: body);
    if (response.statusCode == 200) {
      if (response.headers.containsKey('set-cookie')) {
        _token = response.headers['set-cookie']!.split(';')[0].substring(4);
        _expiryDate = parseJWTExpiry(
            response.headers['set-cookie']!.split(';')[2].substring(9));
        await _storeTokenAndExpiryDate(_token!, _expiryDate!);
      }
      if (jsonDecode(response.body)["user"] != null) {
        user = User.fromJson(jsonDecode(response.body)['user']);
      }
      notifyListeners();
    } else if (response.statusCode == 401) {
      showSnackbar("Incorrect email or password.",
          backgroundColor: AppTheme.getTheme().errorColor);
    } else {
      showSnackbar("There has been a server error. Please try again later.",
          backgroundColor: AppTheme.getTheme().errorColor);
    }
  }

  Future<void> updateUser(String? email, String? name) async {
    Map<String, String> body = {};
    if (email != null) {
      body['email'] = email;
    }
    if (name != null) {
      body['name'] = name;
      user!.name = name;
    }
    final response = await _sendRequest("api/v1/users/updateMe",
        method: "PATCH",
        body: body,
        headers: {"Authorization": "Bearer $_token"});
    if (response.statusCode == 200) {
      user!.email = email ?? user!.email;
      user!.name = name ?? user!.name;
      showSnackbar("Account updated successfully.",
          backgroundColor: Colors.green);
      notifyListeners();
    } else if (response.statusCode == 401) {
      showSnackbar("Authentication error. Please log out and log in again.",
          backgroundColor: AppTheme.getTheme().errorColor);
    } else {
      showSnackbar("There has been a server error. Please try again later.",
          backgroundColor: AppTheme.getTheme().errorColor);
    }
  }

  Future<bool> updatePassword(
      String password, String newPassword, String newPasswordConfirm) async {
    Map<String, String> body = {
      "password": password,
      "newPassword": newPassword,
      "newPasswordConfirm": newPasswordConfirm
    };
    final response = await _sendRequest("api/v1/users/updateMyPassword",
        method: "PATCH",
        body: body,
        headers: {"Authorization": "Bearer $_token"});
    if (response.statusCode == 200) {
      if (response.headers.containsKey('set-cookie')) {
        _token = response.headers['set-cookie']!.split(';')[0].substring(4);
        _expiryDate = parseJWTExpiry(
            response.headers['set-cookie']!.split(';')[2].substring(9));
        await _storeTokenAndExpiryDate(_token!, _expiryDate!);
        showSnackbar("Password updated successfully.",
            backgroundColor: Colors.green);
        notifyListeners();
        return true;
      } else {
        showSnackbar("There has been a server error. Please try again later.",
            backgroundColor: AppTheme.getTheme().errorColor);
        return false;
      }
    } else if (response.statusCode == 401) {
      showSnackbar("Incorrect Password. Please try again.",
          backgroundColor: AppTheme.getTheme().errorColor);
      return false;
    } else {
      showSnackbar("There has been a server error. Please try again later.",
          backgroundColor: AppTheme.getTheme().errorColor);
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    await _removeTokenAndExpiryDate();
    notifyListeners();
  }
}
