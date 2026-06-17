import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_mangar.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);


  init() {
    bool result = PreferencesMangar().getBoll("theme") ?? true;
    themeNotifier.value = result ? ThemeMode.dark : ThemeMode.light;
  }
  static toggleTheme()async{
    if(themeNotifier.value==ThemeMode.dark){
      themeNotifier.value=ThemeMode.light;
      await PreferencesMangar().setBoll("theme", false);
    }else
      {
      themeNotifier.value=ThemeMode.dark;
      await PreferencesMangar().setBoll("theme", true);
      }
  }
  static bool isDark()=> themeNotifier.value==ThemeMode.dark;

}
