import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_json_schema_form/l10n/loc.dart';

import '../../bloc/bloc.dart';

class FileSelector extends StatelessWidget {
  final void Function(List<PlatformFile>) onSelect;

  const FileSelector({Key? key, required this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return BlocBuilder<FileBloc, FileState>(
      builder: (context, state) {
        // Disable button when uploading file
        if (state is FileLoading || state is FileCompressing) {
          return const CircularProgressIndicator();
          // return Row(
          //   children: [
          //     ElevatedButton(
          //       onPressed: null,
          //       child: state.addFileText ?? const Text('Add File'),
          //     ),
          //     const SizedBox(width: 16),
          //     const CircularProgressIndicator()
          //   ],
          // );
        }
        return Column(
          children: [
            IconButton(
              icon: Icon(Icons.upload, color: theme.primary),
              onPressed: state.enabled
                  ? () async {
                final picker = await FilePicker.platform.pickFiles(
                  allowCompression: true,
                  allowMultiple: false,
                  withData: true,
                );
                final files = picker?.files ?? [];
                onSelect(files);
              }
                  : null,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: context.loc.select_file_start,
                    style: TextStyle(
                      color: theme.primary,
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = state.enabled
                          ? () async {
                        final picker = await FilePicker.platform.pickFiles(
                          allowCompression: true,
                          allowMultiple: false,
                          withData: true,
                        );
                        final files = picker?.files ?? [];
                        onSelect(files);
                      }
                          : null,
                  ),
                  TextSpan(
                    text: context.loc.select_file_end,
                    style: TextStyle(
                      color: theme.onSurface,
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '(5 MB max)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.onSurface,
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        );
      },
    );
  }
}
