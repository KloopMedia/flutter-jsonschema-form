import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc.dart';

class FileSelector extends StatelessWidget {
  final void Function(List<PlatformFile>) onSelect;

  const FileSelector({Key? key, required this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileBloc, FileState>(
      builder: (context, state) {
        // Disable button when uploading file
        if (state is FileLoading) {
          return Row(
            children: const [
              ElevatedButton(
                onPressed: null,
                child: Text('Add File'),
              ),
              SizedBox(width: 16),
              CircularProgressIndicator()
            ],
          );
        }
        return ElevatedButton(
          onPressed: state.enabled
              ? null
              : () async {
                  final picker = await FilePicker.platform.pickFiles(
                    allowCompression: true,
                    allowMultiple: false,
                    withData: true,
                  );
                  final files = picker?.files ?? [];
                  onSelect(files);
                },
          child: const Text('Add File'),
        );
      },
    );
  }
}
