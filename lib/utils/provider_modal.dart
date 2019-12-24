import 'package:flutter/material.dart';

class IsLoginModal with ChangeNotifier {
  bool _isLogin = false;
  bool get isLogin => _isLogin;

  void changeLoginState(flag) {
    _isLogin = flag;
    notifyListeners();
  }
}
