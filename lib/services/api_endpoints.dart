class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.fototidy.com/api/v1';

  // Auth Endpoints
  static const String login = '$baseUrl/auth/login';

  // Photo / Gallery Endpoints
  static const String myPhotos = '$baseUrl/upload-photos/my-photos';
  static const String uploadPhoto = '$baseUrl/upload-photos/my-photos';
}
