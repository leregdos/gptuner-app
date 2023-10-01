import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gptuner/theme/app_theme.dart';

class SubmitDemonstrationScreen extends StatefulWidget {
  const SubmitDemonstrationScreen({Key? key}) : super(key: key);
  @override
  _SubmitDemonstrationScreenState createState() =>
      _SubmitDemonstrationScreenState();
}

class _SubmitDemonstrationScreenState extends State<SubmitDemonstrationScreen> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  bool _isValid = false;
  List<String> messages = [];

  void _sendMessage() {
    String msg = _textController.text.trim();

    if (msg.isNotEmpty) {
      setState(() {
        messages.add(msg);
        _textController.clear();
      });
      _isValid = false;
      _listKey.currentState?.insertItem(messages.length,
          duration: const Duration(milliseconds: 500));
    }
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
                    _sendMessage();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getTheme().primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.getTheme().backgroundColor,
        title: Text(
          'Demonstration Submission',
          style: AppTheme.getTheme().textTheme.headline3,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: 1,
              itemBuilder: (context, index, animation) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 14, right: 14, top: 10, bottom: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.shade200,
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "Insert Prompt here",
                            style: AppTheme.getTheme().textTheme.bodyText1,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                if (index <= messages.length) {
                  return SizeTransition(
                    sizeFactor: animation,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 14, right: 14, bottom: 10),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppTheme.getTheme().backgroundColor,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              messages[index - 1],
                              style: AppTheme.getTheme().textTheme.bodyText1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return Container();
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
                      onChanged: (val) {
                        if (_textController.text.isEmpty) {
                          setState(() {
                            _isValid = false;
                          });
                        } else {
                          setState(() {
                            _isValid = true;
                          });
                        }
                      },
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
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        _alertDialog(
                            "Are you sure you want to skip this prompt?",
                            _sendMessage);
                      }
                    },
                    backgroundColor: _isValid
                        ? AppTheme.getTheme().backgroundColor
                        : AppTheme.getTheme().disabledColor,
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
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        _alertDialog(
                            "Are you sure you want to submit this demonstration?",
                            _sendMessage);
                      }
                    },
                    backgroundColor: _isValid
                        ? AppTheme.getTheme().backgroundColor
                        : AppTheme.getTheme().disabledColor,
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
}
