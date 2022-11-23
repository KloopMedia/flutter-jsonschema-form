import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc.dart';

class FileList extends StatelessWidget {
  final void Function(Reference file, int index) onPreview;
  final void Function(Reference file, int index) onRemove;
  final void Function(Reference file, int index) onCopy;

  const FileList({
    Key? key,
    required this.onPreview,
    required this.onRemove,
    required this.onCopy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileBloc, FileState>(
      buildWhen: (previous, current) => previous.files != current.files,
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.files.length,
          itemBuilder: (context, index) {
            final file = state.files[index];
            return FileListItem(
              name: file.name,
              onPreview: () {
                onPreview(file, index);
              },
              onRemove: () {
                onRemove(file, index);
              },
              onCopy: () {
                onCopy(file, index);
              },
            );
          },
        );
      },
    );
  }
}

class FileListItem extends StatelessWidget {
  final String name;
  final void Function() onPreview;
  final void Function() onRemove;
  final void Function() onCopy;

  const FileListItem({
    Key? key,
    required this.name,
    required this.onPreview,
    required this.onRemove,
    required this.onCopy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(name, overflow: TextOverflow.ellipsis)),
        IconButton(onPressed: onPreview, icon: const Icon(Icons.visibility)),
        IconButton(onPressed: onRemove, icon: const Icon(Icons.delete)),
        IconButton(onPressed: onCopy, icon: const Icon(Icons.copy)),
      ],
    );
  }
}
