import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_json_schema_form/src/widgets/audio_recorder_widget/audio_recorder.dart';

import '../../bloc/bloc.dart';
import 'audio_player.dart';

class AudioRecorderWidget extends StatelessWidget {
  const AudioRecorderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AudioRecorder(),
        BlocBuilder<FileBloc, FileState>(
          builder: (context, state) {
            final files = state.files;
            if (state is FileLoading) {
              return const CircularProgressIndicator();
            }
            if (files.isNotEmpty) {
              final file = files.first;
              return FutureBuilder(
                future: file.getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CircularProgressIndicator();
                  } else {
                    final url = snapshot.data;
                    if (url != null) {
                      return AudioPlayer(bytes: url);
                    } else {
                      return const AudioPlayer();
                    }
                  }
                },
              );
            }
            return const AudioPlayer();
          },
        ),
      ],
    );
  }
}
