import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gptuner/environment_config.dart';
// import 'package:gptuner/models/answer.dart';
import 'package:gptuner/models/prompt.dart';
import 'package:gptuner/shared/utils/functions.dart';
import 'package:gptuner/theme/app_theme.dart';

class DocumentState with ChangeNotifier {
  String hostUrl = EnvConfig.instance.hostUrl;
  List<Prompt> _promptList = [];
  bool _noAvailablePrompt = false;
  // final List<Answer> _answerList = [];

  List<Prompt> get promptList => _promptList;
  bool get noAvailablePrompt => _noAvailablePrompt;
  // List<Answer> get answerList => _answerList;

  Future<bool> submitPrompt(String userId, String token, String content) async {
    Map<String, String> body = {
      "content": content,
      "submittedUser": userId,
    };
    final response = await sendRequest("api/v1/prompts/",
        method: "POST",
        body: body,
        headersAlt: {"Authorization": "Bearer $token"},
        hostUrl: hostUrl);
    if (response.statusCode == 201) {
      showSnackbar("Prompt submitted successfully.",
          backgroundColor: Colors.green);
      notifyListeners();
      return true;
    } else if (response.statusCode == 401) {
      showSnackbar("Authentication error. Please log out and log in again.",
          backgroundColor: AppTheme.getTheme().errorColor);
      return false;
    } else {
      showSnackbar("There has been a server error. Please try again later.",
          backgroundColor: AppTheme.getTheme().errorColor);
      return false;
    }
  }

  Future getPromptsForAnswering(String token) async {
    final response = await sendRequest("api/v1/prompts/getPromptsForAnswering",
        headersAlt: {"Authorization": "Bearer $token"}, hostUrl: hostUrl);
    if (response.statusCode == 200) {
      _promptList = List<Prompt>.from(jsonDecode(response.body)["prompts"].map(
        (prompt) {
          return Prompt.fromJson(prompt);
        },
      ));
      notifyListeners();
    } else if (response.statusCode == 404) {
      _promptList = [];
      _noAvailablePrompt = true;
      notifyListeners();
    } else if (response.statusCode == 401) {
      showSnackbar("Authentication error. Please log out and log in again.",
          backgroundColor: AppTheme.getTheme().errorColor);
    } else {
      showSnackbar("There has been a server error. Please try again later.",
          backgroundColor: AppTheme.getTheme().errorColor);
    }
  }

  Future submitDemonstration(
      String token, String userId, String content) async {
    if (promptList.isNotEmpty) {
      Map<String, String> body = {
        "content": content,
        "submittedUser": userId,
        "associatedPrompt": promptList[0].uid!,
      };
      final response = await sendRequest("api/v1/answers/",
          headersAlt: {"Authorization": "Bearer $token"},
          hostUrl: hostUrl,
          method: 'POST',
          body: body);
      if (response.statusCode == 201) {
        showSnackbar("Demonstration submitted successfully.",
            backgroundColor: Colors.green);
      } else if (response.statusCode == 401) {
        showSnackbar("Authentication error. Please log out and log in again.",
            backgroundColor: AppTheme.getTheme().errorColor);
      } else {
        showSnackbar("There has been a server error. Please try again later.",
            backgroundColor: AppTheme.getTheme().errorColor);
      }
      removeReceivedPrompt();
    }
  }

  void removeReceivedPrompt() {
    _promptList.removeAt(0);
    notifyListeners();
  }
}
