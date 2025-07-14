import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../api/models.dart';

class ProfileProvider extends ChangeNotifier {
  UserProfile? profile;
  bool isLoading = false;
  String? error;

  // Fetches user profile.
  // PUBLIC_INTERFACE
  Future<void> fetchProfile() async {
    isLoading = true;
    error = null;
    notifyListeners();
    final resp = await ApiClient.instance.request('/profile');
    if (resp.isSuccess && resp.data != null) {
      profile = UserProfile.fromJson(resp.data);
    } else {
      error = resp.error;
    }
    isLoading = false;
    notifyListeners();
  }

  // Update profile info.
  // PUBLIC_INTERFACE
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    isLoading = true;
    notifyListeners();
    final resp = await ApiClient.instance.request(
      '/profile',
      method: 'PUT',
      body: updates,
      requireAuth: true,
    );
    isLoading = false;
    if (!resp.isSuccess) {
      error = resp.error;
    } else {
      profile = UserProfile.fromJson(resp.data);
    }
    notifyListeners();
  }
}
