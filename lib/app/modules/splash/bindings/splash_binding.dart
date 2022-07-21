import 'package:get/get.dart';
import 'package:webview/app/controllers/app_controller.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController(
      appController: Get.find<AppController>(),
    ));
  }
}
