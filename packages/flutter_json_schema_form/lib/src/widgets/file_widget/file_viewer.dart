import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_schema_form/src/widgets/audio_player_widget/audio_player_widget.dart';
import 'package:mime/mime.dart';

import '../widgets.dart';

class FileViewer extends StatelessWidget {
  final Reference file;

  const FileViewer({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Center(
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
                  return AudioPlayerWidget(url: url);
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
                              onPressed: () {},
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
      ),
    );
  }
}
