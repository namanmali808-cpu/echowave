import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:echowave/data/datasources/remote_datasource.dart';
import 'package:echowave/presentation/providers/player_provider.dart';
import 'package:echowave/presentation/widgets/song_tile.dart';
import 'package:echowave/presentation/widgets/album_card.dart';

class ArtistDetailScreen extends ConsumerWidget {
  final String artistId;

  const ArtistDetailScreen({super.key, required this.artistId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artist = RemoteDataSource.demoArtists.firstWhere(
      (a) => a.id == artistId,
      orElse: () => RemoteDataSource.demoArtists[0],
    );
    final topSongs = artist.topSongs;
    final albums = artist.albums;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a0533), Color(0xFF0D0D0D), Color(0xFF0D0D0D)],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C63FF).withOpacity(0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: CachedNetworkImage(
                            imageUrl: artist.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(color: const Color(0xFF6C63FF).withOpacity(0.2)),
                            errorWidget: (_, __, ___) => Icon(Icons.person, size: 80, color: Colors.white.withOpacity(0.3)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        artist.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${artist.monthlyListeners ~/ 1000000}M monthly listeners',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    'Popular',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final song = topSongs[index];
                    return SongTile(
                      song: song,
                      onTap: () {
                        ref.read(playerProvider.notifier).playSong(song, queue: topSongs);
                      },
                    );
                  },
                  childCount: topSongs.length,
                ),
              ),
              if (albums.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Text(
                      'Albums',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              if (albums.isNotEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: albums.length,
                      itemBuilder: (context, index) {
                        final album = albums[index];
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
              SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
