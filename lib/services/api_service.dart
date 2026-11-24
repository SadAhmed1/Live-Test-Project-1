import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();

  // GET Request
  static Future<dynamic> get(String url, {String? token}) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http.get(Uri.parse(url), headers: headers);
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
      final headers = <String, String>{
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // Response Status Code Handler
  static dynamic _processResponse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      final message =
          body is Map && body.containsKey('message')
              ? body['message']
              : 'Server Error: ${response.statusCode}';
      throw Exception(message);
    }
  }
}
