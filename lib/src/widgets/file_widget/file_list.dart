import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
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
                future: Future.wait([getFileSize(file), file.getDownloadURL()]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  final size = snapshot.data?[0];
                  final url = snapshot.data?[1];

                  return FileListItem(
                    name: file.name,
                    size: size,
                    url: url,
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
  final String? url;
  final void Function() onPreview;
  final void Function() onRemove;
  final void Function() onDownload;

  const FileListItem({
    Key? key,
    required this.name,
    required this.size,
    required this.url,
    required this.onPreview,
    required this.onRemove,
    required this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // final mimeType = lookupMimeType(name);
    // final type = mimeType?.split('/').first;
    // String thumbnail;

    // switch (type) {
    //   case "image":
    //     thumbnail = url;
    //     break;
    //   case "video":
    //     final fileName = await VideoThumbnail.thumbnailFile(
    //         video: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
    //         thumbnailPath: (await getTemporaryDirectory()).path,
    //         imageFormat: ImageFormat.WEBP,
    //         maxHeight: 48,
    //         quality: 75,
    //      );
    //       thumbnail = '';
    //     break;
    //   case "audio":
    //     thumbnail = '';
    //     break;
    //   default:
    //     thumbnail = '';
    // }

    return Container(
      height: 48,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 48,
            // decoration: ShapeDecoration(
              // color: Colors.blueGrey,
              // image: DecorationImage(
                // image: NetworkImage(url),
                // fit: BoxFit.fill,
              // ),
              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            // ),
            child: CachedNetworkImage(
              width: 50,
              height: 48,
              imageUrl: "http://via.placeholder.com/200x150",
              imageBuilder: (context, imageProvider) => Container(
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //       image: imageProvider,
                //       fit: BoxFit.cover,
                //       colorFilter: const ColorFilter.mode(Colors.yellow, BlendMode.colorBurn)),
                // ),
                decoration: ShapeDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            // child: CachedNetworkImage(
            //   width: 50,
            //   height: 48,
            //   fit: BoxFit.contain,
            //   // imageBuilder: (context, imageProvider) {
            //   //   return Container(
            //   //     width: 50,
            //   //     height: 48,
            //   //     decoration: ShapeDecoration(
            //   //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
            //   //     ),
            //   //   );
            //   // },
            //   imageUrl: url,
            //   progressIndicatorBuilder: (context, url, downloadProgress) {
            //     return CircularProgressIndicator(value: downloadProgress.progress);
            //   },
            //   errorWidget: (context, url, error) {
            //     print(error);
            //     return const Dialog(
            //       child: SizedBox(
            //         width: 58,
            //         height: 48,
            //         child: Center(
            //           child: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Icon(Icons.error),
            //               SizedBox(height: 12),
            //               Text('Error: Failed to load'),
            //             ],
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            // ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                    color: Color(0xFF444748),
                  ),
                ),
                Text(
                  size ?? '---',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                    color: Color(0xFFC4C7C7),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 48,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(onPressed: onDownload, icon: const Icon(Icons.upload, color: Color(0xFFC4C7C7), size: 20)),
                IconButton(onPressed: onPreview, icon: const Icon(Icons.visibility, color: Color(0xFFC4C7C7), size: 20)),
                IconButton(onPressed: onRemove, icon: const Icon(Icons.delete, color: Color(0xFFFF897D), size: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
