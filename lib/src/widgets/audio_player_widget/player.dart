import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Player {
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);
  final speedNotifier = ValueNotifier<SpeedState>(SpeedState.normal);

  late AudioPlayer _audioPlayer;

  Player(String? url) {
    _init(url);
  }

  void _init(String? url) async {
    _audioPlayer = AudioPlayer();
    try {
      if (url != null) {
        await _audioPlayer.setUrl(url.trim());
      }
    } on PlayerException catch (e) {
      print("Error code: ${e.code}");
      print("Error message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      print("Connection aborted: ${e.message}");
    } catch (e) {
      // Fallback for all errors
      print(e);
    }

    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });

    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });

    _audioPlayer.speedStream.listen((event) {
      if (_audioPlayer.speed == 0.5) {
        speedNotifier.value = SpeedState.slow;
      } else {
        speedNotifier.value = SpeedState.normal;
      }
    });
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void replay() {
    final position = _audioPlayer.position;
    const tenSeconds = Duration(seconds: 10);
    if (position - tenSeconds > Duration.zero) {
      _audioPlayer.seek(position - tenSeconds);
    } else {
      _audioPlayer.seek(Duration.zero);
    }
  }

  void forward() {
    final position = _audioPlayer.position;
    final total = _audioPlayer.duration ?? Duration.zero;
    const tenSeconds = Duration(seconds: 10);
    if (position + tenSeconds < total) {
      _audioPlayer.seek(position + tenSeconds);
    } else {
      _audioPlayer.seek(total);
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  void setSpeedSlow() {
    _audioPlayer.setSpeed(0.5);
  }

  void setSpeedNormal() {
    _audioPlayer.setSpeed(1.0);
  }
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });

  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }

enum SpeedState { slow, normal }