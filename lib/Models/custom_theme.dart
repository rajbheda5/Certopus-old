import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:certopus/Constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomTheme extends ChangeNotifier {
  //default theme Light
  Color _backgroundColor = kWhite;
  Color _primaryColor = kLightPrimary;
  Color _secondaryColor = kLightSecondary;
  bool _isDark = false;

  void setPrefs(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', value);
  }

  void setLight() {
    _backgroundColor = kWhite;
    _primaryColor = kLightPrimary;
    _secondaryColor = kLightSecondary;
    _isDark = false;
    setPrefs(false);
    notifyListeners();
  }

  void setDark() {
    _backgroundColor = kDark;
    _primaryColor = kDarkPrimary;
    _secondaryColor = kWhite;
    _isDark = true;
    setPrefs(true);
    notifyListeners();
  }

  Color get getPrimaryColor {
    return _primaryColor;
  }

  Color get getSecondaryColor {
    return _secondaryColor;
  }

  Color get getBackgroundColor {
    return _backgroundColor;
  }

  bool get isDark {
    return _isDark;
  }
}
