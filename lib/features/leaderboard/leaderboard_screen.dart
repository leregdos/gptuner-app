import 'package:flutter/material.dart';
import 'package:gptuner/providers/leaderboard_state.dart';
import 'package:gptuner/shared/utils/functions.dart';
import 'package:gptuner/shared/widgets/custom_loader.dart';
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
      return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: ListView.separated(
                shrinkWrap:
                    true, // Important to prevent ListView from expanding infinitely
                physics:
                    NeverScrollableScrollPhysics(), // Disable scrolling in the ListView
                itemCount: items.length,
                separatorBuilder: (context, index) =>
                    Divider(color: AppTheme.getTheme().dividerColor),
                itemBuilder: (context, index) {
                  String key = items.keys.elementAt(index);
                  int value = items[key]!;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.getTheme().colorScheme.surface,
                      child: Text('${index + 1}',
                          style: TextStyle(
                              color:
                                  AppTheme.getTheme().colorScheme.onSurface)),
                    ),
                    title: Text(key,
                        style: AppTheme.getTheme()
                            .textTheme
                            .titleMedium), // User's name
                    trailing: Text('$value',
                        style:
                            AppTheme.getTheme().textTheme.bodySmall), // Count
                  );
                },
              ),
            ),
            if (category == 'prompts' || category == 'demonstrations')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Only submissions with at least 2 validations are considered.',
                  style: AppTheme.getTheme().textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      );
    } else {
      if (leaderboardState.tried) {
        return buildNoAvailableDataMessage(
            "The leaderboard appears empty at the time. Please check back later.",
            context);
      } else {
        return Center(
          child: Container(
            color: Colors.grey.withOpacity(0.7),
            child: const CustomLoader(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getTheme().primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.getTheme().colorScheme.background,
        title: Text('Top 10 Users',
            style: AppTheme.getTheme().textTheme.displaySmall),
        bottom: TabBar(
          onTap: (val) {
            setState(() {});
          },
          controller: _tabController,
          tabs: [
            Tab(
                child: Text(
              'Prompts\nSubmitted',
              textAlign: TextAlign.center,
              style: AppTheme.getTheme().textTheme.titleMedium,
            )),
            Tab(
                child: Text(
              'Answers\nSubmitted',
              textAlign: TextAlign.center,
              style: AppTheme.getTheme().textTheme.titleMedium,
            )),
            Tab(
                child: Text(
              'Validations\nMade',
              textAlign: TextAlign.center,
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
