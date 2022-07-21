# Flutter Webview Application

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## update dotenv

- copy .env with copy example file - `cp .env.example .env`
- and fill each variables. you could pass variables if don't use theme except **app configs**

## configure package name(identifier)

`flutter pub run change_app_package_name:main your.package.name`

## firebase configuration

1. initilize firebase
follow below cli command or check [firebase documentation](https://firebase.google.com/docs/flutter/setup)

```
firebase login
dart pub global activate flutterfire_cli
flutterfire configure
```

this will setup your firebase with generating below files

- lib/firebase_options.dart
- android/app/google-services.json
- ios/firebase_app_id_file.json

2. download and locate ios `GoogleService-Info.plist` files from firebase console

https://www.digitalocean.com/community/tutorials/flutter-firebase-setup#adding-the-firebase-sdk

## before deployment

### generate android key

- open folder `android` with android stuido and generate keystore follow [this documentation](https://developer.android.com/studio/publish/app-signing#sign-apk)
- paste each values to your local.propertis

### create app on each platform sites

- https://appstoreconnect.apple.com/
- https://play.google.com/console

### Android: config android project settings

- add your package name (com.package.name) to applicationId in local.properties file on android root. you could find package name from google play console 

```
# local.properties
applicationId=com.webview
```

### iOS: config xcode project settings

- follow flutter guidelines: https://docs.flutter.dev/deployment/ios#review-xcode-project-settings
- change App Tracking Transparency message if you want. https://developer.apple.com/documentation/apptrackingtransparency

### Android: generate app icon and copy to each platforms location (you can create on app icon generator sites like https://appicon.co/)

- ios/Runner/Assets.xcassets
- android/app/src/main/res/mipmap-*
  
### Update splash image

- copy your own splash jpg image to asset/ folder.

## deployment

You could use build scripts with rps scripts (check pubspec.yml) or follow each platform's environment

- iOS
  1. build ipa with `rps build ios`, and deploy with [Transporter](https://apps.apple.com/kr/app/transporter/id1450874784?l=en&mt=12) app
  2. archive app and upload with Xcode
- Android
  1. build appbundle and add bundle file to playstore console

Or you could deploy with [fastlane](https://fastlane.tools/)