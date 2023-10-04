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
    with SingleTickerProviderStateMixin {
  late TabController _controller;

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
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final documentState = Provider.of<DocumentState>(context, listen: true);
    final authState = Provider.of<AuthState>(context, listen: true);
    return Scaffold(
      backgroundColor: AppTheme.getTheme().primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.getTheme().backgroundColor,
        title: Text(
          'Validate Submissions',
          style: AppTheme.getTheme().textTheme.headline3,
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
              style: AppTheme.getTheme().textTheme.subtitle1,
            )),
            Tab(
                child: Text(
              'Demonstrations',
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
                documentState.noAvailablePromptForValidation
                    ? Center(
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
                                "There are no prompts to validate at this time. Please check back later.",
                                textAlign: TextAlign.center,
                                style: AppTheme.getTheme().textTheme.subtitle1,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: documentState.promptListForValidation.isEmpty
                            ? Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                        color: Colors.grey.withOpacity(0.7)),
                                  ),
                                  const Center(child: CustomLoader()),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 60),
                                  Card(
                                    color: Colors.grey[200],
                                    elevation: 10.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Padding(
                                        padding: const EdgeInsets.all(32.0),
                                        child: Text(
                                          documentState.promptListForValidation
                                              .elementAt(0)
                                              .content!,
                                          style: AppTheme.getTheme()
                                              .textTheme
                                              .bodyText1,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                documentState.noAvailableAnswerForValidation
                    ? Center(
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
                                "There are no demonstrations to validate at this time. Please check back later.",
                                textAlign: TextAlign.center,
                                style: AppTheme.getTheme().textTheme.subtitle1,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: documentState.answerPromptForValidation.isEmpty
                            ? Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                        color: Colors.grey.withOpacity(0.7)),
                                  ),
                                  const Center(child: CustomLoader()),
                                ],
                              )
                            : Column(
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
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                          documentState
                                              .answerPromptForValidation.values
                                              .elementAt(0)
                                              .content!,
                                          style: AppTheme.getTheme()
                                              .textTheme
                                              .bodyText1,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          documentState
                                              .answerPromptForValidation.keys
                                              .elementAt(0)
                                              .content!,
                                          style: AppTheme.getTheme()
                                              .textTheme
                                              .bodyText1,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
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
                      InkWell(
                        onTap: () async {
                          await documentState.validateSubmission(
                              authState.token!, 0, _controller.index);
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
                            style: AppTheme.getTheme().textTheme.labelLarge,
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          await documentState.validateSubmission(
                              authState.token!, 1, _controller.index);
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
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
