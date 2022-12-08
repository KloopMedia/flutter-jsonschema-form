import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_json_schema_form/src/widgets/audio_player_widget/audio_player_widget.dart';

import '../../bloc/bloc.dart';
import 'audio_recorder.dart';

class RecorderWidget extends StatelessWidget {
  const RecorderWidget({super.key});

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
                future: file.getDownloadURL(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CircularProgressIndicator();
                  } else {
                    final url = snapshot.data;
                    return AudioPlayerWidget(url: url);
                  }
                },
              );
            }
            return const AudioPlayerWidget(url: null);
          },
        ),
      ],
    );
  }
}
