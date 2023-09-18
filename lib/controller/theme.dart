import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTheme with ChangeNotifier {
  var theme = Brightness.light;
  Color primaryColor = Colors.lightBlue[800]!;


  void changeTheme()async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (theme == Brightness.light) {
      theme = Brightness.dark;
      pref.setBool("isLightTheme", false);
    } else {
      theme = Brightness.light;
      pref.setBool("isLightTheme", true);
    }
    notifyListeners();
  }

  void changColorToBlue() {
    primaryColor = Colors.lightBlue[800]!;
    notifyListeners();
  }

  void changColorToTeal() {
    primaryColor = Colors.teal;
    notifyListeners();
  }

  void changColorToRed() {
    primaryColor = Colors.redAccent;
    notifyListeners();
  }
}
