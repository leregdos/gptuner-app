import 'package:flutter/material.dart';
import 'package:gptuner/providers/auth_state.dart';
import 'package:gptuner/providers/document_state.dart';
import 'package:gptuner/shared/widgets/custom_loader.dart';
import 'package:gptuner/theme/app_theme.dart';
import 'package:provider/provider.dart';

class SubmitPromptScreen extends StatefulWidget {
  const SubmitPromptScreen({super.key});
  @override
  _SubmitPromptScreenState createState() => _SubmitPromptScreenState();
}

class _SubmitPromptScreenState extends State<SubmitPromptScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isValid = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AuthState>(context, listen: false);
    final documentState = Provider.of<DocumentState>(context, listen: false);
    return Scaffold(
      backgroundColor: AppTheme.getTheme().primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.getTheme().backgroundColor,
        title: Text(
          'Prompt Submission',
          style: AppTheme.getTheme().textTheme.headline3,
        ),
      ),
      body: Stack(children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
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
                    maxLines: 10,
                    cursorColor: Colors.black,
                    cursorWidth: 2.0,
                    style: AppTheme.getTheme().textTheme.bodyText1,
                    decoration: InputDecoration(
                      hintStyle: AppTheme.getTheme().textTheme.bodyText1,
                      hintText: 'Enter your prompt here...',
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 20.0, left: 16.0, right: 16.0),
                child: InkWell(
                  onTap: () async {
                    if (_isValid) {
                      setState(() {
                        _isLoading = true;
                      });
                      bool success = await documentState.submitPrompt(
                        state.user!.uid!,
                        state.token!,
                        _textController.text,
                      );
                      setState(() {
                        _isLoading = false;
                      });
                      if (success) {
                        _textController.clear();
                      }
                    }
                  },
                  child: Container(
                    constraints: const BoxConstraints(
                        minWidth: 200, maxWidth: double.infinity),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 1.0, vertical: 18.0),
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
                        color: _isValid
                            ? AppTheme.getTheme().backgroundColor
                            : AppTheme.getTheme().disabledColor),
                    child: Text(
                      "Submit",
                      textAlign: TextAlign.center,
                      style: AppTheme.getTheme().textTheme.headline4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _isLoading,
          child: Positioned.fill(
            child: Container(color: Colors.grey.withOpacity(0.7)),
          ),
        ),
        Center(child: Visibility(visible: _isLoading, child: CustomLoader())),
      ]),
    );
  }
}
