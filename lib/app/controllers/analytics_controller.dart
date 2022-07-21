import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:advertising_id/advertising_id.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:logger/logger.dart';
import 'package:webview/app/controllers/app_controller.dart';

import '../../firebase_options.dart';

class AnalyticsController extends GetxController {
  final AppController appController = Get.find<AppController>();
  var advertisingId = ''.obs;
  var isLimitAdTrackingEnabled = false.obs;
  var appVersion = ''.obs;

  // analytics single instances
  late FirebaseAnalytics firebase;

  final logger = Logger();

  @override
  void onInit() async {
    super.onInit();
    await initialize();

    isLimitAdTrackingEnabled.listen((value) {
      if (value == true) {
        firebase.setAnalyticsCollectionEnabled(false);
      }
    });

    appController.appInitilized.value = true;
  }

  Future<void> initialize() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;

    try {
      await initATT();

      // 통계 초기화
      await initFirebase();
    } catch (exception) {
      Sentry.captureException(exception);
    }
  }

  // ios ATT 초기화
  Future<void> initATT() async {
    try {
      if (Platform.isIOS) {
        // iOS ATT 체크
        if (await AppTrackingTransparency.trackingAuthorizationStatus ==
            TrackingStatus.notDetermined) {
          // if (await att_popup("")) {
          await AppTrackingTransparency.requestTrackingAuthorization();
          // }
        }
      }
    } on PlatformException {
      isLimitAdTrackingEnabled.value = true;
    }

    isLimitAdTrackingEnabled.value = (await AdvertisingId.isLimitAdTrackingEnabled)!;

    // 광고 ID 체크
    try {
      if (Platform.isIOS) {
        advertisingId.value = await AppTrackingTransparency.getAdvertisingIdentifier();
      } else {
        advertisingId.value = (await AdvertisingId.id(true))!;
      }
    } on PlatformException {
      advertisingId.value = '';
    }
  }

  // Firebase analytics 초기화
  Future<void> initFirebase() async {
    try {
      await Firebase.initializeApp(
        name: dotenv.get('APP_NAME'),
        options: DefaultFirebaseOptions.currentPlatform,
      );

      FirebaseAnalytics analytics = FirebaseAnalytics.instance;

      if (isLimitAdTrackingEnabled.value == true) {
        analytics.setAnalyticsCollectionEnabled(false);
      } else {
        analytics.setAnalyticsCollectionEnabled(true);

        firebase = analytics;

        update();
      }
    } catch (exception) {
      Sentry.captureException(exception);
    }
  }
}
