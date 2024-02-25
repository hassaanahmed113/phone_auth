import 'package:flutter/material.dart';

class PhoneProvider extends ChangeNotifier {
  String phone = '';

  void phoneUpdate(String phne) {
    phone = phne;
    notifyListeners();
  }
}
