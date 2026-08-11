import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileStorageManager {
  static final FileStorageManager _instance = FileStorageManager._();

  FileStorageManager._();

  factory FileStorageManager() {
    return _instance;
  }

  late final Directory _appDocumentsDirectory;
  late final File _tasksFile;

  //mn hena 3maeyt el initialization
  init() async {
    _appDocumentsDirectory = await getApplicationDocumentsDirectory();
    _tasksFile = File("${_appDocumentsDirectory.path}/tasks.json");
  }

  SaveTasks(List<dynamic> list) async {
    final listJson = jsonEncode(list);
    await _tasksFile.writeAsString(listJson); //da 3bara 3n el path
  }

  Future<List<dynamic>> loadTasks() async {
    if (!await _tasksFile.exists()) return [];

    final tasksJson = await _tasksFile.readAsString();
    return jsonDecode(tasksJson) as List<dynamic>;
  }
}
