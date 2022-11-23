import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileSelector extends StatelessWidget {
  final void Function(List<PlatformFile>) onSelect;

  const FileSelector({Key? key, required this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final picker = await FilePicker.platform.pickFiles(
          allowCompression: true,
          allowMultiple: false,
        );
        final files = picker?.files ?? [];
        onSelect(files);
      },
      child: const Text('File'),
    );
  }
}
