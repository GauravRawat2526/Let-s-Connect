import 'package:flutter/foundation.dart';

class UserData extends ChangeNotifier {
  String _userName;
  String _name;
  String _imageUrl;
  String _aboutUser;

  void setUserData(
      String userName, String name, String imageUrl, String aboutUser) {
    _userName = userName;
    _name = name;
    _imageUrl = imageUrl;
    _aboutUser = aboutUser;
    notifyListeners();
  }

  String get userName {
    return _userName;
  }

  String get name {
    return _name;
  }

  String get imageUrl {
    return _imageUrl;
  }

  String get aboutUser {
    return _aboutUser;
  }
}
