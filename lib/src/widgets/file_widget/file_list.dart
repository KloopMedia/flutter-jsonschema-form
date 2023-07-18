import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import '../../bloc/bloc.dart';

class FileList extends StatelessWidget {
  final void Function(Reference file, int index) onPreview;
  final void Function(Reference file, int index) onRemove;
  final void Function(Reference file, int index) onDownload;

  const FileList({
    Key? key,
    required this.onPreview,
    required this.onRemove,
    required this.onDownload,
  }) : super(key: key);

  Future<String> getFileSize(Reference file) async {
    final metadata = await file.getMetadata();
    final bytes = metadata.size;
    if (bytes == null || bytes == 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB'];
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

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
            return FutureBuilder(
                future: getFileSize(file),
                builder: (context, AsyncSnapshot snapshot) {
                  final size = snapshot.data;

                  return FileListItem(
                    name: file.name,
                    size: size,
                    onPreview: () {
                      onPreview(file, index);
                    },
                    onRemove: () {
                      onRemove(file, index);
                    },
                    onDownload: () {
                      onDownload(file, index);
                    },
                  );
                }
            );
          },
        );
      },
    );
  }
}

class FileListItem extends StatelessWidget {
  final String name;
  final String? size;
  final void Function() onPreview;
  final void Function() onRemove;
  final void Function() onDownload;

  const FileListItem({
    Key? key,
    required this.name,
    required this.size,
    required this.onPreview,
    required this.onRemove,
    required this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mimeType = lookupMimeType(name);
    final type = mimeType?.split('/').first;

    return Container(
      height: 48,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          FileThumbnail(type: type),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5),
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Roboto',
                      color: Color(0xFF444748),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 5),
                  child: Text(
                    size ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Roboto',
                      color: Color(0xFFC4C7C7),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 48,
            child: Row(
              children: [
                IconButton(onPressed: onDownload, icon: const Icon(Icons.upload, color: Color(0xFFC4C7C7), size: 24)),
                IconButton(onPressed: onPreview, icon: const Icon(Icons.visibility, color: Color(0xFFC4C7C7), size: 24)),
                IconButton(onPressed: onRemove, icon: const Icon(Icons.delete, color: Color(0xFFFF897D), size: 24)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FileThumbnail extends StatelessWidget {
  final String? type;

  const FileThumbnail({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFF444748);

    switch (type) {
      case "image":
        return const Icon(Icons.image_outlined, size: 46, color: iconColor);
      case "video":
        return const Icon(Icons.video_file_outlined, size: 46, color: iconColor);
      case "audio":
        return const Icon(Icons.audio_file_outlined, size: 46, color: iconColor);
      default:
        return const Icon(Icons.text_snippet_outlined, size: 46, color: iconColor);
    }
  }
}
