class AppConstants {
  AppConstants._();

  static const String appName = 'EchoWave';
  static const String packageName = 'com.echowave.app';
  static const String hiveBoxName = 'echowave_box';
  static const String notificationChannelId = 'echowave_music_channel';
  static const String notificationChannelName = 'Music Playback';
  static const String notificationChannelDescription =
      'Controls music playback';

  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration cacheDuration = Duration(days: 7);
  static const Duration httpTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);

  static const double minPasswordLength = 8;
  static const double maxPasswordLength = 64;
  static const double maxNameLength = 50;
  static const int maxLoginAttempts = 5;
  static const int recentSearchesLimit = 10;
  static const int recentlyPlayedLimit = 50;

  static const String githubOwner = 'namanmali808-cpu';
  static const String githubRepo = 'echowave';
}
