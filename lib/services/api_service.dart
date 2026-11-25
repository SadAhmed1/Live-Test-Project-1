import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();

  // Helper to format Auth Header
  static Map<String, String> _buildHeaders({String? token}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      final formattedToken =
          token.startsWith('Bearer ') ? token : 'Bearer $token';
      headers['Authorization'] = formattedToken;
      headers['authorization'] = formattedToken;
      headers['token'] = token;
      headers['accessToken'] = token;
    }

    return headers;
  }

  // GET Request
  static Future<dynamic> get(String url, {String? token}) async {
    try {
      final headers = _buildHeaders(token: token);

      if (kDebugMode) {
        print('GET Request to: $url');
      }

      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 12));

      return _processResponse(response);
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // POST Request
  static Future<dynamic> post(
    String url,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    try {
      final headers = _buildHeaders(token: token);

      if (kDebugMode) {
        print('POST Request to: $url');
        print('POST Body: ${jsonEncode(body)}');
      }

      final response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 12));

      return _processResponse(response);
    } catch (e) {
      throw Exception('$e');
    }
  }

  // Multipart File/Image Upload
  static Future<dynamic> uploadMultipart({
    required String url,
    required String filePath,
    required String fieldName,
    Map<String, String>? fields,
    String? token,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));

      if (token != null && token.isNotEmpty) {
        final formattedToken =
            token.startsWith('Bearer ') ? token : 'Bearer $token';
        request.headers['Authorization'] = formattedToken;
        request.headers['authorization'] = formattedToken;
      }

      if (fields != null) {
        request.fields.addAll(fields);
      }

      final multipartFile =
          await http.MultipartFile.fromPath(fieldName, filePath);
      request.files.add(multipartFile);

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      return _processResponse(response);
    } catch (e) {
      throw Exception('Upload Failed: $e');
    }
  }

  // Response Status Code Handler
  static dynamic _processResponse(http.Response response) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = response.body;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      String message = 'Server Error (${response.statusCode})';
      if (body is Map) {
        message = body['message'] ?? body['error'] ?? message;
      }
      throw Exception(message);
    }
  }
}
