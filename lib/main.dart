import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:webview/app/controllers/app_controller.dart';

import 'app/controllers/analytics_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  initApp();
}

Future<void> initApp() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  bool debug = false;
  double tracesSampleRate = 0.2;
  String sentryDsn = dotenv.get('SENTRY_DSN');

  if (kDebugMode) {
    debug = true;
    tracesSampleRate = 1.0;
  }

  Get.put(AppController());

  // initialize analytics controller
  Get.put(AnalyticsController());

  final app = GetMaterialApp(
    // debugShowCheckedModeBanner: false,
    title: dotenv.get('APP_NAME').toUpperCase(),
    initialRoute: AppPages.INITIAL,
    getPages: AppPages.routes,
  );

  if (sentryDsn.isNotEmpty) {
    await SentryFlutter.init((options) {
      options.dsn = sentryDsn;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.release = "${packageInfo.appName}@${packageInfo.version}";
      options.environment = debug ? 'development' : 'production';
      options.tracesSampleRate = tracesSampleRate;
    }, appRunner: () => runApp(app),);
  } else {
    runApp(app);
  }
}