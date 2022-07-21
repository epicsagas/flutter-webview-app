import 'dart:io';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeController extends GetxController {

  late WebViewController webViewController;

  @override
  void onInit() {
    super.onInit();
    // android virtual webview
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {}
}
