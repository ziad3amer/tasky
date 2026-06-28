import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/constances/storage_kay.dart';
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custtom_svg_picture.dart';
import 'package:tasky/main.dart';
import 'package:tasky/features/profile/user_detials_screen.dart';
import 'package:tasky/features/welcome/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String username;
  late String motivationQuote;
  String? userImagePath;
  bool isLoading = true;


  void _loudData() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      username = PreferencesMangar().getString(StorageKay.username,) ?? "";
      isLoading = false;
      motivationQuote =
          PreferencesMangar().getString("Motivation Quote") ??
              "One task at a time. One step closer.";
      userImagePath = PreferencesMangar().getString("user_image");
    });
  }

  @override
  void initState() {
    super.initState();
    _loudData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Padding(
      padding: const EdgeInsets.all(16),
      child: Center(child: CircularProgressIndicator()),
    )
        : Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "My Profile",
            style: Theme
                .of(context)
                .textTheme
                .labelSmall,
          ),
          SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      backgroundImage: userImagePath == null
                          ? AssetImage('lib/assets/images/person.png')
                          : FileImage(File(userImagePath!)),
                      radius: 60,
                      backgroundColor: Colors.transparent,
                    ),
                    GestureDetector(
                      onTap: () async {
                        showImageSourceDialog(context, (XFile file) {
                          _saveImage(file);
                          setState(() {
                            userImagePath = file.path;
                          });
                        });
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme
                              .of(
                            context,
                          )
                              .colorScheme
                              .primaryContainer,
                        ),
                        child: Icon(Icons.camera_alt, size: 26),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  username,
                  style: Theme
                      .of(context)
                      .textTheme
                      .labelSmall,
                ),
                Text(
                  motivationQuote,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall,
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          Text(
            "Profile Info",
            style: Theme
                .of(context)
                .textTheme
                .labelSmall,
          ),

          SizedBox(height: 24),
          ListTile(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return UserDetialsScreen(
                      username: username,
                      motivationQuote: motivationQuote,
                    );
                  },
                ),
              );
              if (result != null && result) {
                _loudData();
              }
            },
            contentPadding: EdgeInsets.zero,
            title: Text("User Details"),
            leading: CusttomSvgPicture(
              path: "lib/assets/images/user.svg",
            ),

            trailing: CusttomSvgPicture(
              path: "lib/assets/images/arrow-right.svg",
            ),
          ),
          Divider(thickness: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Dark Mode"),
            leading: CusttomSvgPicture(
              path: "lib/assets/images/moon.svg",
            ),
            trailing: ValueListenableBuilder(
              valueListenable: ThemeController.themeNotifier,
              builder: (BuildContext context, value, Widget? child) {
                return Switch(
                  value: value == ThemeMode.dark,
                  onChanged: (bool value) async {
                    ThemeController.toggleTheme();
                  },
                );
              },
            ),
          ),
          Divider(thickness: 1),
          ListTile(
            onTap: () async {
              PreferencesMangar().remove(StorageKay.username);
              PreferencesMangar().remove("Motivation Quote");
              PreferencesMangar().remove("tasks");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return WelcomeScreen();
                  },
                ),
                    (Route<dynamic> route) => false,
              );
            },
            contentPadding: EdgeInsets.zero,
            title: Text("Log Out"),
            leading: CusttomSvgPicture(
              path: "lib/assets/images/Leading element.svg",
            ),
            trailing: CusttomSvgPicture(
              path: "lib/assets/images/arrow-right.svg",
            ),
          ),
        ],
      ),
    );
  }

  void _saveImage(XFile file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newFile = await File(file.path).copy(
        "${appDir.path}/${file.name}");

    PreferencesMangar().setString("user_image", newFile.path);
  }
}
  void showImageSourceDialog(BuildContext context, Function(XFile)selectedFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            "Choose Image source",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  selectedFile(image);

                }
              },
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.camera_alt),
                  SizedBox(width: 8),
                  Text("Camera"),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  selectedFile(image);
                }
              },
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.photo_library),
                  SizedBox(width: 8),
                  Text("Gallery"),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
