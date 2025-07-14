import 'package:flutter/material.dart';
import '../api/api_client.dart';

/// Exposes login/logout/session state via Provider.
/// Change this to hook in your backend auth endpoints as needed.
class SessionProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;

  // Call this after successful sign-in/up, and set token.
  // PUBLIC_INTERFACE
  Future<void> signIn(String token) async {
    _isAuthenticated = true;
    _token = token;
    await ApiClient.instance.setToken(token);
    notifyListeners();
  }

  // Sign out and clear token/session.
  // PUBLIC_INTERFACE
  Future<void> signOut() async {
    _isAuthenticated = false;
    _token = null;
    await ApiClient.instance.setToken(null);
    notifyListeners();
  }
}
