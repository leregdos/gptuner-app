import 'package:flutter/material.dart';
import 'package:gptuner/providers/auth_state.dart';
import 'package:gptuner/shared/utils/badge_display.dart';
import 'package:gptuner/shared/utils/functions.dart';
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
  late int? _submittedPrompts;
  late int? _submittedAnswers;
  late int? _validationsMade;
  bool _isLoading = false;
  bool _validEmail = true;
  bool _validName = true;
  @override
  void initState() {
    final state = Provider.of<AuthState>(context, listen: false);
    _name = state.user!.name!;
    _email = state.user!.email!;
    _submittedPrompts = state.user!.promptSubmitted;
    _submittedAnswers = state.user!.answerSubmitted;
    _validationsMade = state.user!.validations;
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
          style: AppTheme.getTheme().textTheme.displayLarge,
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
                        style: AppTheme.getTheme().textTheme.labelLarge,
                      ),
                      subtitle: Text(
                        _name,
                        style: AppTheme.getTheme().textTheme.labelLarge,
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
                              _validName = _name.isNotEmpty;
                            });
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Email',
                        style: AppTheme.getTheme().textTheme.labelLarge,
                      ),
                      subtitle: Text(
                        _email,
                        style: AppTheme.getTheme().textTheme.labelLarge,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          _editProfile(context, 'Email', _email,
                              (updatedValue) {
                            setState(() {
                              _email = updatedValue;
                              _validEmail = emailValidatorBool(_email);
                            });
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Submitted Prompts',
                        style: AppTheme.getTheme().textTheme.labelLarge,
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          _submittedPrompts.toString(),
                          style: AppTheme.getTheme().textTheme.labelLarge,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Submitted Demonstrations',
                        style: AppTheme.getTheme().textTheme.labelLarge,
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          _submittedAnswers.toString(),
                          style: AppTheme.getTheme().textTheme.labelLarge,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Validations Made',
                        style: AppTheme.getTheme().textTheme.labelLarge,
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          _validationsMade.toString(),
                          style: AppTheme.getTheme().textTheme.labelLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_submittedPrompts! > 0 ||
                  _submittedAnswers! > 0 ||
                  _validationsMade! >
                      0) // Check if the user has any submissions or validations
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Badges Earned',
                        style: AppTheme.getTheme().textTheme.labelLarge,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Badges for submitted prompts
                            if (_submittedPrompts! >= 25)
                              const BadgeDisplay(
                                imagePath: 'assets/badges/legendaryPrompt.png',
                                badgeName: 'Legendary Submitter',
                              )
                            else if (_submittedPrompts! >= 10)
                              const BadgeDisplay(
                                imagePath: 'assets/badges/adeptPrompt.png',
                                badgeName: 'Adept Submitter',
                              )
                            else if (_submittedPrompts! >= 1)
                              const BadgeDisplay(
                                imagePath: 'assets/badges/novicePrompt.png',
                                badgeName: 'Novice Submitter',
                              ),

                            // Badges for submitted answers
                            if (_submittedAnswers! >= 25)
                              const BadgeDisplay(
                                imagePath:
                                    'assets/badges/legendaryDemonstrator.png',
                                badgeName: 'Legendary Demonstrator',
                              )
                            else if (_submittedAnswers! >= 10)
                              const BadgeDisplay(
                                imagePath:
                                    'assets/badges/adeptDemonstrator.png',
                                badgeName: 'Skilled Demonstrator',
                              )
                            else if (_submittedAnswers! >= 1)
                              const BadgeDisplay(
                                imagePath:
                                    'assets/badges/noviceDemonstrator.png',
                                badgeName: 'Brave Demonstrator',
                              ),

                            // Badges for validations made
                            if (_validationsMade! >= 25)
                              const BadgeDisplay(
                                imagePath:
                                    'assets/badges/legendaryValidator.png',
                                badgeName: 'Legendary Validator',
                              )
                            else if (_validationsMade! >= 10)
                              const BadgeDisplay(
                                imagePath: 'assets/badges/adeptValidator.png',
                                badgeName: 'Expert Validator',
                              )
                            else if (_validationsMade! >= 1)
                              const BadgeDisplay(
                                imagePath: 'assets/badges/noviceValidator.png',
                                badgeName: 'Valiant Validator',
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 20.0, left: 32.0, right: 32.0),
                child: InkWell(
                  onTap: () async {
                    if (!_validEmail) {
                      showSnackbar("Please enter a valid email address.",
                          backgroundColor:
                              AppTheme.getTheme().colorScheme.error);
                    }
                    if (!_validName) {
                      showSnackbar("Please enter a valid name.",
                          backgroundColor:
                              AppTheme.getTheme().colorScheme.error);
                    }
                    if (_validEmail && _validName) {
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
                        color: AppTheme.getTheme().colorScheme.background),
                    child: Center(
                      child: Text(
                        "Update Profile",
                        style: AppTheme.getTheme().textTheme.headlineMedium,
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
