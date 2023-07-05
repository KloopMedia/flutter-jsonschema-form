import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              onDownload: () {
                onDownload(file, index);
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
  final void Function() onDownload;

  const FileListItem({
    Key? key,
    required this.name,
    required this.onPreview,
    required this.onRemove,
    required this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 348,
          height: 48,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 50,
                height: double.infinity,
                decoration: ShapeDecoration(
                  image: const DecorationImage(
                    image: NetworkImage("https://via.placeholder.com/50x48"),
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                ),
              ),
              const SizedBox(width: 116),
              SizedBox(
                width: 288,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Water-problems.jpg',
                      style: TextStyle(
                        color: Color(0xFF444748),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            '20 MB',
                            style: TextStyle(
                              color: Color(0xFFC4C7C7),
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(onPressed: onPreview, icon: Image.asset('assets/images/export.png'),),
                              IconButton(onPressed: onRemove, icon: Image.asset('assets/images/eye.png'),),
                              IconButton(onPressed: onDownload, icon: Image.asset('assets/images/trash.png'),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
    // return Row(
    //   children: [
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Expanded(child: Text(name, overflow: TextOverflow.ellipsis)),
    //         Text(
    //           '',
    //
    //         )
    //       ],
    //     ),
    //     // IconButton(onPressed: onPreview, icon: const Icon(Icons.visibility)),
    //     // IconButton(onPressed: onRemove, icon: const Icon(Icons.delete)),
    //     // IconButton(onPressed: onCopy, icon: const Icon(Icons.copy)),
    //   ],
    // );
  }
}
