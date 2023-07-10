import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_schema_form/flutter_json_schema_form.dart';
import 'package:flutter_json_schema_form/src/widgets/audio_player_widget/audio_player_widget.dart';
import 'package:mime/mime.dart';

import '../widgets.dart';

class FileViewer extends StatelessWidget {
  final Reference file;
  final DownloadFileCallback? downloadFile;

  const FileViewer({Key? key, required this.file, required this.downloadFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: file.getDownloadURL(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            final url = snapshot.data;
            if (url == null) {
              return const Text('Error: Failed to load the file! No file url!');
            }

            final mimeType = lookupMimeType(file.name);
            final type = mimeType?.split('/').first;

            switch (type) {
              case "image":
                return ImageViewerWidget(url: url);
              case "video":
                return VideoPlayerWidget(url: url);
              case "audio":
                return Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: AudioPlayerWidget(url: url),
                  ),
                );
              default:
                return Dialog(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Can't open the file.",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () async {
                              await downloadFile!(url, null).then((value) {
                                if (value != null) {
                                  Navigator.pop(context);
                                }
                              });
                            },
                            child: const Text('Download'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
            }
          }
          return const Text('Error: Failed to load the file!');
        },
      ),
    );
  }
}
