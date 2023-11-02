import 'package:flutter/material.dart';
import 'package:gptuner/providers/auth_state.dart';
import 'package:gptuner/providers/document_state.dart';
import 'package:gptuner/shared/widgets/custom_loader.dart';
import 'package:gptuner/theme/app_theme.dart';
import 'package:provider/provider.dart';

class ValidateSubmissionsScreen extends StatefulWidget {
  const ValidateSubmissionsScreen({super.key});

  @override
  _ValidateSubmissionsScreenState createState() =>
      _ValidateSubmissionsScreenState();
}

class _ValidateSubmissionsScreenState extends State<ValidateSubmissionsScreen>
    with TickerProviderStateMixin {
  late TabController _controller;
  late Animation<double> _invalidButtonAnimation;
  late Animation<double> _validButtonAnimation;
  late AnimationController _invalidButtonController;
  late AnimationController _validButtonController;

  Future _handleValidation(int validated, BuildContext context) async {
    AnimationController buttonController =
        validated == 0 ? _invalidButtonController : _validButtonController;

    buttonController.forward().then((_) async {
      await Future.delayed(const Duration(milliseconds: 200)); // Small delay
      buttonController.reverse();
      if (!mounted) return;
      String? token = Provider.of<AuthState>(context, listen: false).token;
      if (token != null) {
        await Provider.of<DocumentState>(context, listen: false)
            .validateSubmission(token, validated, _controller.index);
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? token = Provider.of<AuthState>(context, listen: false).token;
      if (token != null) {
        await Provider.of<DocumentState>(context, listen: false)
            .getPromptsForValidation(token);
        if (!mounted) return;
        await Provider.of<DocumentState>(context, listen: false)
            .getAnswersForValidation(token);
      }
    });
    _controller = TabController(length: 2, vsync: this);
    _invalidButtonController = AnimationController(
      duration: const Duration(milliseconds: 60),
      vsync: this,
    );

    _validButtonController = AnimationController(
      duration: const Duration(milliseconds: 60),
      vsync: this,
    );

    _invalidButtonAnimation =
        Tween<double>(begin: 1, end: 1.15).animate(_invalidButtonController);
    _validButtonAnimation =
        Tween<double>(begin: 1, end: 1.15).animate(_validButtonController);
    super.initState();
  }

  @override
  void dispose() {
    _invalidButtonController.dispose();
    _validButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final documentState = Provider.of<DocumentState>(context, listen: true);
    Widget buildLoader() {
      return Center(
        child: Container(
          color: Colors.grey.withOpacity(0.7),
          child: const CustomLoader(),
        ),
      );
    }

    Widget buildNoAvailableDataMessage(String message) {
      return Center(
        child: Card(
          color: Colors.grey.shade400,
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: AppTheme.getTheme().textTheme.titleMedium,
              ),
            ),
          ),
        ),
      );
    }

    Widget buildPromptsTab() {
      if (documentState.noAvailablePromptForValidation) {
        return buildNoAvailableDataMessage(
            "There are no prompts to validate at this time. Please check back later.");
      }

      if (documentState.promptListForValidation.isEmpty) {
        return buildLoader();
      }
      return SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(height: 60),
          Card(
            color: Colors.grey[200],
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  documentState.promptListForValidation.elementAt(0).content!,
                  style: AppTheme.getTheme().textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ));
    }

    Widget buildDemonstrationsTab() {
      if (documentState.noAvailableAnswerForValidation) {
        return buildNoAvailableDataMessage(
            "There are no demonstrations to validate at this time. Please check back later.");
      }

      if (documentState.answerPromptForValidation.isEmpty) {
        return buildLoader();
      }
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Card(
              color: Colors.grey[200],
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    documentState.answerPromptForValidation.values
                        .elementAt(0)
                        .content!,
                    style: AppTheme.getTheme().textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Card(
              color: Colors.grey[200],
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    documentState.answerPromptForValidation.keys
                        .elementAt(0)
                        .content!,
                    style: AppTheme.getTheme().textTheme.bodyLarge,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.getTheme().primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.getTheme().colorScheme.background,
        title: Text(
          'Validate Submissions',
          style: AppTheme.getTheme().textTheme.displaySmall,
        ),
        bottom: TabBar(
          onTap: (val) {
            setState(() {});
          },
          controller: _controller,
          tabs: [
            Tab(
                child: Text(
              'Prompts',
              style: AppTheme.getTheme().textTheme.titleMedium,
            )),
            Tab(
                child: Text(
              'Demonstrations',
              style: AppTheme.getTheme().textTheme.titleMedium,
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
                buildPromptsTab(),
                buildDemonstrationsTab(),
              ],
            ),
          ),
          ((documentState.answerPromptForValidation.isEmpty &&
                      _controller.index == 1) ||
                  (documentState.promptListForValidation.isEmpty &&
                      _controller.index == 0))
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20.0, left: 16.0, right: 16.0, top: 10.0),
                  child: Row(
                    children: [
                      ScaleTransition(
                        scale: _invalidButtonAnimation,
                        child: InkWell(
                          onTap: () async {
                            await _handleValidation(0, context);
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
                                color: AppTheme.getTheme().colorScheme.error),
                            child: Text(
                              "Invalid",
                              textAlign: TextAlign.center,
                              style: AppTheme.getTheme().textTheme.labelLarge,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      ScaleTransition(
                        scale: _validButtonAnimation,
                        child: InkWell(
                          onTap: () async {
                            await _handleValidation(1, context);
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
                              style: AppTheme.getTheme().textTheme.labelLarge,
                            ),
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
