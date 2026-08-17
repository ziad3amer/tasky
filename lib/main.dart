import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constances/storage_kay.dart';
import 'package:tasky/core/services/hive_storage_manager.dart';
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/core/theme/dark_theme.dart';
import 'package:tasky/core/theme/light_theme.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/features/navigation/main_screen.dart';
import 'package:tasky/features/tasks/controller/tasks_controller.dart';
import 'package:tasky/features/welcome/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("start preferences");
  await PreferencesMangar().init();
  print("start theme");
  await ThemeController().init();
  print("start hive");
  await HiveStorageManager().init();
  print("before username");

  String? username = await PreferencesMangar().getString(StorageKay.username,);
  print("before runApp");

  runApp(MyApp(username: username));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.username});

  final String? username;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeNotifier,
      builder: (context, ThemeMode value, Widget? child) {
        return ChangeNotifierProvider<TasksController>(
          create: (BuildContext context) =>TasksController()..init(),
          child: ScreenUtilInit(
            designSize: const Size(375, 889),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                title: 'Tasky',
                debugShowCheckedModeBanner: false,
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: value,
                home: username == null ? WelcomeScreen() : MainScreen(),
              );
            },
          ),
        );
      },
    );
  }
}
