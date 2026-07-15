import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:echowave/domain/entities/song.dart';
import 'package:echowave/domain/entities/album.dart';
import 'package:echowave/domain/entities/artist.dart';
import 'package:echowave/data/datasources/remote_datasource.dart';
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

    final demo = RemoteDataSource.demoSongs.map((m) => m.toEntity()).toList();
    final recentlyPlayed = demo;
    final trendingNow = demo.reversed.toList();

    final madeForYou = [
      Album(id: 'al1', title: 'Today\'s Top Hits', artist: 'Various', artistId: 'v1', coverUrl: 'https://picsum.photos/seed/top-hits/200/200', songs: const []),
      Album(id: 'al2', title: 'Chill Vibes', artist: 'Various', artistId: 'v2', coverUrl: 'https://picsum.photos/seed/chill/200/200', songs: const []),
      Album(id: 'al3', title: 'Workout Energy', artist: 'Various', artistId: 'v3', coverUrl: 'https://picsum.photos/seed/workout/200/200', songs: const []),
      Album(id: 'al4', title: 'Late Night Jazz', artist: 'Various', artistId: 'v4', coverUrl: 'https://picsum.photos/seed/jazz/200/200', songs: const []),
    ];

    final popularArtists = [
      Artist(id: 'ar1', name: 'The Weeknd', imageUrl: 'https://picsum.photos/seed/weeknd/200/200'),
      Artist(id: 'ar2', name: 'Ed Sheeran', imageUrl: 'https://picsum.photos/seed/edsheeran/200/200'),
      Artist(id: 'ar3', name: 'Queen', imageUrl: 'https://picsum.photos/seed/queen/200/200'),
      Artist(id: 'ar4', name: 'Taylor Swift', imageUrl: 'https://picsum.photos/seed/taylor/200/200'),
      Artist(id: 'ar5', name: 'Dua Lipa', imageUrl: 'https://picsum.photos/seed/dualipa/200/200'),
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
