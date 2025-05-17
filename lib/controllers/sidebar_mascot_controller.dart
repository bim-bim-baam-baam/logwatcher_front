import 'package:flutter/material.dart';

class SidebarMascotController extends ChangeNotifier {
  String _current = 'bro';
  DateTime lastActivity = DateTime.now();

  String get current => _current;

  void set(String newState) {
    _current = newState;
    markActivity();
    notifyListeners();
  }

  void markActivity() {
    lastActivity = DateTime.now();
  }

  void reset() => set('bro');
}
