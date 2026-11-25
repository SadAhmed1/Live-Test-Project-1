import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_endpoints.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';
import '../views/screens/home_screen.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  String? token;
  String? userName;
  String? userPhoto;

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter email and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await ApiService.post(
        ApiEndpoints.login,
        {
          'email': email,
          'password': password,
        },
      );

      // Extract Token & User Details from Postman Response structure
      if (response != null && response['data'] != null) {
        token = response['data']['accessToken'] ?? response['data']['token'];
        if (response['data']['user'] != null) {
          userName = response['data']['user']['name'];
          userPhoto = response['data']['user']['photoUrl'];
        }
      } else {
        token = response['token'] ?? response['accessToken'];
      }

      Get.snackbar(
        'Success',
        'Login successful!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: AppColors.white,
      );

      Get.offAll(() => HomeScreen(
            token: token,
            userName: userName,
          ));
    } catch (e) {
      final err = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Login Failed',
        err,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
