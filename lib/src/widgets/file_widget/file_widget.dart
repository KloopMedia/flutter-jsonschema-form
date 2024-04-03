import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_json_schema_form/l10n/loc.dart';

import '../../bloc/bloc.dart';
import 'file_list.dart';
import 'file_preview.dart';
import 'file_selector.dart';
import 'file_viewer.dart';
import 'upload_task_manager.dart';

class FileWidget extends StatelessWidget {
  const FileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FileBloc, FileState>(
      listener: (context, state) async {
        if (state is FileError) {
          print(state.errorMessage);
        }
        if (state is FileUploadSuccess) {
          SnackBar snackBar = SnackBar(
            content: Text(context.loc.file_upload_success),
            backgroundColor: Colors.green,
            dismissDirection: DismissDirection.up,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 60,
              left: 10,
              right: 10,
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
          const ImagePreview(),
          FileSelector(
            onSelect: (files) {
              if (files.isNotEmpty) {
                final fileName = files.first.name;
                final bytes = files.first.bytes;

                context
                    .read<FileBloc>()
                    .add(AddFileEvent(name: fileName, bytes: bytes, files: files));
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
