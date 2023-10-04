import 'package:flutter/material.dart';
import 'package:gptuner/theme/app_theme.dart';

class ValidateSubmissionsScreen extends StatefulWidget {
  const ValidateSubmissionsScreen({super.key});

  @override
  _ValidateSubmissionsScreenState createState() =>
      _ValidateSubmissionsScreenState();
}

class _ValidateSubmissionsScreenState extends State<ValidateSubmissionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getTheme().primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.getTheme().backgroundColor,
        title: Text(
          'Validate Submissions',
          style: AppTheme.getTheme().textTheme.headline3,
        ),
        bottom: TabBar(
          controller: _controller,
          tabs: [
            Tab(
                child: Text(
              'Prompts',
              style: AppTheme.getTheme().textTheme.subtitle1,
            )),
            Tab(
                child: Text(
              'Answers',
              style: AppTheme.getTheme().textTheme.subtitle1,
            )),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                Center(
                    child: Card(
                        child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Prompt Content')))),
                Center(
                    child: Card(
                        child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Answer Content')))),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () async {
                    print("invalid");
                  },
                  child: Container(
                    constraints: const BoxConstraints(
                        minWidth: 150, maxWidth: double.infinity),
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(17.0),
                        color: AppTheme.getTheme().errorColor),
                    child: Text(
                      "Invalid",
                      textAlign: TextAlign.center,
                      style: AppTheme.getTheme().textTheme.bodyText1,
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () async {
                    print("valid");
                  },
                  child: Container(
                    constraints: const BoxConstraints(
                        minWidth: 150, maxWidth: double.infinity),
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(17.0),
                        color: Colors.green),
                    child: Text(
                      "Valid",
                      textAlign: TextAlign.center,
                      style: AppTheme.getTheme().textTheme.bodyText1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
