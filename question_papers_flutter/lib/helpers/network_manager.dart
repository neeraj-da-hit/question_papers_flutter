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
    final uri = Uri.parse(
      '$baseUrl/$endpoint',
    ); //.replace(queryParameters: query)

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

  Future<dynamic> putMultipartRequest({
    required String endpoint,
    Map<String, String>? fields,
    File? imageFile,
    String imageFieldName = 'profilePic',
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');

    // Remove 'Content-Type' so http can set it automatically
    final effectiveHeaders = Map<String, String>.from(
      headers ?? _defaultHeaders,
    )..remove('Content-Type');

    final request = http.MultipartRequest('PUT', uri);
    request.headers.addAll(effectiveHeaders);

    if (fields != null) request.fields.addAll(fields);

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(imageFieldName, imageFile.path),
      );
    }

    if (kDebugMode) {
      print("🚀 [PUT Multipart] → ${uri.toString()}");
      print("Fields: $fields");
      if (imageFile != null) print("File: ${imageFile.path}");
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response, uri);
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

  Future<dynamic> uploadFileWithFields({
    required String endpoint,
    required File imageFile,
    required Map<String, String> fields,
    String fieldName = 'image',
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');

    final request = http.MultipartRequest('POST', uri);

    final effectiveHeaders = Map<String, String>.from(
      headers ?? _defaultHeaders,
    )..remove('Content-Type'); // important!
    request.headers.addAll(effectiveHeaders);

    // text fields
    request.fields.addAll(fields);

    // image file
    request.files.add(
      await http.MultipartFile.fromPath(fieldName, imageFile.path),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response, uri);
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
    final responseBody = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : null;

    // ✅ Success responses (200–299)
    if (statusCode >= 200 && statusCode < 300) {
      if (responseBody is Map<String, dynamic>) {
        return responseBody;
      } else if (responseBody is List) {
        return {"data": responseBody};
      } else {
        return {"data": responseBody};
      }
    }
    // ❌ Handle error responses (400, 401, 500, etc.)
    else {
      String message = "Something went wrong";

      try {
        if (responseBody is Map && responseBody.containsKey("message")) {
          message = responseBody["message"].toString();
        } else if (responseBody is String && responseBody.isNotEmpty) {
          message = responseBody;
        } else {
          message = "Request failed (${response.statusCode})";
        }
      } catch (_) {
        message = "Request failed (${response.statusCode})";
      }

      if (kDebugMode) {
        print("❌ Error ${response.statusCode}: $message");
      }

      // 🧩 Throw a meaningful exception
      throw ApiException(message);
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
    } else if (e is Exception) {
      // ✅ Re-throw the existing exception (e.g. from _handleResponse)
      throw e;
    } else {
      throw Exception("Unexpected error");
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

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message; // no "Exception:" prefix
}
