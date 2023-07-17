import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
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
              icon: const Icon(Icons.download, color:  Color(0xFF5E80FA)),
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
                    text: 'Выберите файл ',
                    style: const TextStyle(
                      color: Color(0xFF5E80FA),
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
                  const TextSpan(
                    text: 'для загрузки',
                    style: TextStyle(
                      color: Color(0xFF5C5F5F),
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
            const Text(
              '(5 MB max)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFC4C7C7),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
            // ElevatedButton(
            //   onPressed: state.enabled
            //       ? () async {
            //           final picker = await FilePicker.platform.pickFiles(
            //             allowCompression: true,
            //             allowMultiple: false,
            //             withData: true,
            //           );
            //           final files = picker?.files ?? [];
            //           onSelect(files);
            //         }
            //       : null,
            //   child: state.addFileText ?? const Text('Add File'),
            // ),
          ],
        );
      },
    );
  }
}
