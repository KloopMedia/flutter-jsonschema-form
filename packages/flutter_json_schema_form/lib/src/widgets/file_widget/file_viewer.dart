import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widgets.dart';

class FileViewer extends StatelessWidget {
  final Reference file;

  const FileViewer({Key? key, required this.file}) : super(key: key);

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
            return ImageViewerWidget(
              url: url,
            );
          }
          return const Text('Error: Failed to load the file!');
        },
      ),
    );
  }
}
