import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io' show Platform;

class AuthService extends ChangeNotifier {
  late final bool _useFirebase;

  AuthService() {
    _useFirebase = !Platform.isWindows && !Platform.isLinux && !Platform.isMacOS;
    if (_useFirebase) {
      // Firebase is used on mobile and web
    } else {
      // Mock on desktop
      _currentUserMock = null;
    }
  }

  String? _currentUserMock;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser {
    if (!_useFirebase) return null;
    try {
      return _auth.currentUser;
    } catch (e) {
      return null;
    }
  }

  Stream<User?> authStateChanges() {
    if (!_useFirebase) return Stream.value(null);
    try {
      return _auth.authStateChanges();
    } catch (e) {
      return Stream.value(null);
    }
  }

  Future<void> signIn(String email, String password) async {
    if (_useFirebase) {
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        notifyListeners();
      } catch (e) {
        throw e;
      }
    } else {
      // Mock
      _currentUserMock = email;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    if (_useFirebase) {
      try {
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
        notifyListeners();
      } catch (e) {
        throw e;
      }
    } else {
      // Mock
      _currentUserMock = email;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    if (_useFirebase) {
      try {
        await _auth.signOut();
      } catch (e) {
        // Ignore
      }
    } else {
      _currentUserMock = null;
    }
    notifyListeners();
  }

  bool get useFirebase => _useFirebase;

  String? get currentUserId {
    if (_useFirebase) {
      try {
        return _auth.currentUser?.uid;
      } catch (e) {
        return null;
      }
    } else {
      return _currentUserMock;
    }
  }
}