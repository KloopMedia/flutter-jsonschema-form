import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc.dart';
import 'file_list.dart';
import 'file_selector.dart';
import 'file_viewer.dart';
import 'upload_task_manager.dart';

class FileWidget extends StatelessWidget {
  const FileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<FileBloc, FileState>(
      listener: (context, state) async {
        if (state is FileError) {
          print(state.errorMessage);
        }
        if (state is FilePreview) {
          final bloc = context.read<FileBloc>();
          final downloadFile = context.read<FormBloc>().onDownloadFileCallback;
          await showDialog(
            context: context,
            builder: (context) {
              return FileViewer(file: state.file, downloadFile: downloadFile);
            },
          );
          bloc.add(const CloseFileViewerEvent());
        }
      },
      child: Column(
        children: [
          FileSelector(
            onSelect: (files) {
              if (files.isNotEmpty) {
                final fileName = files.first.name;
                final bytes = files.first.bytes;
                final path = files.first.path;

                context
                    .read<FileBloc>()
                    .add(AddFileEvent(name: fileName, bytes: bytes, path: path));
              }
            },
          ),
          const UploadTaskManager(),
          FileList(
            onPreview: (file, index) {
              context.read<FileBloc>().add(ViewFileEvent(file, index));
            },
            onRemove: (file, index) {
              context.read<FileBloc>().add(RemoveFileEvent(file, index));
            },
            onDownload: (file, index) {
              context.read<FormBloc>().add(DownloadFileEvent(file));
            },
          ),
        ],
      ),
    );
  }
}
