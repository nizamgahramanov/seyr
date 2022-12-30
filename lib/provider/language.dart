import 'package:flutter/cupertino.dart';

class Language extends ChangeNotifier {
  void onLanguageChanged() {
    notifyListeners();
  }
}
