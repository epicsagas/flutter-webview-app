import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  Future<bool> handleBackButton(BuildContext context) async {
    bool willLeave = false;

    if (await controller.webViewController.canGoBack()) {
      controller.webViewController.goBack();
    } else {
      await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(dotenv.get('ALERT_CLOSE_APP')),
            actions: [
              ElevatedButton(
                onPressed: () {
                  willLeave = true;
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              )
            ],
          )
      );
    }

    return Future.value(willLeave);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return await handleBackButton(context);
        },
        child: Scaffold(
          backgroundColor: Color(int.parse(dotenv.get('BACKGROUND_COLOR'))),
          body: SafeArea(
            bottom: false,
            child: WebView(
              initialUrl: dotenv.get('WEB_URL'),
              zoomEnabled: dotenv.get('ZOOM_ENABLED') == 'true',
              gestureNavigationEnabled: dotenv.get('GESTURE_NAVIGATION_ENABLED') == 'true',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (webviewController) => {
                controller.webViewController = webviewController
              },
            ),
          ),
        )
    );
  }
}
