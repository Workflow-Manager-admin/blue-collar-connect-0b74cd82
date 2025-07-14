import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../api/models.dart';

/// Manages loading jobs, searching, getting job details, and applying for jobs.
class JobsProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  List<Job> jobs = [];

  // Fetches available jobs from the API.
  // PUBLIC_INTERFACE
  Future<void> fetchJobs() async {
    isLoading = true;
    error = null;
    notifyListeners();

    final resp = await ApiClient.instance.request('/jobs');
    if (resp.isSuccess && resp.data is List) {
      // Add try-catch to identify model parsing bugs
      try {
        jobs = (resp.data as List).map((j) => Job.fromJson(j)).toList();
      } catch (e) {
        jobs = [];
        error = 'Job parsing error: $e';
      }
    } else if (resp.error != null) {
      error = resp.error;
    }
    isLoading = false;
    notifyListeners();
  }

  // Apply to a job with given jobId.
  // PUBLIC_INTERFACE
  Future<bool> applyToJob(String jobId) async {
    isLoading = true;
    notifyListeners();

    final resp = await ApiClient.instance.request(
      '/jobs/$jobId/apply',
      method: 'POST',
      requireAuth: true,
    );
    isLoading = false;
    notifyListeners();
    if (resp.isSuccess) {
      await fetchJobs();  // Refresh jobs list if desired.
      return true;
    } else {
      error = resp.error;
      return false;
    }
  }
}
