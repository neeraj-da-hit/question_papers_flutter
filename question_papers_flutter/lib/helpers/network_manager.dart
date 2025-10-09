import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:question_papers_flutter/constant/app_constants.dart'; // for kDebugMode

/// 🌐 NetworkManager — a centralized API helper using HTTP + GetX
/// Supports GET, POST, PUT, DELETE, FILE UPLOAD
/// Automatically logs everything in debug mode
class NetworkManager extends GetxService {
  // 🔗 Base URL — customize this
  static const String baseUrl = AppConstants.baseApiUrl;

  // 🧱 Default headers
  Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  String? _authToken;

  /// Set bearer token for authorized requests
  void setAuthToken(String token) {
    _authToken = token;
    if (kDebugMode) print("🔐 Auth Token Set");
  }

  /// Clear bearer token
  void clearAuthToken() {
    _authToken = null;
    if (kDebugMode) print("🔓 Auth Token Cleared");
  }

  // ===========================================================
  // 📡 GET REQUEST
  // ===========================================================
  Future<dynamic> getRequest(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');//.replace(queryParameters: query)

    _logRequest(
      method: "GET",
      uri: uri,
      headers: headers ?? _defaultHeaders,
      query: query,
    );

    try {
      final response = await http.get(uri, headers: headers ?? _defaultHeaders);
      return _handleResponse(response, uri);
    } catch (e) {
      _handleError(e, uri);
    }
  }

  // ===========================================================
  // 📨 POST REQUEST
  // ===========================================================
  Future<dynamic> postRequest(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');

    _logRequest(
      method: "POST",
      uri: uri,
      headers: headers ?? _defaultHeaders,
      body: body,
    );

    try {
      final response = await http.post(
        uri,
        headers: headers ?? _defaultHeaders,
        body: jsonEncode(body),
      );
      return _handleResponse(response, uri);
    } catch (e) {
      _handleError(e, uri);
    }
  }

  // ===========================================================
  // ✏️ PUT REQUEST
  // ===========================================================
  Future<dynamic> putRequest(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');

    _logRequest(
      method: "PUT",
      uri: uri,
      headers: headers ?? _defaultHeaders,
      body: body,
    );

    try {
      final response = await http.put(
        uri,
        headers: headers ?? _defaultHeaders,
        body: jsonEncode(body),
      );
      return _handleResponse(response, uri);
    } catch (e) {
      _handleError(e, uri);
    }
  }

  // ===========================================================
  // ❌ DELETE REQUEST
  // ===========================================================
  Future<dynamic> deleteRequest(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');

    _logRequest(
      method: "DELETE",
      uri: uri,
      headers: headers ?? _defaultHeaders,
    );

    try {
      final response = await http.delete(
        uri,
        headers: headers ?? _defaultHeaders,
      );
      return _handleResponse(response, uri);
    } catch (e) {
      _handleError(e, uri);
    }
  }

  // ===========================================================
  // 📤 FILE UPLOAD (PDF, IMAGE, DOC)
  // ===========================================================
  Future<dynamic> uploadFile({
    required String endpoint,
    required File file,
    String fieldName = 'file',
    Map<String, String>? fields,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');

    _logRequest(
      method: "UPLOAD",
      uri: uri,
      headers: headers ?? _defaultHeaders,
      body: fields,
      file: file.path,
    );

    try {
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers ?? _defaultHeaders);

      // File
      request.files.add(
        await http.MultipartFile.fromPath(fieldName, file.path),
      );

      // Extra fields (optional)
      if (fields != null) {
        request.fields.addAll(fields);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response, uri);
    } catch (e) {
      _handleError(e, uri);
    }
  }

  // ===========================================================
  // 🧩 RESPONSE HANDLER
  // ===========================================================
  dynamic _handleResponse(http.Response response, Uri uri) {
    if (kDebugMode) {
      print("\n🟩 [RESPONSE] ${response.statusCode} → ${uri.toString()}");
      print("Body: ${response.body}\n");
    }

    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (body is Map<String, dynamic>) {
        return body;
      } else if (body is List) {
        return {"data": body}; // unify array responses
      } else {
        return {"data": body};
      }
    } else {
      if (kDebugMode) {
        print("❌ Error ${response.statusCode}: ${response.body}");
      }
      throw HttpException(
        "Request failed: [${response.statusCode}] ${response.reasonPhrase}",
      );
    }
  }

  // ===========================================================
  // ⚠️ ERROR HANDLER
  // ===========================================================
  void _handleError(dynamic e, Uri uri) {
    if (kDebugMode) {
      print("🔴 [ERROR] on ${uri.toString()}");
      print("Message: $e\n");
    }

    if (e is SocketException) {
      throw Exception("No Internet connection");
    } else if (e is HttpException) {
      throw Exception(e.message);
    } else {
      throw Exception("Unexpected error: $e");
    }
  }

  // ===========================================================
  // 🧾 DEBUG LOGGER
  // ===========================================================
  void _logRequest({
    required String method,
    required Uri uri,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    String? file,
  }) {
    if (!kDebugMode) return;

    print("────────────────────────────────────────────");
    print("🚀 API REQUEST → [$method] ${uri.toString()}");

    if (query != null && query.isNotEmpty) {
      print("🔸 Query Params: ${jsonEncode(query)}");
    }

    if (headers != null && headers.isNotEmpty) {
      print("🔸 Headers: ${jsonEncode(headers)}");
    }

    if (body != null && body.isNotEmpty) {
      print("📦 Body: ${jsonEncode(body)}");
    }

    if (file != null) {
      print("📂 File Path: $file");
    }

    print("────────────────────────────────────────────");
  }
}
