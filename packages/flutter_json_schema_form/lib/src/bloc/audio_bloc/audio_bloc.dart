import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  AudioBloc() : super(const AudioInitial()) {
    on<PlayAudioEvent>(onPlayAudioEvent);
    on<PauseAudioEvent>(onPauseAudioEvent);
    on<SeekAudioEvent>(onSeekAudioEvent);
  }

  void onPlayAudioEvent(PlayAudioEvent event, Emitter<AudioState> emit) {
    // emit(AudioIsPlaying(position: position, buffer: buffer, totalDuration: totalDuration));
  }

  void onPauseAudioEvent(PauseAudioEvent event, Emitter<AudioState> emit) {}

  void onSeekAudioEvent(SeekAudioEvent event, Emitter<AudioState> emit) {}
}
