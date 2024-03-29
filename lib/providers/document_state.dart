import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gptuner/environment_config.dart';
import 'package:gptuner/models/answer.dart';
import 'package:gptuner/models/prompt.dart';
import 'package:gptuner/shared/utils/functions.dart';
import 'package:gptuner/theme/app_theme.dart';

class DocumentState with ChangeNotifier {
  String hostUrl = EnvConfig.instance.hostUrl;
  bool _noAvailablePromptForAnswering = false;
  bool _noAvailablePromptForValidation = false;
  bool _noAvailableAnswerForValidation = false;
  List<Prompt> _promptListForAnswering = [];
  Map<Answer, Prompt> _answerPromptForValidation = {};
  List<Prompt> _promptListForValidation = [];

  List<Prompt> get promptListForAnswering => _promptListForAnswering;
  Map<Answer, Prompt> get answerPromptForValidation =>
      _answerPromptForValidation;
  List<Prompt> get promptListForValidation => _promptListForValidation;
  bool get noAvailablePromptForAnswering => _noAvailablePromptForAnswering;
  bool get noAvailablePromptForValidation => _noAvailablePromptForValidation;
  bool get noAvailableAnswerForValidation => _noAvailableAnswerForValidation;

  Future<bool> submitPrompt(
      String? userId, String? token, String? content) async {
    Map<String, String> body = {};
    if (userId != null && content != null) {
      body = {
        "content": content,
        "submittedUser": userId,
      };
    }
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
          backgroundColor: AppTheme.getTheme().colorScheme.error);
      return false;
    } else {
      showSnackbar("There has been a server error. Please try again later.",
          backgroundColor: AppTheme.getTheme().colorScheme.error);
      return false;
    }
  }

  Future getPromptsForAnswering(String token) async {
    if (!_noAvailablePromptForAnswering) {
      final response = await sendRequest(
          "api/v1/prompts/getPromptsForAnswering",
          headersAlt: {"Authorization": "Bearer $token"},
          hostUrl: hostUrl);
      if (response.statusCode == 200) {
        _promptListForAnswering =
            List<Prompt>.from(jsonDecode(response.body)["prompts"].map(
          (prompt) {
            return Prompt.fromJson(prompt);
          },
        ));
        notifyListeners();
      } else if (response.statusCode == 404) {
        _promptListForAnswering = [];
        _noAvailablePromptForAnswering = true;
        notifyListeners();
      } else {
        showSnackbarOnServerExceptions(response.statusCode);
      }
    }
  }

  Future<bool> submitAnswer(String token, String userId, String content) async {
    if (promptListForAnswering.isNotEmpty) {
      Map<String, String> body = {
        "content": content,
        "submittedUser": userId,
        "associatedPrompt": promptListForAnswering[0].uid!,
      };
      removeReceivedPrompt();
      final response = await sendRequest("api/v1/answers/",
          headersAlt: {"Authorization": "Bearer $token"},
          hostUrl: hostUrl,
          method: 'POST',
          body: body);
      if (response.statusCode == 201) {
        showSnackbar("Demonstration submitted successfully.",
            backgroundColor: Colors.green);
        return true;
      } else {
        showSnackbarOnServerExceptions(response.statusCode);
        return false;
      }
    }
    return false;
  }

  Future getPromptsForValidation(String? token) async {
    if (!_noAvailablePromptForValidation && _promptListForAnswering.isEmpty) {
      final response = await sendRequest(
          "api/v1/prompts/getPromptsForValidation",
          headersAlt: {"Authorization": "Bearer $token"},
          hostUrl: hostUrl);
      if (response.statusCode == 200) {
        _promptListForValidation =
            List<Prompt>.from(jsonDecode(response.body)["prompts"].map(
          (prompt) {
            return Prompt.fromJson(prompt);
          },
        ));
        notifyListeners();
      } else if (response.statusCode == 404) {
        _promptListForValidation = [];
        _noAvailablePromptForValidation = true;
        notifyListeners();
      } else {
        showSnackbarOnServerExceptions(response.statusCode);
      }
    }
  }

  Future getAnswersForValidation(String? token) async {
    if (!_noAvailableAnswerForValidation &&
        _answerPromptForValidation.isEmpty) {
      final response = await sendRequest(
          "api/v1/answers/getAnswersForValidation",
          headersAlt: {"Authorization": "Bearer $token"},
          hostUrl: hostUrl);
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body)["answers"];
        for (int i = 0; i < res.length; i++) {
          var answer = res[i];
          _answerPromptForValidation[Answer.fromJson(answer)] =
              Prompt.fromJson(answer["associatedPrompt"]);
        }
        notifyListeners();
      } else if (response.statusCode == 404) {
        _answerPromptForValidation = {};
        _noAvailableAnswerForValidation = true;
        notifyListeners();
      } else {
        showSnackbarOnServerExceptions(response.statusCode);
      }
    }
  }

  Future<bool> validateSubmission(
      String token, int validated, int index) async {
    String id = index == 0
        ? promptListForValidation[0].uid!
        : answerPromptForValidation.keys.first.uid!;
    dynamic response;
    Map<String, bool> body = {"validated": validated == 1};
    if (index == 0) {
      response = await sendRequest("api/v1/prompts/validate/$id",
          headersAlt: {"Authorization": "Bearer $token"},
          hostUrl: hostUrl,
          method: 'POST',
          body: body);
    } else {
      response = await sendRequest("api/v1/answers/validate/$id",
          headersAlt: {"Authorization": "Bearer $token"},
          hostUrl: hostUrl,
          method: 'POST',
          body: body);
    }
    if (response.statusCode == 200) {
      if (index == 0) {
        _promptListForValidation.removeAt(0);
        if (_promptListForAnswering.isEmpty) {
          await getPromptsForValidation(token);
        }
      } else {
        _answerPromptForValidation
            .remove(_answerPromptForValidation.keys.first);
        if (_answerPromptForValidation.isEmpty) {
          await getAnswersForValidation(token);
        }
      }
      notifyListeners();
      return true;
    } else {
      showSnackbarOnServerExceptions(response.statusCode);
      return false;
    }
  }

  void removeReceivedPrompt() {
    _promptListForAnswering.removeAt(0);
    notifyListeners();
  }

  void reset() {
    _promptListForAnswering.clear();
    _answerPromptForValidation.clear();
    _promptListForValidation.clear();
    _noAvailableAnswerForValidation = false;
    _noAvailablePromptForValidation = false;
    _noAvailablePromptForAnswering = false;
  }
}
