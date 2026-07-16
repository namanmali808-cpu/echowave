class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.deezer.com';
  static const String itunesSearch = 'https://itunes.apple.com/search';

  static const String search = '/search';
  static const String chart = '/chart';

  static String searchQuery(String query) => '$search?q=$query';
  static String trackById(String id) => '/track/$id';
  static String albumById(String id) => '/album/$id';
  static String artistById(String id) => '/artist/$id';
  static String artistTop(String id) => '/artist/$id/top';

  static const String songs = '/songs';
  static const String albums = '/albums';
  static const String artists = '/artists';
  static const String playlists = '/playlists';
  static const String auth = '/auth';
  static const String stream = '/stream';
  static const String download = '/download';
  static const String update = '/update';
  static const String lyrics = '/lyrics';

  // Piped API (YouTube)
  static const String pipedBase = 'https://pipedapi.kavin.rocks';
  static const String pipedSearch = '/search';
  static const String pipedStreams = '/streams';

  static String songById(String id) => '$songs/$id';
  static String playlistById(String id) => '$playlists/$id';
  static String streamSong(String id) => '$stream/$id';
  static String downloadSong(String id) => '$download/$id';
  static String songLyrics(String id) => '$songs/$id$lyrics';
  static String login() => '$auth/login';
  static String register() => '$auth/register';
  static String forgotPassword() => '$auth/forgot-password';
  static String refreshToken() => '$auth/refresh';
  static String profile() => '$auth/profile';
}
