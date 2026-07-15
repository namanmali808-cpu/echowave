import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:echowave/domain/entities/song.dart';
import 'package:echowave/domain/entities/album.dart';
import 'package:echowave/domain/entities/artist.dart';
import 'package:echowave/presentation/providers/player_provider.dart';
import 'package:echowave/presentation/widgets/album_card.dart';
import 'package:echowave/presentation/widgets/artist_card.dart';
import 'package:echowave/presentation/widgets/song_tile.dart';
import 'package:echowave/presentation/widgets/mini_player.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);

    final recentlyPlayed = [
      Song(id: 'r1', title: 'Blinding Lights', artist: 'The Weeknd', artistId: 'a1', album: 'After Hours', albumId: 'al1', albumArtUrl: '', duration: 200, url: ''),
      Song(id: 'r2', title: 'Shape of You', artist: 'Ed Sheeran', artistId: 'a2', album: 'Divide', albumId: 'al2', albumArtUrl: '', duration: 233, url: ''),
      Song(id: 'r3', title: 'Bohemian Rhapsody', artist: 'Queen', artistId: 'a3', album: 'A Night at the Opera', albumId: 'al3', albumArtUrl: '', duration: 354, url: ''),
      Song(id: 'r4', title: 'Hotel California', artist: 'Eagles', artistId: 'a4', album: 'Hotel California', albumId: 'al4', albumArtUrl: '', duration: 391, url: ''),
    ];

    final madeForYou = [
      Album(id: 'al1', title: 'Today\'s Top Hits', artist: 'Various', artistId: 'v1', coverUrl: '', songs: []),
      Album(id: 'al2', title: 'Chill Vibes', artist: 'Various', artistId: 'v2', coverUrl: '', songs: []),
      Album(id: 'al3', title: 'Workout Energy', artist: 'Various', artistId: 'v3', coverUrl: '', songs: []),
      Album(id: 'al4', title: 'Late Night Jazz', artist: 'Various', artistId: 'v4', coverUrl: '', songs: []),
    ];

    final popularArtists = [
      Artist(id: 'ar1', name: 'The Weeknd', imageUrl: ''),
      Artist(id: 'ar2', name: 'Ed Sheeran', imageUrl: ''),
      Artist(id: 'ar3', name: 'Queen', imageUrl: ''),
      Artist(id: 'ar4', name: 'Taylor Swift', imageUrl: ''),
      Artist(id: 'ar5', name: 'Dua Lipa', imageUrl: ''),
    ];

    final trendingNow = [
      Song(id: 't1', title: 'Flowers', artist: 'Miley Cyrus', artistId: 'm1', album: 'Endless Summer Vacation', albumId: 'es1', albumArtUrl: '', duration: 200, url: ''),
      Song(id: 't2', title: 'Kill Bill', artist: 'SZA', artistId: 's1', album: 'SOS', albumId: 'sos1', albumArtUrl: '', duration: 233, url: ''),
      Song(id: 't3', title: 'Creepin\'', artist: 'Metro Boomin', artistId: 'mb1', album: 'Heroes & Villains', albumId: 'hv1', albumArtUrl: '', duration: 221, url: ''),
      Song(id: 't4', title: 'Anti-Hero', artist: 'Taylor Swift', artistId: 'ts1', album: 'Midnights', albumId: 'md1', albumArtUrl: '', duration: 200, url: ''),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a0533),
              Color(0xFF0D0D0D),
              Color(0xFF0D0D0D),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _greeting(),
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Let\'s find something good',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => context.push('/profile'),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF6C63FF).withOpacity(0.3),
                                  border: Border.all(
                                    color: const Color(0xFF6C63FF).withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(Icons.person, color: Colors.white, size: 22),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _SectionHeader(title: 'Recently Played', onSeeAll: () {}),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: recentlyPlayed.length,
                          itemBuilder: (context, index) {
                            final song = recentlyPlayed[index];
                            return AlbumCard(
                              imageUrl: song.albumArtUrl,
                              title: song.title,
                              subtitle: song.artist,
                              onTap: () {
                                ref.read(playerProvider.notifier).playSong(song, queue: recentlyPlayed);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    _SectionHeader(title: 'Made for You', onSeeAll: () {}),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: madeForYou.length,
                          itemBuilder: (context, index) {
                            final album = madeForYou[index];
                            return AlbumCard(
                              imageUrl: album.coverUrl,
                              title: album.title,
                              subtitle: album.artist,
                              onTap: () => context.push('/album/${album.id}'),
                            );
                          },
                        ),
                      ),
                    ),
                    _SectionHeader(title: 'Popular Artists', onSeeAll: () {}),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: popularArtists.length,
                          itemBuilder: (context, index) {
                            final artist = popularArtists[index];
                            return ArtistCard(
                              imageUrl: artist.imageUrl,
                              name: artist.name,
                              onTap: () => context.push('/artist/${artist.id}'),
                            );
                          },
                        ),
                      ),
                    ),
                    _SectionHeader(title: 'Trending Now', onSeeAll: () {}),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final song = trendingNow[index];
                          return SongTile(
                            song: song,
                            onTap: () {
                              ref.read(playerProvider.notifier).playSong(song, queue: trendingNow);
                            },
                          );
                        },
                        childCount: trendingNow.length,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: playerState.currentSong != null ? 80 : 20),
                    ),
                  ],
                ),
              ),
              if (playerState.currentSong != null) const MiniPlayer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF6C63FF).withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
