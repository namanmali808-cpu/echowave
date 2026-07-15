import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:echowave/domain/entities/song.dart';
import 'package:echowave/presentation/providers/player_provider.dart';
import 'package:echowave/presentation/widgets/song_tile.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  List<Song> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _history = [
        Song(id: '1', title: 'Blinding Lights', artist: 'The Weeknd', artistId: 'a1', album: 'After Hours', albumId: 'al1', albumArtUrl: '', duration: 200, url: ''),
        Song(id: '3', title: 'Bohemian Rhapsody', artist: 'Queen', artistId: 'a3', album: 'A Night at the Opera', albumId: 'al3', albumArtUrl: '', duration: 354, url: ''),
        Song(id: '2', title: 'Shape of You', artist: 'Ed Sheeran', artistId: 'a2', album: 'Divide', albumId: 'al2', albumArtUrl: '', duration: 233, url: ''),
        Song(id: '4', title: 'Hotel California', artist: 'Eagles', artistId: 'a4', album: 'Hotel California', albumId: 'al4', albumArtUrl: '', duration: 391, url: ''),
      ];
    });
  }

  void _clearHistory() {
    setState(() => _history.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a0533),
              Color(0xFF0D0D0D),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Recently Played',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    if (_history.isNotEmpty)
                      TextButton.icon(
                        onPressed: _clearHistory,
                        icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                        label: const Text(
                          'Clear All',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
              if (_history.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history_rounded,
                          size: 80,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No listening history',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Songs you play will appear here',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _history.length,
                    separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1),
                    itemBuilder: (context, index) {
                      final song = _history[index];
                      return SongTile(
                        song: song,
                        onTap: () {
                          ref.read(playerProvider.notifier).playSong(song, queue: _history);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
