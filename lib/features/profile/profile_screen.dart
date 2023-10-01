import 'package:flutter/material.dart';
import 'package:gptuner/providers/auth_state.dart';
import 'package:gptuner/shared/widgets/custom_loader.dart';
import 'package:gptuner/theme/app_theme.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
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
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 20.0, left: 32.0, right: 32.0),
                child: InkWell(
                  onTap: () async {
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
                        color: AppTheme.getTheme().backgroundColor),
                    child: Center(
                      child: Text(
                        "Update Profile",
                        style: AppTheme.getTheme().textTheme.headline4,
                      ),
                    ),
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
        Center(
            child:
                Visibility(visible: _isLoading, child: const CustomLoader())),
      ]),
    );
  }

  void _editProfile(BuildContext context, String title, String currentValue,
      Function(String) onUpdated) {
    TextEditingController controller =
        TextEditingController(text: currentValue);
    Platform.isAndroid
        ? showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Edit $title'),
                content: TextField(
                  controller: controller,
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
                      onUpdated(controller.text);
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
                    controller: controller,
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
                      onUpdated(controller.text);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
  }
}
