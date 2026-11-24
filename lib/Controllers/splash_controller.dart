import 'package:get/get.dart';
import '../views/screens/login_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    Get.offAll(() => const LoginScreen());
  }
}
