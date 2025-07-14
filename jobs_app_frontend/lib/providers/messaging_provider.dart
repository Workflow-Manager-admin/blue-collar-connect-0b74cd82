import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../api/models.dart';

class MessagingProvider extends ChangeNotifier {
  List<MessageThread> threads = [];
  bool isLoading = false;
  String? error;

  // Fetch threads or DMs.
  // PUBLIC_INTERFACE
  Future<void> fetchThreads() async {
    isLoading = true;
    error = null;
    notifyListeners();
    final resp = await ApiClient.instance.request('/messages');
    if (resp.isSuccess && resp.data is List) {
      try {
        threads = (resp.data as List)
            .map((t) => MessageThread.fromJson(t))
            .toList();
      } catch (e) {
        threads = [];
        error = 'Messages parsing error: $e';
      }
    } else {
      error = resp.error;
    }
    isLoading = false;
    notifyListeners();
  }

  // Send a message to a contact/thread.
  // PUBLIC_INTERFACE
  Future<void> sendMessage(String threadId, String text) async {
    final resp = await ApiClient.instance.request(
      '/messages/$threadId',
      method: 'POST',
      body: {'text': text},
      requireAuth: true,
    );
    if (!resp.isSuccess) {
      error = resp.error;
    } else {
      await fetchThreads();
    }
    notifyListeners();
  }
}
