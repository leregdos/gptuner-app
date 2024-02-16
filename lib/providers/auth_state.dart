import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gptuner/environment_config.dart';
import 'package:gptuner/models/user.dart';
import 'package:gptuner/shared/utils/functions.dart';
import 'package:gptuner/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState with ChangeNotifier {
  String? _token;
  String? _opt;
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

    final response = await sendRequest("api/v1/users/getCurrentUser",
        headersAlt: {"Authorization": "Bearer $token"}, hostUrl: hostUrl);

    if (response.statusCode == 200) {
      _token = token;
      _expiryDate = expiryDate;
      if (jsonDecode(response.body)["user"] != null) {
        user = User.fromJson(jsonDecode(response.body)['user']);
      }
      return true;
    } else {
      showSnackbarOnServerExceptions(response.statusCode);
    }
    notifyListeners();
    return false;
  }

  Future<bool> signup(String? email, String? password, String? name,
      String? passwordConfirm) async {
    Map<String, String> body = {
      'email': email!,
      'password': password!,
      'name': name!,
      'passwordConfirm': passwordConfirm!
    };
    final response = await sendRequest("api/v1/users/signup",
        method: "POST", body: body, hostUrl: hostUrl);
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
      return true;
    } else {
      if (jsonDecode(response.body)["message"] != null) {
        String message = jsonDecode(response.body)["message"];
        if (message.substring(0, 6) == "E11000") {
          showSnackbar("Email already exists. Please try again.",
              backgroundColor: AppTheme.getTheme().colorScheme.error);
        } else {
          showSnackbar("There has been a server error. Please try again later.",
              backgroundColor: AppTheme.getTheme().colorScheme.error);
        }
      } else {
        showSnackbar("There has been a server error. Please try again later.",
            backgroundColor: AppTheme.getTheme().colorScheme.error);
      }
      return false;
    }
  }

  Future<void> login(String? email, String? password) async {
    Map<String, String> body = {
      'email': email!,
      'password': password!,
    };
    final response = await sendRequest("api/v1/users/login",
        method: "POST", body: body, hostUrl: hostUrl);
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
          backgroundColor: AppTheme.getTheme().colorScheme.error);
    } else {
      showSnackbar("There has been a server error. Please try again later.",
          backgroundColor: AppTheme.getTheme().colorScheme.error);
    }
  }

  Future<bool> requestOPT() async {
    Map<String, String> body = {
      'email': user!.email!,
    };
    final response = await sendRequest("api/v1/users/otpSend",
        method: "POST", body: body, hostUrl: hostUrl);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> validateOPT(String? inputOPT) async {
    Map<String, String> body = {
      'email': user!.email!,
      'otp': inputOPT!,
    };
    final response = await sendRequest("api/v1/users/otpVerify",
        method: "POST", body: body, hostUrl: hostUrl);
    if (response.statusCode == 200) {
      showSnackbar("Email verification successful.",
          backgroundColor: Colors.green);
      return true;
    } else if (response.statusCode == 400) {
      showSnackbar("The OPT is wrong or expired. Please try again.",
          backgroundColor: AppTheme.getTheme().colorScheme.error);
      return false;
    } else {
      showSnackbar("There has been a server error. Please try again.",
          backgroundColor: AppTheme.getTheme().colorScheme.error);
      return false;
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
    final response = await sendRequest("api/v1/users/updateMe",
        method: "PATCH",
        body: body,
        headersAlt: {"Authorization": "Bearer $_token"},
        hostUrl: hostUrl);
    if (response.statusCode == 200) {
      user!.email = email ?? user!.email;
      user!.name = name ?? user!.name;
      showSnackbar("Account updated successfully.",
          backgroundColor: Colors.green);
      notifyListeners();
    } else {
      showSnackbarOnServerExceptions(response.statusCode);
    }
  }

  Future<bool> updatePassword(
      String password, String newPassword, String newPasswordConfirm) async {
    Map<String, String> body = {
      "password": password,
      "newPassword": newPassword,
      "newPasswordConfirm": newPasswordConfirm
    };
    final response = await sendRequest("api/v1/users/updateMyPassword",
        method: "PATCH",
        body: body,
        headersAlt: {"Authorization": "Bearer $_token"},
        hostUrl: hostUrl);
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
            backgroundColor: AppTheme.getTheme().colorScheme.error);
        return false;
      }
    } else if (response.statusCode == 401) {
      showSnackbar("Incorrect Password. Please try again.",
          backgroundColor: AppTheme.getTheme().colorScheme.error);
      return false;
    } else {
      showSnackbar("There has been a server error. Please try again later.",
          backgroundColor: AppTheme.getTheme().colorScheme.error);
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
