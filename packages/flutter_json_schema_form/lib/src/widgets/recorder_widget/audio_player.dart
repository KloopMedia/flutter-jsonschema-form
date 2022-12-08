import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart' show Level;

/// Sample rate used for Streams
const int tSTREAMSAMPLERATE = 44000; // 44100 does not work for recorder on iOS

class AudioPlayer extends StatefulWidget {
  final String? url;
  final bool disabled;
  final Uint8List? bytes;

  const AudioPlayer({
    Key? key,
    this.url,
    this.disabled = false,
    this.bytes,
  }) : super(key: key);

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  bool _isPlaying = false;
  String? _path;
  Uint8List? _bytes;

  StreamSubscription? _playerSubscription;

  FlutterSoundPlayer playerModule = FlutterSoundPlayer(logLevel: Level.nothing);

  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;

  Future<void> init() async {
    await playerModule.closePlayer();
    await playerModule.openPlayer();
    await playerModule.setSubscriptionDuration(const Duration(milliseconds: 10));
    await initializeDateFormatting();
  }

  @override
  void initState() {
    if (widget.url != null && widget.url != '') {
      _path = widget.url;
    }
    if (widget.bytes != null) {
      _bytes = widget.bytes;
    }
    init();
    super.initState();
  }

  void cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription!.cancel();
      _playerSubscription = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    cancelPlayerSubscriptions();
    closePlayer();
  }

  Future<void> closePlayer() async {
    try {
      await playerModule.closePlayer();
    } on Exception {
      playerModule.logger.e('Released unsuccessful');
    }
  }

  void _addListeners() {
    cancelPlayerSubscriptions();
    _playerSubscription = playerModule.onProgress!.listen((e) {
      maxDuration = e.duration.inMilliseconds.toDouble();
      if (maxDuration <= 0) maxDuration = 0.0;

      sliderCurrentPosition = min(e.position.inMilliseconds.toDouble(), maxDuration);
      if (sliderCurrentPosition < 0.0) {
        sliderCurrentPosition = 0.0;
      }
      setState(() {});
    });
  }

  Future<void> startPlayer() async {
    try {
      if (_path != null || _bytes != null) {
        await playerModule.startPlayer(
            fromURI: _path,
            fromDataBuffer: widget.bytes,
            codec: Codec.aacMP4,
            sampleRate: tSTREAMSAMPLERATE,
            whenFinished: () {
              setState(() {
                _isPlaying = false;
              });
            });
        _addListeners();
        setState(() {
          _isPlaying = true;
        });
      }
    } on Exception catch (err) {
      playerModule.logger.e('error: $err');
    }
  }

  Future<void> stopPlayer() async {
    try {
      await playerModule.stopPlayer();
      if (_playerSubscription != null) {
        await _playerSubscription!.cancel();
        _playerSubscription = null;
      }
      sliderCurrentPosition = 0.0;
      setState(() {
        _isPlaying = false;
      });
    } on Exception catch (err) {
      playerModule.logger.d('error: $err');
    }
    setState(() {});
  }

  void pauseResumePlayer() async {
    try {
      if (playerModule.isPlaying) {
        await playerModule.pausePlayer();
        setState(() {
          _isPlaying = false;
        });
      } else if (playerModule.isPaused) {
        await playerModule.resumePlayer();
        setState(() {
          _isPlaying = true;
        });
      }
    } on Exception catch (err) {
      playerModule.logger.e('error: $err');
    }
  }

  Future<void> seekToPlayer(int milliSecs) async {
    try {
      if (playerModule.isPlaying) {
        await playerModule.seekToPlayer(Duration(milliseconds: milliSecs));
      }
    } on Exception catch (err) {
      playerModule.logger.e('error: $err');
    }
    setState(() {});
  }

  void Function()? onStartPausePlayerPressed() {
    // A file must be already recorded to play it
    if (_path == null && _bytes == null) return null;

    if (playerModule.isStopped) {
      return startPlayer;
    } else if (playerModule.isPaused || playerModule.isPlaying) {
      return pauseResumePlayer;
    } else {
      return null;
    }
  }

  void Function()? onStopPlayerPressed() {
    return (playerModule.isPlaying || playerModule.isPaused) ? stopPlayer : null;
  }

  void forwardAudio() async {
    // Forward audio by 10 seconds.
    final newPosition = sliderCurrentPosition + 10000;
    if (newPosition < maxDuration) {
      await seekToPlayer(newPosition.toInt());
    } else {
      await seekToPlayer(maxDuration.toInt());
    }
  }

  void rewindAudio() async {
    // Rewind audio by 10 seconds.
    final newPosition = sliderCurrentPosition - 10000;
    if (newPosition > 0) {
      await seekToPlayer(newPosition.toInt());
    } else {
      await seekToPlayer(0);
    }
  }

  void Function()? onForwardPress() {
    return playerModule.isPlaying || playerModule.isPaused ? forwardAudio : null;
  }

  void Function()? onRewindPress() {
    return playerModule.isPlaying || playerModule.isPaused ? rewindAudio : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ControlButtons(
          rewind: onRewindPress(),
          forward: onForwardPress(),
          startPause: onStartPausePlayerPressed(),
          stop: onStopPlayerPressed(),
          isPlaying: _isPlaying,
        ),
        AudioSlider(
          currentPosition: sliderCurrentPosition,
          maxDuration: maxDuration,
          onChanged: (value) async {
            await seekToPlayer(value.toInt());
          },
        ),
      ],
    );
  }
}

class ControlButtons extends StatelessWidget {
  final void Function()? rewind;
  final void Function()? forward;
  final void Function()? startPause;
  final void Function()? stop;
  final bool isPlaying;

  const ControlButtons({
    Key? key,
    required this.rewind,
    required this.forward,
    required this.startPause,
    required this.stop,
    required this.isPlaying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 56.0,
          height: 50.0,
          child: ClipOval(
            child: IconButton(
              onPressed: rewind,
              icon: const Icon(Icons.replay_10),
            ),
          ),
        ),
        SizedBox(
          width: 56.0,
          height: 50.0,
          child: ClipOval(
            child: IconButton(
              onPressed: startPause,
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            ),
          ),
        ),
        SizedBox(
          width: 56.0,
          height: 50.0,
          child: ClipOval(
            child: IconButton(
              onPressed: forward,
              icon: const Icon(Icons.forward_10),
            ),
          ),
        ),
        SizedBox(
          width: 56.0,
          height: 50.0,
          child: ClipOval(
            child: IconButton(
              onPressed: stop,
              icon: const Icon(Icons.stop),
            ),
          ),
        ),
      ],
    );
  }
}

class AudioSlider extends StatefulWidget {
  final double currentPosition;
  final double maxDuration;
  final void Function(double value) onChanged;

  const AudioSlider({
    Key? key,
    required this.currentPosition,
    required this.maxDuration,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<AudioSlider> createState() => _AudioSliderState();
}

class _AudioSliderState extends State<AudioSlider> {
  double? value;

  // @override
  // void initState() {
  //   value = min(widget.currentPosition, widget.maxDuration);
  //
  //   super.initState();
  // }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final current = Duration(milliseconds: widget.currentPosition.toInt());
    final duration = Duration(milliseconds: widget.maxDuration.toInt());

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Slider(
            value: value ?? min(widget.currentPosition, widget.maxDuration),
            min: 0.0,
            max: widget.maxDuration,
            onChanged: (val) {
              setState(() {
                value = val;
              });
            },
            onChangeEnd: (val) {
              widget.onChanged(val);
              setState(() {
                value = null;
              });
            },
            divisions: widget.maxDuration == 0.0 ? 1 : widget.maxDuration.toInt(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            ('${_printDuration(current)}/${_printDuration(duration)}'),
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }
}
