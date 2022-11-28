part of 'audio_bloc.dart';

@immutable
abstract class AudioState {
  final Duration position;
  final Duration buffer;
  final Duration totalDuration;

  const AudioState({required this.position, required this.buffer, required this.totalDuration});
}

class AudioInitial extends AudioState {
  const AudioInitial({
    super.position = Duration.zero,
    super.buffer = Duration.zero,
    super.totalDuration = Duration.zero,
  });
}

class AudioIsLoaded extends AudioState {
  const AudioIsLoaded({
    required super.position,
    required super.buffer,
    required super.totalDuration,
  });
}

class AudioIsPlaying extends AudioState {
  const AudioIsPlaying({
    required super.position,
    required super.buffer,
    required super.totalDuration,
  });
}

class AudioIsPaused extends AudioState {
  const AudioIsPaused({
    required super.position,
    required super.buffer,
    required super.totalDuration,
  });
}

class AudioIsCompleted extends AudioState {
  const AudioIsCompleted({
    required super.position,
    required super.buffer,
    required super.totalDuration,
  });
}
