import 'package:flutter/foundation.dart';

class SessionController extends ChangeNotifier {
  SessionController({bool isOnboarded = false}) : _isOnboarded = isOnboarded;

  bool _isOnboarded;

  bool get isOnboarded => _isOnboarded;

  void setOnboarded(bool value) {
    if (_isOnboarded == value) {
      return;
    }
    _isOnboarded = value;
    notifyListeners();
  }
}
