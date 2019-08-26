import 'dart:io' show Directory, Platform;
import 'package:path/path.dart' as path_lib;

class Locator {
  static String getPlatformSpecificCachePath({bool userBased = true}) {
    String os = Platform.operatingSystem;
    switch (os) {
      case 'windows':
        return _verify(_findWindows(userBased));
      case 'linux':
        return _verify(_findLinux());
      case 'macos':
        return _verify(_findMacOS());
      case 'android':
      case 'ios':
        throw LocatorException(
            'App caches are not supported for mobile devices');
    }
    throw LocatorException(
        'Platform-specific cache path for platform "$os" was not found');
  }

  static String _verify(String path) {
    if (Directory(path).existsSync()) {
      return path;
    }
    throw LocatorException(
        'The standard cache path for this platform ("$path") does not exist on this system');
  }

  static String _findWindows(bool userBased) {
    if (userBased) {
      return path_lib.join(
          Platform.environment['UserProfile'], 'AppData', 'Roaming');
    } else {
      return 'C:\\ProgramData';
    }
  }

  static String _findMacOS() {
    return '~/Library/Application Support';
  }

  static String _findLinux() {
    return '/var/lib';
  }
}

class LocatorException implements Exception {
  final String message;

  const LocatorException(this.message);

  String toString() => 'LocatorException: $message';
}