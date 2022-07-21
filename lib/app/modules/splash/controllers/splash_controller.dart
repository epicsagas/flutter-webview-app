import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../../../controllers/app_controller.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {

  final AppController appController;

  SplashController({required this.appController});

  int splashDuration = 1000;

  @override
  void onInit() {
    super.onInit();

    splashDuration = int.parse(dotenv.get('SPLASH_DURATION'));

    appController.appInitilized.listen((value) async {
      if (value) {
        await loading();
      }
    });
  }

  @override
  void onReady() async {
    super.onReady();
  }

  Future<void> loading() async {
    Timer(Duration(milliseconds: splashDuration), () {
      Get.offAndToNamed(Routes.HOME);
    });
  }
}