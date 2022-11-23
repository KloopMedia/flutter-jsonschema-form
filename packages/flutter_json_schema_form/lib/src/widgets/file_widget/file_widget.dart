import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_schema_form/src/bloc/bloc.dart';
import 'package:flutter_json_schema_form/src/widgets/file_widget/file_list.dart';
import 'package:flutter_json_schema_form/src/widgets/file_widget/file_selector.dart';
import 'package:flutter_json_schema_form/src/widgets/file_widget/file_viewer.dart';
import 'package:flutter_json_schema_form/src/widgets/file_widget/upload_task_manager.dart';

class FileWidget extends StatefulWidget {
  final String name;
  final InputDecoration? decoration;
  final dynamic initialValue;
  final Reference storage;
  final bool allowMultiple;
  final void Function(String? value) onChanged;

  const FileWidget({
    Key? key,
    required this.name,
    required this.storage,
    required this.onChanged,
    this.initialValue,
    this.decoration,
    this.allowMultiple = false,
  }) : super(key: key);

  @override
  State<FileWidget> createState() => _FileWidgetState();
}

class _FileWidgetState extends State<FileWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FileBloc(
        value: widget.initialValue,
        storage: widget.storage,
        allowMultiple: widget.allowMultiple,
        onChanged: widget.onChanged,
      ),
      child: FormBuilderField(
        name: widget.name,
        builder: (field) {
          return InputDecorator(
            decoration: widget.decoration ??
                InputDecoration(
                  border: InputBorder.none,
                  errorText: field.errorText,
                ),
            child: const FileFormField(),
          );
        },
      ),
    );
  }
}

class FileFormField extends StatelessWidget {
  const FileFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<FileBloc, FileState>(
      listener: (context, state) {
        if (state is FileError) {
          print(state.error);
        }
        if (state is FilePreview) {
          showDialog(
            context: context,
            builder: (context) {
              return FileViewer(file: state.file);
            },
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FileSelector(
            onSelect: (files) {
              if (files.isNotEmpty) {
                final fileName = files.first.name;
                final bytes = files.first.bytes;

                context.read<FileBloc>().add(AddFileEvent(name: fileName, bytes: bytes));
              }
            },
          ),
          UploadTaskManager(
            onSuccess: (file) {
              context.read<FileBloc>().add(UploadSuccessEvent(file));
            },
          ),
          FileList(
            onPreview: (file, index) {
              context.read<FileBloc>().add(ViewFileEvent(file, index));
            },
            onRemove: (file, index) {
              context.read<FileBloc>().add(RemoveFileEvent(file, index));
            },
            onCopy: (file, index) {},
          ),
        ],
      ),
    );
  }
}
