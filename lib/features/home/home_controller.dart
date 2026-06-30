import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/constances/storage_kay.dart';
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/model/task_model.dart';
class HomeController with ChangeNotifier {
  List<TaskModel> tasksList = [];
  String? username = "Default";
  String? userImagePath;
  init(){
      loudUserData();
  }
  void loudUserData() async {
    final pref = await SharedPreferences.getInstance();
    username = PreferencesMangar().getString(StorageKay.username);
    userImagePath = PreferencesMangar().getString(StorageKay.userImage);
    notifyListeners();
  }



}
