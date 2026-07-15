import 'package:dio/dio.dart';
import 'package:echowave/core/constants/api_constants.dart';
import 'package:echowave/core/errors/app_exception.dart';
import 'package:echowave/core/network/api_client.dart';
import 'package:echowave/data/models/album_model.dart';
import 'package:echowave/data/models/artist_model.dart';
import 'package:echowave/data/models/playlist_model.dart';
import 'package:echowave/data/models/song_model.dart';
import 'package:echowave/data/models/user_model.dart';

class RemoteDataSource {
  final ApiClient _apiClient;

  RemoteDataSource(this._apiClient);

  static final Dio _deezerDio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static final Dio _iTunesDio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.itunesSearch,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static final List<SongModel> demoSongs = [
    SongModel(
      id: 'demo_1',
      title: 'Blinding Lights',
      artist: 'The Weeknd',
      artistId: 'a1',
      album: 'After Hours',
      albumId: 'al1',
      albumArtUrl:
          'https://picsum.photos/seed/blinding-lights/200/200',
      duration: 200,
      url: 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/be/62/31/be62310b-f424-d94f-7070-5c342c22e001/mzaf_3947526926745603918.plus.aac.p.m4a',
      genre: 'Pop',
    ),
    SongModel(
      id: 'demo_2',
      title: 'Shape of You',
      artist: 'Ed Sheeran',
      artistId: 'a2',
      album: 'Divide',
      albumId: 'al2',
      albumArtUrl:
          'https://picsum.photos/seed/shape-of-you/200/200',
      duration: 233,
      url: 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/de/0b/bc/de0bbcaa-1eef-7a64-a526-8ce524135a58/mzaf_4433015177243361913.plus.aac.p.m4a',
      genre: 'Pop',
    ),
    SongModel(
      id: 'demo_3',
      title: 'Bohemian Rhapsody',
      artist: 'Queen',
      artistId: 'a3',
      album: 'A Night at the Opera',
      albumId: 'al3',
      albumArtUrl:
          'https://picsum.photos/seed/bohemian-rhapsody/200/200',
      duration: 354,
      url: 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/3f/ed/cb/3fedcb4b-6ac0-0f88-dda8-d41a96c6f600/mzaf_1039144130883047614.plus.aac.p.m4a',
      genre: 'Rock',
    ),
    SongModel(
      id: 'demo_4',
      title: 'Hotel California',
      artist: 'Eagles',
      artistId: 'a4',
      album: 'Hotel California',
      albumId: 'al4',
      albumArtUrl:
          'https://picsum.photos/seed/hotel-california/200/200',
      duration: 391,
      url: 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/72/79/13/727913e5-6cf7-650f-299d-51cde99b1c07/mzaf_16842664206356071168.plus.aac.p.m4a',
      genre: 'Rock',
    ),
    SongModel(
      id: 'demo_5',
      title: 'Billie Jean',
      artist: 'Michael Jackson',
      artistId: 'a5',
      album: 'Thriller',
      albumId: 'al5',
      albumArtUrl:
          'https://picsum.photos/seed/billie-jean/200/200',
      duration: 294,
      url: 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/36/78/fe/3678fe63-b187-48e5-4940-879b8a7e5e8a/mzaf_17914568650308437410.plus.aac.p.m4a',
      genre: 'Pop',
    ),
    SongModel(
      id: 'demo_6',
      title: 'Stairway to Heaven',
      artist: 'Led Zeppelin',
      artistId: 'a6',
      album: 'Led Zeppelin IV',
      albumId: 'al6',
      albumArtUrl:
          'https://picsum.photos/seed/stairway-to-heaven/200/200',
      duration: 482,
      url: 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/71/3e/93/713e93b8-b637-7933-3f0c-cbde735648f4/mzaf_6266506310481719163.plus.aac.p.m4a',
      genre: 'Rock',
    ),
    SongModel(
      id: 'demo_7',
      title: 'Smells Like Teen Spirit',
      artist: 'Nirvana',
      artistId: 'a7',
      album: 'Nevermind',
      albumId: 'al7',
      albumArtUrl:
          'https://picsum.photos/seed/smells-like-teen-spirit/200/200',
      duration: 301,
      url: 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/14/e9/e4/14e9e474-a4e6-b6c0-9f72-20a91e58f7df/mzaf_4351844841409463338.plus.aac.p.m4a',
      genre: 'Rock',
    ),
    SongModel(
      id: 'demo_8',
      title: 'Dancing Queen',
      artist: 'ABBA',
      artistId: 'a8',
      album: 'Arrival',
      albumId: 'al8',
      albumArtUrl:
          'https://picsum.photos/seed/dancing-queen/200/200',
      duration: 231,
      url: 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/b9/78/57/b978570d-0398-4268-57ff-30b393c02de8/mzaf_16287802414900148983.plus.aac.p.m4a',
      genre: 'Pop',
    ),
    SongModel(
      id: 'demo_9',
      title: 'Sweet Child O Mine',
      artist: 'Guns N Roses',
      artistId: 'a9',
      album: 'Appetite for Destruction',
      albumId: 'al9',
      albumArtUrl:
          'https://picsum.photos/seed/sweet-child-o-mine/200/200',
      duration: 356,
      url: 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/be/3c/78/be3c7869-83ac-4d50-3710-78b229cd5208/mzaf_9315875699620155609.plus.aac.p.m4a',
      genre: 'Rock',
    ),
    SongModel(
      id: 'demo_10',
      title: 'Imagine',
      artist: 'John Lennon',
      artistId: 'a10',
      album: 'Imagine',
      albumId: 'al10',
      albumArtUrl:
          'https://picsum.photos/seed/imagine/200/200',
      duration: 187,
      url: 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/0d/3a/ff/0d3aff0f-a66f-46f2-6415-d174a619daae/mzaf_12507925438133098017.plus.aac.p.m4a',
      genre: 'Pop',
    ),
  ];

  static final List<AlbumModel> demoAlbums = [
    AlbumModel(
      id: 'al1',
      title: 'After Hours',
      artist: 'The Weeknd',
      artistId: 'a1',
      coverUrl:
          'https://picsum.photos/seed/after-hours/200/200',
      year: 2020,
      songCount: 1,
      totalDuration: 200,
      genre: ['Pop', 'R&B'],
      songs: [demoSongs[0]],
    ),
    AlbumModel(
      id: 'al2',
      title: 'Divide',
      artist: 'Ed Sheeran',
      artistId: 'a2',
      coverUrl:
          'https://picsum.photos/seed/divide/200/200',
      year: 2017,
      songCount: 1,
      totalDuration: 233,
      genre: ['Pop'],
      songs: [demoSongs[1]],
    ),
    AlbumModel(
      id: 'al3',
      title: 'A Night at the Opera',
      artist: 'Queen',
      artistId: 'a3',
      coverUrl:
          'https://picsum.photos/seed/a-night-at-the-opera/200/200',
      year: 1975,
      songCount: 1,
      totalDuration: 354,
      genre: ['Rock'],
      songs: [demoSongs[2]],
    ),
    AlbumModel(
      id: 'al4',
      title: 'Hotel California',
      artist: 'Eagles',
      artistId: 'a4',
      coverUrl:
          'https://picsum.photos/seed/hotel-california/200/200',
      year: 1976,
      songCount: 1,
      totalDuration: 391,
      genre: ['Rock'],
      songs: [demoSongs[3]],
    ),
    AlbumModel(
      id: 'al5',
      title: 'Thriller',
      artist: 'Michael Jackson',
      artistId: 'a5',
      coverUrl:
          'https://picsum.photos/seed/thriller/200/200',
      year: 1982,
      songCount: 1,
      totalDuration: 294,
      genre: ['Pop'],
      songs: [demoSongs[4]],
    ),
    AlbumModel(
      id: 'al6',
      title: 'Led Zeppelin IV',
      artist: 'Led Zeppelin',
      artistId: 'a6',
      coverUrl:
          'https://picsum.photos/seed/led-zeppelin-iv/200/200',
      year: 1971,
      songCount: 1,
      totalDuration: 482,
      genre: ['Rock'],
      songs: [demoSongs[5]],
    ),
    AlbumModel(
      id: 'al7',
      title: 'Nevermind',
      artist: 'Nirvana',
      artistId: 'a7',
      coverUrl:
          'https://picsum.photos/seed/nevermind/200/200',
      year: 1991,
      songCount: 1,
      totalDuration: 301,
      genre: ['Rock', 'Grunge'],
      songs: [demoSongs[6]],
    ),
    AlbumModel(
      id: 'al8',
      title: 'Arrival',
      artist: 'ABBA',
      artistId: 'a8',
      coverUrl:
          'https://picsum.photos/seed/arrival/200/200',
      year: 1976,
      songCount: 1,
      totalDuration: 231,
      genre: ['Pop'],
      songs: [demoSongs[7]],
    ),
    AlbumModel(
      id: 'al9',
      title: 'Appetite for Destruction',
      artist: 'Guns N Roses',
      artistId: 'a9',
      coverUrl:
          'https://picsum.photos/seed/appetite-for-destruction/200/200',
      year: 1987,
      songCount: 1,
      totalDuration: 356,
      genre: ['Rock'],
      songs: [demoSongs[8]],
    ),
    AlbumModel(
      id: 'al10',
      title: 'Imagine',
      artist: 'John Lennon',
      artistId: 'a10',
      coverUrl:
          'https://picsum.photos/seed/imagine/200/200',
      year: 1971,
      songCount: 1,
      totalDuration: 187,
      genre: ['Pop'],
      songs: [demoSongs[9]],
    ),
  ];

  static final List<ArtistModel> demoArtists = [
    ArtistModel(
      id: 'a1',
      name: 'The Weeknd',
      imageUrl:
          'https://picsum.photos/seed/the-weeknd/200/200',
      bio: 'Canadian singer and songwriter known for his eclectic musical style.',
      monthlyListeners: 80000000,
      songCount: 1,
      albumCount: 1,
      topSongs: [demoSongs[0]],
      albums: [demoAlbums[0]],
    ),
    ArtistModel(
      id: 'a2',
      name: 'Ed Sheeran',
      imageUrl:
          'https://picsum.photos/seed/ed-sheeran/200/200',
      bio: 'English singer-songwriter known for acoustic pop music.',
      monthlyListeners: 70000000,
      songCount: 1,
      albumCount: 1,
      topSongs: [demoSongs[1]],
      albums: [demoAlbums[1]],
    ),
    ArtistModel(
      id: 'a3',
      name: 'Queen',
      imageUrl:
          'https://picsum.photos/seed/queen/200/200',
      bio: 'Iconic British rock band formed in 1970.',
      monthlyListeners: 50000000,
      songCount: 1,
      albumCount: 1,
      topSongs: [demoSongs[2]],
      albums: [demoAlbums[2]],
    ),
    ArtistModel(
      id: 'a4',
      name: 'Eagles',
      imageUrl:
          'https://picsum.photos/seed/eagles/200/200',
      bio: 'American rock band known for their harmonies and classic sound.',
      monthlyListeners: 40000000,
      songCount: 1,
      albumCount: 1,
      topSongs: [demoSongs[3]],
      albums: [demoAlbums[3]],
    ),
    ArtistModel(
      id: 'a5',
      name: 'Michael Jackson',
      imageUrl:
          'https://picsum.photos/seed/michael-jackson/200/200',
      bio: 'The King of Pop, one of the most influential entertainers of all time.',
      monthlyListeners: 60000000,
      songCount: 1,
      albumCount: 1,
      topSongs: [demoSongs[4]],
      albums: [demoAlbums[4]],
    ),
    ArtistModel(
      id: 'a6',
      name: 'Led Zeppelin',
      imageUrl:
          'https://picsum.photos/seed/led-zeppelin/200/200',
      bio: 'English rock band formed in London in 1968.',
      monthlyListeners: 35000000,
      songCount: 1,
      albumCount: 1,
      topSongs: [demoSongs[5]],
      albums: [demoAlbums[5]],
    ),
    ArtistModel(
      id: 'a7',
      name: 'Nirvana',
      imageUrl:
          'https://picsum.photos/seed/nirvana/200/200',
      bio: 'American rock band formed in Aberdeen, Washington, in 1987.',
      monthlyListeners: 45000000,
      songCount: 1,
      albumCount: 1,
      topSongs: [demoSongs[6]],
      albums: [demoAlbums[6]],
    ),
    ArtistModel(
      id: 'a8',
      name: 'ABBA',
      imageUrl:
          'https://picsum.photos/seed/abba/200/200',
      bio: 'Swedish pop supergroup formed in Stockholm in 1972.',
      monthlyListeners: 30000000,
      songCount: 1,
      albumCount: 1,
      topSongs: [demoSongs[7]],
      albums: [demoAlbums[7]],
    ),
    ArtistModel(
      id: 'a9',
      name: 'Guns N Roses',
      imageUrl:
          'https://picsum.photos/seed/guns-n-roses/200/200',
      bio: 'American hard rock band formed in Los Angeles in 1985.',
      monthlyListeners: 25000000,
      songCount: 1,
      albumCount: 1,
      topSongs: [demoSongs[8]],
      albums: [demoAlbums[8]],
    ),
    ArtistModel(
      id: 'a10',
      name: 'John Lennon',
      imageUrl:
          'https://picsum.photos/seed/john-lennon/200/200',
      bio: 'English singer, songwriter and peace activist, co-founder of the Beatles.',
      monthlyListeners: 20000000,
      songCount: 1,
      albumCount: 1,
      topSongs: [demoSongs[9]],
      albums: [demoAlbums[9]],
    ),
  ];

  static final List<PlaylistModel> demoPlaylists = [
    PlaylistModel(
      id: 'pl_1',
      name: "Today's Hits",
      description: 'The biggest songs right now.',
      coverUrl: demoSongs[0].albumArtUrl,
      createdBy: 'EchoWave',
      songCount: 4,
      totalDuration: 958,
      isPublic: true,
      isLikedSongs: false,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 6, 1),
      songs: [demoSongs[0], demoSongs[1], demoSongs[4], demoSongs[7]],
    ),
    PlaylistModel(
      id: 'pl_2',
      name: 'Rock Classics',
      description: 'Legendary rock anthems.',
      coverUrl: demoSongs[2].albumArtUrl,
      createdBy: 'EchoWave',
      songCount: 5,
      totalDuration: 1884,
      isPublic: true,
      isLikedSongs: false,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 6, 1),
      songs: [
        demoSongs[2],
        demoSongs[3],
        demoSongs[5],
        demoSongs[6],
        demoSongs[8],
      ],
    ),
    PlaylistModel(
      id: 'pl_3',
      name: 'Chill Vibes',
      description: 'Relax and unwind.',
      coverUrl: demoSongs[9].albumArtUrl,
      createdBy: 'EchoWave',
      songCount: 3,
      totalDuration: 620,
      isPublic: true,
      isLikedSongs: false,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 6, 1),
      songs: [demoSongs[0], demoSongs[9], demoSongs[7]],
    ),
    PlaylistModel(
      id: 'pl_4',
      name: 'All Songs',
      description: 'Every song available on EchoWave.',
      coverUrl: demoSongs[0].albumArtUrl,
      createdBy: 'EchoWave',
      songCount: 10,
      totalDuration: 3029,
      isPublic: true,
      isLikedSongs: false,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 6, 1),
      songs: List.from(demoSongs),
    ),
  ];

  SongModel? _findDemoSong(String id) {
    try {
      return demoSongs.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  AlbumModel? _findDemoAlbum(String id) {
    try {
      return demoAlbums.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  ArtistModel? _findDemoArtist(String id) {
    try {
      return demoArtists.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  PlaylistModel? _findDemoPlaylist(String id) {
    try {
      return demoPlaylists.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  SongModel _deezerTrackToSong(Map<String, dynamic> track) {
    final artist = track['artist'] is Map
        ? track['artist'] as Map<String, dynamic>
        : <String, dynamic>{};
    final album = track['album'] is Map
        ? track['album'] as Map<String, dynamic>
        : <String, dynamic>{};
    return SongModel(
      id: 'deezer_${track['id']}',
      title: track['title'] as String? ?? '',
      artist: artist['name'] as String? ?? '',
      artistId: artist['id']?.toString() ?? '',
      album: album['title'] as String? ?? '',
      albumId: album['id']?.toString() ?? '',
      albumArtUrl: album['cover_xl'] as String? ??
          album['cover_big'] as String? ??
          album['cover_medium'] as String? ??
          album['cover'] as String? ??
          '',
      duration: track['duration'] as int? ?? 0,
      url: track['preview'] as String? ?? '',
      genre: '',
    );
  }

  AlbumModel _deezerAlbumToAlbum(Map<String, dynamic> album) {
    final artist = album['artist'] is Map
        ? album['artist'] as Map<String, dynamic>
        : <String, dynamic>{};
    final tracksList = <SongModel>[];
    if (album['tracks'] is Map && album['tracks']['data'] is List) {
      for (final t in album['tracks']['data'] as List) {
        if (t is Map<String, dynamic>) {
          tracksList.add(_deezerTrackToSong(t));
        }
      }
    }
    return AlbumModel(
      id: 'deezer_album_${album['id']}',
      title: album['title'] as String? ?? '',
      artist: artist['name'] as String? ?? '',
      artistId: artist['id']?.toString() ?? '',
      coverUrl: album['cover_xl'] as String? ??
          album['cover_big'] as String? ??
          album['cover_medium'] as String? ??
          album['cover'] as String? ??
          '',
      year: album['release_date'] is String
          ? int.tryParse((album['release_date'] as String).substring(0, 4)) ?? 0
          : 0,
      songCount: album['nb_tracks'] as int? ?? tracksList.length,
      totalDuration: 0,
      genre: <String>[],
      songs: tracksList,
    );
  }

  ArtistModel _deezerArtistToArtist(Map<String, dynamic> artist) {
    return ArtistModel(
      id: 'deezer_artist_${artist['id']}',
      name: artist['name'] as String? ?? '',
      imageUrl: artist['picture_medium'] as String? ?? '',
    );
  }

  Future<List<SongModel>> getSongs({int page = 1, int limit = 20}) async {
    try {
      final response = await _deezerDio.get('/chart/0');
      final data = response.data;
      if (data is Map && data['tracks'] is Map) {
        final tracks = data['tracks'] as Map<String, dynamic>;
        if (tracks['data'] is List) {
          final all = (tracks['data'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => _deezerTrackToSong(e))
              .toList();
          final start = (page - 1) * limit;
          final end = start + limit;
          if (start >= all.length) return [];
          return all.sublist(start, end > all.length ? all.length : end);
        }
      }
      return [];
    } catch (_) {
      final start = (page - 1) * limit;
      final end = start + limit;
      if (start >= demoSongs.length) return [];
      return demoSongs.sublist(
        start,
        end > demoSongs.length ? demoSongs.length : end,
      );
    }
  }

  Future<List<SongModel>> getTrendingSongs({int limit = 10}) async {
    try {
      final response = await _deezerDio.get('/chart/0');
      final data = response.data;
      if (data is Map && data['tracks'] is Map) {
        final tracks = data['tracks'] as Map<String, dynamic>;
        if (tracks['data'] is List) {
          return (tracks['data'] as List)
              .whereType<Map<String, dynamic>>()
              .take(limit)
              .map((e) => _deezerTrackToSong(e))
              .toList();
        }
      }
      return [];
    } catch (_) {
      return demoSongs.take(limit).toList();
    }
  }

  Future<List<AlbumModel>> getNewReleases({int limit = 10}) async {
    try {
      final response = await _deezerDio.get('/chart/0');
      final data = response.data;
      if (data is Map && data['albums'] is Map) {
        final albums = data['albums'] as Map<String, dynamic>;
        if (albums['data'] is List) {
          return (albums['data'] as List)
              .whereType<Map<String, dynamic>>()
              .take(limit)
              .map((e) => _deezerAlbumToAlbum(e))
              .toList();
        }
      }
      return [];
    } catch (_) {
      return demoAlbums.take(limit).toList();
    }
  }

  Future<List<PlaylistModel>> getFeaturedPlaylists({int limit = 10}) async {
    try {
      final response = await _deezerDio.get('/chart/0');
      final data = response.data;
      if (data is Map && data['playlists'] is Map) {
        final playlists = data['playlists'] as Map<String, dynamic>;
        if (playlists['data'] is List) {
          return (playlists['data'] as List)
              .whereType<Map<String, dynamic>>()
              .take(limit)
              .map((p) => PlaylistModel(
                    id: 'deezer_pl_${p['id']}',
                    name: p['title'] as String? ?? '',
                    description: '',
                    coverUrl: p['picture_medium'] as String? ?? '',
                    createdBy: 'Deezer',
                    songCount: p['nb_tracks'] as int? ?? 0,
                    totalDuration: 0,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ))
              .toList();
        }
      }
      return [];
    } catch (_) {
      return demoPlaylists.take(limit).toList();
    }
  }

  Future<List<SongModel>> searchSongs(String query,
      {int page = 1, int limit = 20}) async {
    try {
      final response = await _deezerDio.get(
        '/search',
        queryParameters: {'q': query, 'limit': limit, 'index': (page - 1) * limit},
      );
      final data = response.data;
      if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => _deezerTrackToSong(e))
            .toList();
      }
      return [];
    } catch (_) {
      try {
        final itunesResponse = await _iTunesDio.get('', queryParameters: {
          'term': query,
          'media': 'music',
          'limit': limit,
        });
        final itunesData = itunesResponse.data;
        if (itunesData is Map && itunesData['results'] is List) {
          return (itunesData['results'] as List)
              .whereType<Map<String, dynamic>>()
              .map((track) => SongModel(
                    id: 'itunes_${track['trackId']}',
                    title: track['trackName'] ?? '',
                    artist: track['artistName'] ?? '',
                    artistId: 'itunes_artist_${track['artistId'] ?? track['trackId']}',
                    album: track['collectionName'] ?? '',
                    albumId: 'itunes_album_${track['collectionId'] ?? track['trackId']}',
                    albumArtUrl: (track['artworkUrl100'] as String?)
                            ?.replaceAll('100x100bb', '300x300bb') ??
                        '',
                    duration: ((track['trackTimeMillis'] as int?) ?? 0) ~/ 1000,
                    url: track['previewUrl'] ?? '',
                    genre: track['primaryGenreName'] as String? ?? '',
                  ))
              .toList();
        }
        return [];
      } catch (_) {
        final lowerQuery = query.toLowerCase();
        return demoSongs
            .where((s) =>
                s.title.toLowerCase().contains(lowerQuery) ||
                s.artist.toLowerCase().contains(lowerQuery))
            .toList();
      }
    }
  }

  Future<SongModel> getSongDetail(String id) async {
    final cleanId = id.startsWith('deezer_') ? id.replaceFirst('deezer_', '') : id;
    try {
      final response = await _deezerDio.get('/track/$cleanId');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return _deezerTrackToSong(data);
      }
      return _findDemoSong(id) ?? demoSongs[0];
    } catch (_) {
      return _findDemoSong(id) ?? demoSongs[0];
    }
  }

  Future<List<AlbumModel>> getAlbums({int page = 1, int limit = 20}) async {
    try {
      final response = await _deezerDio.get('/chart/0');
      final data = response.data;
      if (data is Map && data['albums'] is Map) {
        final albums = data['albums'] as Map<String, dynamic>;
        if (albums['data'] is List) {
          final all = (albums['data'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => _deezerAlbumToAlbum(e))
              .toList();
          final start = (page - 1) * limit;
          final end = start + limit;
          if (start >= all.length) return [];
          return all.sublist(start, end > all.length ? all.length : end);
        }
      }
      return [];
    } catch (_) {
      final start = (page - 1) * limit;
      final end = start + limit;
      if (start >= demoAlbums.length) return [];
      return demoAlbums.sublist(
        start,
        end > demoAlbums.length ? demoAlbums.length : end,
      );
    }
  }

  Future<AlbumModel> getAlbumDetail(String id) async {
    final cleanId = id.startsWith('deezer_album_') ? id.replaceFirst('deezer_album_', '') : id;
    try {
      final response = await _deezerDio.get('/album/$cleanId');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return _deezerAlbumToAlbum(data);
      }
      return _findDemoAlbum(id) ?? demoAlbums[0];
    } catch (_) {
      return _findDemoAlbum(id) ?? demoAlbums[0];
    }
  }

  Future<List<ArtistModel>> getArtists({int page = 1, int limit = 20}) async {
    try {
      final response = await _deezerDio.get('/chart/0');
      final data = response.data;
      if (data is Map && data['artists'] is Map) {
        final artists = data['artists'] as Map<String, dynamic>;
        if (artists['data'] is List) {
          final all = (artists['data'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => _deezerArtistToArtist(e))
              .toList();
          final start = (page - 1) * limit;
          final end = start + limit;
          if (start >= all.length) return [];
          return all.sublist(start, end > all.length ? all.length : end);
        }
      }
      return [];
    } catch (_) {
      final start = (page - 1) * limit;
      final end = start + limit;
      if (start >= demoArtists.length) return [];
      return demoArtists.sublist(
        start,
        end > demoArtists.length ? demoArtists.length : end,
      );
    }
  }

  Future<ArtistModel> getArtistDetail(String id) async {
    final cleanId = id.startsWith('deezer_artist_') ? id.replaceFirst('deezer_artist_', '') : id;
    try {
      final response = await _deezerDio.get('/artist/$cleanId');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return _deezerArtistToArtist(data);
      }
      return _findDemoArtist(id) ?? demoArtists[0];
    } catch (_) {
      return _findDemoArtist(id) ?? demoArtists[0];
    }
  }

  Future<List<SongModel>> getArtistTopSongs(String id, {int limit = 10}) async {
    final cleanId = id.startsWith('deezer_artist_') ? id.replaceFirst('deezer_artist_', '') : id;
    try {
      final response = await _deezerDio.get('/artist/$cleanId/top');
      final data = response.data;
      if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .whereType<Map<String, dynamic>>()
            .take(limit)
            .map((e) => _deezerTrackToSong(e))
            .toList();
      }
      return [];
    } catch (_) {
      final demo = _findDemoArtist(id);
      if (demo != null) return demo.topSongs.cast<SongModel>();
      return demoSongs.take(limit).toList();
    }
  }

  Future<List<PlaylistModel>> getPlaylists(
      {int page = 1, int limit = 20}) async {
    try {
      final response = await _deezerDio.get('/chart/0');
      final data = response.data;
      if (data is Map && data['playlists'] is Map) {
        final playlists = data['playlists'] as Map<String, dynamic>;
        if (playlists['data'] is List) {
          final all = (playlists['data'] as List)
              .whereType<Map<String, dynamic>>()
              .map((p) => PlaylistModel(
                    id: 'deezer_pl_${p['id']}',
                    name: p['title'] as String? ?? '',
                    description: p['description'] as String? ?? '',
                    coverUrl: p['picture_medium'] as String? ?? '',
                    createdBy: 'Deezer',
                    songCount: p['nb_tracks'] as int? ?? 0,
                    totalDuration: 0,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ))
              .toList();
          final start = (page - 1) * limit;
          final end = start + limit;
          if (start >= all.length) return [];
          return all.sublist(start, end > all.length ? all.length : end);
        }
      }
      return [];
    } catch (_) {
      final start = (page - 1) * limit;
      final end = start + limit;
      if (start >= demoPlaylists.length) return [];
      return demoPlaylists.sublist(
        start,
        end > demoPlaylists.length ? demoPlaylists.length : end,
      );
    }
  }

  Future<PlaylistModel> getPlaylistDetail(String id) async {
    final demo = _findDemoPlaylist(id);
    if (demo != null) return demo;
    return demoPlaylists[0];
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login(),
        data: {'email': email, 'password': password},
      );
      final data = response.data;
      if (data is Map && data['data'] is Map) {
        return UserModel.fromJson(data['data'] as Map<String, dynamic>);
      }
      return UserModel.fromJson(data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (e, stackTrace) {
      throw ServerException(
        message: 'Login failed',
        stackTrace: stackTrace,
      );
    }
  }

  Future<UserModel> register(
      String name, String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.register(),
        data: {'name': name, 'email': email, 'password': password},
      );
      final data = response.data;
      if (data is Map && data['data'] is Map) {
        return UserModel.fromJson(data['data'] as Map<String, dynamic>);
      }
      return UserModel.fromJson(data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (e, stackTrace) {
      throw ServerException(
        message: 'Registration failed',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _apiClient.post(
        ApiConstants.forgotPassword(),
        data: {'email': email},
      );
    } on AppException {
      rethrow;
    } catch (e, stackTrace) {
      throw ServerException(
        message: 'Failed to send reset email',
        stackTrace: stackTrace,
      );
    }
  }

  Future<Map<String, dynamic>> checkUpdate() async {
    try {
      final response = await _apiClient.get(ApiConstants.update);
      return response.data as Map<String, dynamic>;
    } on AppException {
      rethrow;
    } catch (e, stackTrace) {
      throw ServerException(
        message: 'Failed to check for updates',
        stackTrace: stackTrace,
      );
    }
  }

  Future<String> getStreamUrl(
      String songId, {String quality = 'high'}) async {
    final cleanId = songId.startsWith('deezer_') ? songId.replaceFirst('deezer_', '') : songId;
    try {
      final response = await _deezerDio.get('/track/$cleanId');
      final data = response.data;
      if (data is Map && data['preview'] is String) {
        return data['preview'] as String;
      }
      return '';
    } catch (_) {
      final demo = _findDemoSong(songId);
      if (demo != null && demo.url.isNotEmpty) return demo.url;
      return '';
    }
  }

  Future<String> getDownloadUrl(String songId) async {
    final demo = _findDemoSong(songId);
    if (demo != null && demo.url.isNotEmpty) return demo.url;
    return '';
  }

  Future<String> getLyrics(String songId) async {
    try {
      final response = await _apiClient.get(ApiConstants.songLyrics(songId));
      final data = response.data;
      if (data is Map && data['lyrics'] is String) {
        return data['lyrics'] as String;
      }
      if (data is Map && data['data'] is Map) {
        final inner = data['data'] as Map<String, dynamic>;
        return inner['lyrics'] as String? ?? '';
      }
      return '';
    } catch (_) {
      return '';
    }
  }
}
