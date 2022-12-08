import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import 'player.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String url;
  final bool disabled;

  const AudioPlayerWidget({Key? key, required this.url, this.disabled = false}) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late final Player _player;

  @override
  void initState() {
    super.initState();
    _player = Player(widget.url);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<ProgressBarState>(
              valueListenable: _player.progressNotifier,
              builder: (_, value, __) {
                return ProgressBar(
                  progress: value.current,
                  buffered: value.buffered,
                  total: value.total,
                  onSeek: widget.disabled ? null : _player.seek,
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: widget.disabled ? null : _player.replay,
                  icon: const Icon(Icons.replay_10),
                ),
                ValueListenableBuilder<ButtonState>(
                  valueListenable: _player.buttonNotifier,
                  builder: (_, value, __) {
                    switch (value) {
                      case ButtonState.loading:
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          width: 32.0,
                          height: 32.0,
                          child: const CircularProgressIndicator(),
                        );
                      case ButtonState.paused:
                        return IconButton(
                          icon: const Icon(Icons.play_arrow),
                          iconSize: 32.0,
                          onPressed: widget.disabled ? null : _player.play,
                        );
                      case ButtonState.playing:
                        return IconButton(
                          icon: const Icon(Icons.pause),
                          iconSize: 32.0,
                          onPressed: widget.disabled ? null : _player.pause,
                        );
                    }
                  },
                ),
                IconButton(
                  onPressed: widget.disabled ? null : _player.forward,
                  icon: const Icon(Icons.forward_10),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
