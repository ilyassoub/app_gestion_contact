import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  String? _currentUser;

  String? get currentUser => _currentUser;

  Stream<String?> authStateChanges() {
    return Stream.value(_currentUser);
  }

  Future<void> signIn(String email, String password) async {
    // Simulation : accepter tout email/password
    _currentUser = email;
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    _currentUser = email;
    notifyListeners();
  }

  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }
}