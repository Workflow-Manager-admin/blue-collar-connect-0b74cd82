/*
 A generic HTTP API client for communicating with the backend.

 Handles authentication token management, making requests, error handling,
 loading state, and supports integration for:
 - User authentication (sign in, sign up, logout)
 - Profile (view/edit)
 - Jobs (list/search/details/apply)
 - Companies (details)
 - Applications (list/status/apply)
 - Messaging (list/send/receive)
 Usage: Use ApiClient.instance (singleton) in your data providers and view models.
*/

import 'dart:convert';
import 'package:http/http.dart' as http;

typedef Json = Map<String, dynamic>;

/// Singleton API client to handle network calls and token/session management.
/// Change [baseUrl] to your deployed backend or use env config.
class ApiClient {
  static final ApiClient instance = ApiClient._internal();

  factory ApiClient() => instance;

  // Example: adjust this URL to your backend API root (http://localhost:5000/api)
  String baseUrl = "http://10.0.2.2:5001/api"; // Use emulator's loopback on Android

  String? _token;

  ApiClient._internal();

  // PUBLIC_INTERFACE
  Future<void> setToken(String? token) async {
    _token = token;
  }

  // PUBLIC_INTERFACE
  String? get token => _token;

  Map<String, String> get _defaultHeaders {
    final h = {'Content-Type': 'application/json'};
    if (_token != null) h['Authorization'] = 'Bearer $_token';
    return h;
  }

  // Handles GET, POST, PUT, DELETE generically.
  // PUBLIC_INTERFACE
  Future<ApiResponse> request(
    String path, {
    String method = 'GET',
    Json? body,
    Map<String, String>? query,
    Map<String, String>? headers,
    bool requireAuth = false,
  }) async {
    final uri = Uri.parse("$baseUrl$path").replace(queryParameters: query);
    final requestHeaders = {..._defaultHeaders, if (headers != null) ...headers};

    http.Response resp;

    try {
      switch (method) {
        case 'POST':
          resp = await http.post(uri,
              headers: requestHeaders, body: jsonEncode(body ?? {}));
          break;
        case 'PUT':
          resp = await http.put(uri,
              headers: requestHeaders, body: jsonEncode(body ?? {}));
          break;
        case 'DELETE':
          resp = await http.delete(uri, headers: requestHeaders);
          break;
        case 'GET':
        default:
          resp = await http.get(uri, headers: requestHeaders);
      }
    } catch (e) {
      return ApiResponse.error("Network error: $e");
    }

    Json? data;
    try {
      data = resp.body.isNotEmpty ? jsonDecode(resp.body) : null;
    } catch (_) {}

    if (resp.statusCode >= 400) {
      return ApiResponse.error(
          data?['error']?.toString() ?? resp.reasonPhrase ?? "HTTP ${resp.statusCode}",
          status: resp.statusCode,
          details: data);
    }
    return ApiResponse.success(data);
  }
}

class ApiResponse<T> {
  final T? data;
  final String? error;
  final int? status;
  final dynamic details;

  ApiResponse.success(this.data)
      : error = null,
        status = null,
        details = null;
  ApiResponse.error(this.error, {this.status, this.details}) : data = null;

  bool get isSuccess => error == null;

  static ApiResponse<T> fromResponse<T>(http.Response response, T Function(Json?) parse) {
    if (response.statusCode >= 400) {
      Json? details;
      try {
        details = jsonDecode(response.body);
      } catch (_) {}
      return ApiResponse.error(
        details?['error'] ?? 'HTTP ${response.statusCode}',
        status: response.statusCode,
        details: details,
      );
    }
    Json? body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {}
    return ApiResponse.success(parse(body));
  }
}
