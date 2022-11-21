import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_schema_form/src/bloc/file_bloc/file_bloc.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

class FileWidget extends StatefulWidget {
  final String name;
  final InputDecoration decoration;

  const FileWidget({
    Key? key,
    required this.name,
    required this.decoration,
  }) : super(key: key);

  @override
  State<FileWidget> createState() => _FileWidgetState();
}

class _FileWidgetState extends State<FileWidget> {
  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: widget.name,
      builder: (field) {
        return InputDecorator(
          decoration: InputDecoration(
            border: InputBorder.none,
            errorText: field.errorText,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final bloc = context.read<FileBloc>();
                  final picker = await FilePicker.platform.pickFiles(
                    allowCompression: true,
                    allowMultiple: false,
                  );
                  final files = picker?.files ?? [];
                  if (files.isNotEmpty) {
                    final fileName = files.first.name;
                    final bytes = files.first.bytes;
                    const type = FileType.media;
                    bloc.add(AddFileEvent(name: fileName, bytes: bytes, type: type));
                  }
                },
                child: const Text('File'),
              ),
              BlocBuilder<FileBloc, FileState>(
                builder: (context, state) {
                  if (state is FileError) {
                    return Text('Error');
                  } else if (state is FileLoading) {
                    return Row(
                      children: [
                        Flexible(
                          child: Text(state.name, softWrap: true, overflow: TextOverflow.ellipsis),
                        ),
                        Expanded(child: LinearProgressIndicator(value: state.progress)),
                        Text('${state.progress.toInt() * 100}'),
                      ],
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.files.length,
                      itemBuilder: (context, index) {
                        return Text(state.files[index].name);
                      },
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
