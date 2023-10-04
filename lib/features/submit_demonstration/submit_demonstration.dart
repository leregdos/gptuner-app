import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gptuner/providers/auth_state.dart';
import 'package:gptuner/providers/document_state.dart';
import 'package:gptuner/shared/widgets/custom_loader.dart';
import 'package:gptuner/theme/app_theme.dart';
import 'package:provider/provider.dart';

class SubmitDemonstrationScreen extends StatefulWidget {
  const SubmitDemonstrationScreen({Key? key}) : super(key: key);
  @override
  _SubmitDemonstrationScreenState createState() =>
      _SubmitDemonstrationScreenState();
}

class _SubmitDemonstrationScreenState extends State<SubmitDemonstrationScreen> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<String> messages = [];
  void _sendMessage(BuildContext context) async {
    final documentState = Provider.of<DocumentState>(context, listen: false);
    final authState = Provider.of<AuthState>(context, listen: false);

    String msg = _textController.text.trim();

    if (msg.isNotEmpty) {
      setState(() {
        messages.add(msg);
      });
      _listKey.currentState?.insertItem(messages.length - 1,
          duration: const Duration(milliseconds: 500));
      messages.clear();
      _textController.clear();
      await documentState.submitAnswer(
          authState.token!, authState.user!.uid!, msg);
    }
  }

  void _skipPrompt(BuildContext context) {
    final documentState = Provider.of<DocumentState>(context, listen: false);
    messages.clear();
    _textController.clear();
    documentState.removeReceivedPrompt();
  }

  void _alertDialog(String title, Function callback) {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title,
                textAlign: TextAlign.center,
                style: AppTheme.getTheme().textTheme.headline3),
            actions: [
              TextButton(
                child:
                    Text('No', style: AppTheme.getTheme().textTheme.bodyText2),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child:
                    Text('Yes', style: AppTheme.getTheme().textTheme.bodyText2),
                onPressed: () {
                  callback();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(title,
                  textAlign: TextAlign.center,
                  style: AppTheme.getTheme().textTheme.headline3),
              actions: [
                CupertinoDialogAction(
                  child: Text('No',
                      style: AppTheme.getTheme().textTheme.bodyText2),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text('Yes',
                      style: AppTheme.getTheme().textTheme.bodyText2),
                  onPressed: () {
                    callback(context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  Widget buildMainContent() {
    if (messages.isEmpty) {
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
                "There are no prompts to answer at this time. Please check back later.",
                textAlign: TextAlign.center,
                style: AppTheme.getTheme().textTheme.subtitle1,
              ),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: messages.length,
              itemBuilder: (context, index, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 14, right: 14, bottom: 10),
                      child: Align(
                        alignment: (index.isEven)
                            ? Alignment.topLeft
                            : Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (index.isEven)
                                ? Colors.grey.shade200
                                : AppTheme.getTheme().backgroundColor,
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            messages[index],
                            style: AppTheme.getTheme().textTheme.bodyText1,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 20.0, left: 16.0, right: 16.0, top: 10),
            child: Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                          hintText: "Demonstrate an answer...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    heroTag: "skip",
                    onPressed: () {
                      _alertDialog("Are you sure you want to skip this prompt?",
                          _skipPrompt);
                    },
                    backgroundColor: AppTheme.getTheme().backgroundColor,
                    elevation: 0,
                    child: const Icon(
                      FontAwesomeIcons.forwardStep,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  FloatingActionButton(
                    heroTag: "submit",
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        _alertDialog(
                            "Are you sure you want to submit this demonstration?",
                            _sendMessage);
                      }
                    },
                    backgroundColor: AppTheme.getTheme().backgroundColor,
                    elevation: 0,
                    child: const Icon(
                      FontAwesomeIcons.paperPlane,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AuthState>(context, listen: false);
    final documentState = Provider.of<DocumentState>(context, listen: true);
    return Scaffold(
      backgroundColor: AppTheme.getTheme().primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.getTheme().backgroundColor,
        title: Text(
          'Demonstration Submission',
          style: AppTheme.getTheme().textTheme.headline3,
        ),
      ),
      body: FutureBuilder(
        future: documentState.promptListForAnswering.isEmpty
            ? documentState.getPromptsForAnswering(state.token!)
            : Future.value(null),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !documentState.noAvailablePromptForAnswering) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Container(color: Colors.grey.withOpacity(0.7)),
                ),
                const Center(child: CustomLoader()),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'There has been an error, please try again.',
                style: AppTheme.getTheme().textTheme.subtitle1,
              ),
            );
          } else {
            if (documentState.promptListForAnswering.isNotEmpty &&
                messages.isEmpty) {
              messages.add(documentState.promptListForAnswering.first.content!);
            }
            return buildMainContent();
          }
        },
      ),
    );
  }
}
