import 'package:flutter/material.dart';
import 'package:gptuner/providers/leaderboard_state.dart';
import 'package:gptuner/shared/utils/functions.dart';
import 'package:provider/provider.dart';
import 'package:gptuner/theme/app_theme.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<LeaderboardState>(context, listen: false)
          .getLeaderboard();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildLeaderboardList(String category) {
    // Access the leaderboard data directly from the LeaderboardState
    final leaderboardState =
        Provider.of<LeaderboardState>(context, listen: true);
    Map<String, int> items = {};
    if (category == 'prompts') {
      items = leaderboardState.topPromptSubmitters;
    } else if (category == 'demonstrations') {
      items = leaderboardState.topAnswerSubmitters;
    } else if (category == 'validations') {
      items = leaderboardState.topValidators;
    }

    // Check if items map is not empty to display the data
    if (items.isNotEmpty) {
      return ListView(
        children: items.entries.map((entry) {
          return ListTile(
            title: Text(entry.key), // User's name
            trailing: Text(
              '${entry.value}',
              style: AppTheme.getTheme().textTheme.bodySmall,
            ), // Count
          );
        }).toList(),
      );
    } else {
      return buildNoAvailableDataMessage(
          "The leaderboard appears empty at the time. Please check back later.",
          context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getTheme().primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.getTheme().colorScheme.background,
        title: Text('Leaderboard',
            style: AppTheme.getTheme().textTheme.displaySmall),
        bottom: TabBar(
          onTap: (val) {
            setState(() {});
          },
          controller: _tabController,
          tabs: [
            Tab(
                child: Text(
              'Prompts',
              style: AppTheme.getTheme().textTheme.titleMedium,
            )),
            Tab(
                child: Text(
              'Answers',
              style: AppTheme.getTheme().textTheme.titleMedium,
            )),
            Tab(
                child: Text(
              'Validations',
              style: AppTheme.getTheme().textTheme.titleMedium,
            )),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaderboardList('prompts'),
          _buildLeaderboardList('demonstrations'),
          _buildLeaderboardList('validations'),
        ],
      ),
    );
  }
}
