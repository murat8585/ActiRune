import 'dart:io';

import 'package:flutter/services.dart';

class AppSettingsLauncher {
  const AppSettingsLauncher({
    this.channel = const MethodChannel('actirune/app_settings'),
  });

  final MethodChannel channel;

  Future<bool> openAppSettings() async {
    if (!Platform.isAndroid) return false;
    try {
      return await channel.invokeMethod<bool>('openAppSettings') ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
