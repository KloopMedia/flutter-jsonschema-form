part of 'audio_bloc.dart';

@immutable
abstract class AudioEvent {}

class PlayAudioEvent extends AudioEvent {}

class PauseAudioEvent extends AudioEvent {}

class SeekAudioEvent extends AudioEvent {
  final Duration position;

  SeekAudioEvent(this.position);
}
