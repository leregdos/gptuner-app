import 'package:flutter/material.dart';
import 'package:gptuner/providers/auth_state.dart';
import 'package:gptuner/shared/widgets/custom_loader.dart';
import 'package:gptuner/theme/app_theme.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _name;
  late String _email;
  bool _isLoading = false;
  @override
  void initState() {
    final state = Provider.of<AuthState>(context, listen: false);
    _name = state.user!.name!;
    _email = state.user!.email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AuthState>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFF8AA1A9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8AA1A9),
        title: Text(
          'Profile',
          style: AppTheme.getTheme().textTheme.headline1,
        ),
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: Text(
                        'Name',
                        style: AppTheme.getTheme().textTheme.button,
                      ),
                      subtitle: Text(
                        _name,
                        style: AppTheme.getTheme().textTheme.button,
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _editProfile(context, 'Name', _name, (updatedValue) {
                            setState(() {
                              _name = updatedValue;
                            });
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Email',
                        style: AppTheme.getTheme().textTheme.button,
                      ),
                      subtitle: Text(
                        _email,
                        style: AppTheme.getTheme().textTheme.button,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          _editProfile(context, 'Email', _email,
                              (updatedValue) {
                            setState(() {
                              _email = updatedValue;
                            });
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AppTheme.getTheme().backgroundColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                onPressed: () async {
                  if (_name != state.user!.name ||
                      _email != state.user!.email) {
                    setState(() {
                      _isLoading = true;
                    });
                    await state.updateUser(_email, _name);
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Save Changes',
                    style: AppTheme.getTheme().textTheme.headline4,
                  ),
                ),
              )
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

  void _editProfile(BuildContext context, String title, String currentValue,
      Function(String) onUpdated) {
    TextEditingController _controller =
        TextEditingController(text: currentValue);
    Platform.isAndroid
        ? showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Edit $title'),
                content: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: title,
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Update'),
                    onPressed: () {
                      onUpdated(_controller.text);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          )
        : showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('Edit $title'),
                content: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CupertinoTextField(
                    controller: _controller,
                    placeholder: title,
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text('Update'),
                    onPressed: () {
                      onUpdated(_controller.text);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
  }
}
