import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../api/models.dart';

class ApplicationsProvider extends ChangeNotifier {
  List<JobApplication> applications = [];
  bool isLoading = false;
  String? error;

  // Fetches user's job applications from API.
  // PUBLIC_INTERFACE
  Future<void> fetchApplications() async {
    isLoading = true;
    error = null;
    notifyListeners();

    final resp = await ApiClient.instance.request('/applications');
    if (resp.isSuccess && resp.data is List) {
      applications = (resp.data as List)
          .map((a) => JobApplication.fromJson(a))
          .toList();
    } else {
      error = resp.error;
    }
    isLoading = false;
    notifyListeners();
  }
}
