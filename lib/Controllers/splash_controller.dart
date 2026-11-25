import 'package:get/get.dart';
import '../services/storage_service.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/login_screen.dart';
import 'auth_controller.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    final results = await Future.wait([
      Future.delayed(const Duration(milliseconds: 2200)),
      StorageService.getToken(),
      StorageService.getUser(),
    ]);

    final token = results[1] as String?;
    final user = results[2];

    if (token != null && token.isNotEmpty) {
      final authController = Get.put(AuthController(), permanent: true);
      authController.hydrateSession(token: token, user: user);
      Get.offAll(() => HomeScreen(
            token: token,
            userName: authController.userName,
          ));
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }
}
