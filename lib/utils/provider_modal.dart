import 'package:flutter/material.dart';

class IsLoginModal with ChangeNotifier {
  bool _isLogin = false;
  bool get isLogin => _isLogin;

  void changeLoginState(flag) {
    _isLogin = flag;
    notifyListeners();
  }

  int _userId = 0;
  int get userId => _userId;

  void changeUserId(val) {
    _userId = val;
    notifyListeners();
  }

  String _userName = '';
  String get userName => _userName;

  void changeUserName(val) {
    _userName = val;
    notifyListeners();
  }

  Map _articleData;
  Map get articleData => _articleData;
  void changeArticleData(val) {
    _articleData = val;
    notifyListeners();
  }
}
