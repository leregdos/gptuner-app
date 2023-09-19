import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gptuner/providers/auth_state.dart';
import 'package:gptuner/shared/utils/functions.dart';
import 'package:gptuner/theme/app_theme.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _openSidebar(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AuthState>(context, listen: false);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: buildSidebar(state, context),
        backgroundColor: AppTheme.getTheme().backgroundColor,
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(FontAwesomeIcons.bars),
              onPressed: () => _openSidebar(context),
            ),
          ),
          elevation: 0.0, // This removes the shadow below the AppBar.
          backgroundColor:
              Colors.transparent, // Makes the AppBar background transparent.
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                "Welcome to GPTuner",
                style: AppTheme.getTheme().textTheme.headline6,
              ),
              const SizedBox(
                height: 50,
              ),
              Expanded(child: _buildRoundedCardButton("Submit Prompt", 0)),
              const SizedBox(height: 20), // For spacing
              Expanded(
                  child: _buildRoundedCardButton("Submit Demonstration", 1)),
              const SizedBox(height: 20), // For spacing
              Expanded(
                  child: _buildRoundedCardButton("Validate Submissions", 1)),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedCardButton(String title, int index) {
    return Card(
      color: AppTheme.getTheme().cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          // Placeholder function for your card button action
          print("$title pressed!");
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  title,
                  style: AppTheme.getTheme().textTheme.headline5,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              Icon(
                FontAwesomeIcons.paperPlane,
                color: AppTheme.getTheme().primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
