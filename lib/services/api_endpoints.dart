class ApiEndpoints {
  ApiEndpoints._();

  // Change this to the provided base URL during live test
  static const String baseUrl = 'https://example.com/api';

  static const String login = '$baseUrl/login';
  static const String getData = '$baseUrl/data';
}
