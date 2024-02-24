import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gptuner/environment_config.dart';
import 'package:gptuner/shared/utils/functions.dart';
import 'package:gptuner/theme/app_theme.dart';

class LeaderboardState with ChangeNotifier {
  String hostUrl = EnvConfig.instance.hostUrl;
  Map<String, int> topPromptSubmitters = {};
  Map<String, int> topAnswerSubmitters = {};
  Map<String, int> topValidators = {};
  bool tried = false;

  Future<void> getLeaderboard() async {
    if (tried) return;
    final response =
        await sendRequest("api/v1/users/getLeaderboard", hostUrl: hostUrl);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      for (var item in data['topPromptSubmitters']) {
        topPromptSubmitters[item['name']] = item['totalSubmissions'];
      }
      for (var item in data['topAnswerSubmitters']) {
        topAnswerSubmitters[item['name']] = item['totalSubmissions'];
      }
      for (var item in data['topValidators']) {
        topValidators[item['name']] = item['total'];
      }
      notifyListeners(); // Notify listeners to rebuild the widgets that depend on this data
    } else {
      showSnackbar("There has been a server error. Please try again later.",
          backgroundColor: AppTheme.getTheme().colorScheme.error);
    }
    tried = true;
  }
}
