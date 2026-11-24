import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_endpoints.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';
import '../views/screens/home_screen.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  String? token;

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

      token = response['token'] ?? response['data']?['token'];

      Get.snackbar(
        'Success',
        'Login successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: AppColors.white,
      );

      Get.offAll(() => HomeScreen(token: token));
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
