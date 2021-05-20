import 'package:flutter/foundation.dart';

class StatusData extends ChangeNotifier {
  String _id;
  List<String> _userImage;
  String _link;

  void setUserData( String id, List<String> userImage, String link) {
    _id=id;
    _userImage=userImage;
    _link=link;
    notifyListeners();
  }

  String get id {
    return _id;
  }

  List<String> get userImage {
    return _userImage;
  }

  String get link {
    return _link;
  }
}
