import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:echowave/domain/entities/song.dart';
import 'package:echowave/presentation/providers/player_provider.dart';
import 'package:echowave/presentation/providers/playlist_provider.dart';
import 'package:echowave/presentation/widgets/song_tile.dart';
import 'package:echowave/presentation/extensions/context_extensions.dart';

class PlaylistScreen extends ConsumerWidget {
  final String id;

  const PlaylistScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsState = ref.watch(playlistProvider);
    final playlist = playlistsState.playlists.where((p) => p.id == id).firstOrNull;

    final mockSongs = [
      Song(id: '1', title: 'Blinding Lights', artist: 'The Weeknd', artistId: 'a1', album: 'After Hours', albumId: 'al1', albumArtUrl: '', duration: 200, url: ''),
      Song(id: '2', title: 'Shape of You', artist: 'Ed Sheeran', artistId: 'a2', album: 'Divide', albumId: 'al2', albumArtUrl: '', duration: 233, url: ''),
      Song(id: '3', title: 'Bohemian Rhapsody', artist: 'Queen', artistId: 'a3', album: 'A Night at the Opera', albumId: 'al3', albumArtUrl: '', duration: 354, url: ''),
      Song(id: '4', title: 'Hotel California', artist: 'Eagles', artistId: 'a4', album: 'Hotel California', albumId: 'al4', albumArtUrl: '', duration: 391, url: ''),
      Song(id: '5', title: 'Billie Jean', artist: 'Michael Jackson', artistId: 'a5', album: 'Thriller', albumId: 'al5', albumArtUrl: '', duration: 294, url: ''),
    ];

    if (playlist == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Playlist not found',
            style: TextStyle(color: Colors.white.withOpacity(0.6)),
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF0D0D0D),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF2d1b69),
                      const Color(0xFF0D0D0D),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.playlist_play, size: 64, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        playlist.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${playlist.songCount} songs  •  ${playlist.createdBy}',
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
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      context.showSnackBar('Edit playlist');
                    case 'delete':
                      context.showSnackBar('Playlist deleted');
                      context.pop();
                    case 'share':
                      Share.share('Check out "${playlist.name}" on EchoWave!');
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit Playlist')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete Playlist')),
                  const PopupMenuItem(value: 'share', child: Text('Share')),
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      if (mockSongs.isNotEmpty) {
                        ref.read(playerProvider.notifier).playSong(mockSongs.first, queue: mockSongs);
                      }
                    },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Play'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      ref.read(playerProvider.notifier).playSong(mockSongs.first, queue: mockSongs);
                    },
                    icon: const Icon(Icons.shuffle, color: Color(0xFF6C63FF)),
                    label: const Text('Shuffle', style: TextStyle(color: Color(0xFF6C63FF))),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF6C63FF)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = mockSongs[index];
                return SongTile(
                  song: song,
                  onTap: () {
                    ref.read(playerProvider.notifier).playSong(song, queue: mockSongs);
                  },
                );
              },
              childCount: mockSongs.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
