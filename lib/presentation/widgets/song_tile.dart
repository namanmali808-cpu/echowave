import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:echowave/domain/entities/song.dart';
import 'package:echowave/presentation/providers/playlist_provider.dart';

class SongTile extends ConsumerWidget {
  final Song song;
  final VoidCallback? onTap;
  final bool showFavorite;
  final Widget? trailing;

  const SongTile({
    super.key,
    required this.song,
    this.onTap,
    this.showFavorite = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(playlistProvider).favoriteSongs.any((s) => s.id == song.id);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: song.albumArtUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: song.albumArtUrl,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                placeholder: (_, __) => _placeholderImage(),
                errorWidget: (_, __, ___) => _placeholderImage(),
              )
            : _placeholderImage(),
      ),
      title: Text(
        song.title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        song.artist,
        style: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 13,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: trailing ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                song.formattedDuration,
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
              ),
              if (showFavorite) ...[
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? const Color(0xFFFF6584) : Colors.white.withOpacity(0.4),
                    size: 20,
                  ),
                  onPressed: () {
                    ref.read(playlistProvider.notifier).toggleFavorite(song);
                  },
                ),
              ],
              IconButton(
                icon: Icon(Icons.play_circle_outline, color: Colors.white.withOpacity(0.4), size: 22),
                onPressed: onTap,
              ),
            ],
          ),
      onTap: onTap,
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF).withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.music_note, color: Colors.white.withOpacity(0.5), size: 24),
    );
  }
}
