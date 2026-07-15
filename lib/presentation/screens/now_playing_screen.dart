import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:echowave/presentation/providers/player_provider.dart';
import 'package:echowave/presentation/widgets/seek_bar.dart';
import 'package:echowave/domain/entities/song.dart';
import 'package:echowave/presentation/providers/playlist_provider.dart';

class NowPlayingScreen extends ConsumerStatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  ConsumerState<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends ConsumerState<NowPlayingScreen> {
  bool _showLyrics = false;

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);
    final song = playerState.currentSong;
    final playlistState = ref.watch(playlistProvider);
    final isFav = song != null && playlistState.favoriteSongs.any((s) => s.id == song.id);

    if (song == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'No song playing',
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2d1b69),
              const Color(0xFF0D0D0D),
              const Color(0xFF0D0D0D),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(song),
              Expanded(
                child: _showLyrics
                    ? _buildLyricsSheet()
                    : _buildPlayerContent(song, playerState, isFav),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(Song song) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Now Playing',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.queue_music, color: Colors.white),
            onPressed: () => _showQueueSheet(context, song),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerContent(Song song, PlayerStateData playerState, bool isFav) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const Spacer(flex: 1),
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                _getGenreIcon(song.genre),
                size: 100,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
          const Spacer(flex: 1),
          Text(
            song.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            song.artist,
            style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SeekBar(
            position: playerState.position,
            duration: playerState.duration,
            onSeek: (position) {
              ref.read(playerProvider.notifier).seek(position);
            },
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shuffle,
                    color: playerState.isShuffled
                        ? const Color(0xFF6C63FF)
                        : Colors.white.withOpacity(0.6),
                  ),
                  onPressed: () => ref.read(playerProvider.notifier).toggleShuffle(),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 36),
                  onPressed: () => ref.read(playerProvider.notifier).previous(),
                ),
                GestureDetector(
                  onTap: () => ref.read(playerProvider.notifier).togglePlayPause(),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF6C63FF),
                    ),
                    child: Icon(
                      playerState.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 36),
                  onPressed: () => ref.read(playerProvider.notifier).next(),
                ),
                IconButton(
                  icon: Icon(
                    Icons.repeat,
                    color: playerState.loopMode != LoopModeState.off
                        ? const Color(0xFF6C63FF)
                        : Colors.white.withOpacity(0.6),
                  ),
                  onPressed: () => ref.read(playerProvider.notifier).toggleLoopMode(),
                ),
              ],
            ),
          ),
          const Spacer(flex: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _IconLabelButton(
                icon: Icons.speed,
                label: '${playerState.speed.toStringAsFixed(1)}x',
                color: Colors.white.withOpacity(0.6),
                onTap: () => _showSpeedSelector(),
              ),
              _IconLabelButton(
                icon: Icons.lyrics_outlined,
                label: 'Lyrics',
                color: _showLyrics ? const Color(0xFF6C63FF) : Colors.white.withOpacity(0.6),
                onTap: () => setState(() => _showLyrics = !_showLyrics),
              ),
              _IconLabelButton(
                icon: isFav ? Icons.favorite : Icons.favorite_border,
                label: isFav ? 'Liked' : 'Like',
                color: isFav ? const Color(0xFFFF6584) : Colors.white.withOpacity(0.6),
                onTap: () {
                  ref.read(playlistProvider.notifier).toggleFavorite(song);
                },
              ),
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  Widget _buildLyricsSheet() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Lyrics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No lyrics available for this song.\nLyrics will appear here when available.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.5),
                height: 1.8,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showQueueSheet(BuildContext context, Song currentSong) {
    final playerState = ref.read(playerProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Queue (${playerState.queue.length})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(playerProvider.notifier).clearQueue();
                          Navigator.pop(ctx);
                        },
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: Color(0xFF6C63FF)),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: playerState.queue.length,
                    separatorBuilder: (_, __) => const Divider(color: Colors.white10),
                    itemBuilder: (context, index) {
                      final qSong = playerState.queue[index];
                      final isCurrent = qSong.id == currentSong.id;
                      return ListTile(
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFF6C63FF).withOpacity(0.3),
                          ),
                          child: isCurrent
                              ? const Icon(Icons.music_note, color: Color(0xFF6C63FF))
                              : null,
                        ),
                        title: Text(
                          qSong.title,
                          style: TextStyle(
                            color: isCurrent ? const Color(0xFF6C63FF) : Colors.white,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          qSong.artist,
                          style: TextStyle(color: Colors.white.withOpacity(0.6)),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                          onPressed: () {
                            ref.read(playerProvider.notifier).removeFromQueue(index);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSpeedSelector() {
    final currentSpeed = ref.read(playerProvider).speed;
    final speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Playback Speed',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...speeds.map((speed) {
                final isSelected = speed == currentSpeed;
                return ListTile(
                  title: Text(
                    '${speed}x',
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF6C63FF) : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    ref.read(playerProvider.notifier).setSpeed(speed);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  IconData _getGenreIcon(String genre) {
    switch (genre.toLowerCase()) {
      case 'pop': return Icons.music_note;
      case 'rock': return Icons.music_note;
      case 'jazz': return Icons.music_note;
      case 'classical': return Icons.music_note;
      default: return Icons.music_note;
    }
  }
}

class _IconLabelButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _IconLabelButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }
}
