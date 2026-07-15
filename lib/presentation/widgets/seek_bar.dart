import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SeekBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration>? onSeek;
  final ValueChanged<Duration>? onSeekStart;
  final ValueChanged<Duration>? onSeekEnd;

  const SeekBar({
    super.key,
    required this.position,
    required this.duration,
    this.onSeek,
    this.onSeekStart,
    this.onSeekEnd,
  });

  String _formatDuration(Duration d) {
    final format = DateFormat(d.inHours > 0 ? 'H:mm:ss' : 'm:ss');
    return format.format(DateTime(0).add(d));
  }

  @override
  Widget build(BuildContext context) {
    final pos = position.inSeconds.toDouble();
    final dur = duration.inSeconds.toDouble();
    final progress = dur > 0 ? pos / dur : 0.0;

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF6C63FF),
            inactiveTrackColor: Colors.white.withOpacity(0.2),
            thumbColor: const Color(0xFF6C63FF),
            overlayColor: const Color(0xFF6C63FF).withOpacity(0.2),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: (value) {
              final newPosition = Duration(seconds: (value * dur).round());
              onSeekStart?.call(newPosition);
              onSeek?.call(newPosition);
            },
            onChangeEnd: (value) {
              final newPosition = Duration(seconds: (value * dur).round());
              onSeekEnd?.call(newPosition);
              onSeek?.call(newPosition);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
              ),
              Text(
                _formatDuration(duration),
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
