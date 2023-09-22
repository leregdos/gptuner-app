import 'package:flutter/material.dart';

class SubmitPromptScreen extends StatefulWidget {
  const SubmitPromptScreen({super.key});
  @override
  _SubmitPromptScreenState createState() => _SubmitPromptScreenState();
}

class _SubmitPromptScreenState extends State<SubmitPromptScreen> {
  TextEditingController _textController = TextEditingController();

  void _handleSubmit() {
    // Logic for when the submit button is pressed.
    print("Submitted: ${_textController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prompt Submission"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _textController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Enter your prompt here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _handleSubmit,
                      child: Text("Submit"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
