import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc.dart';
import '../widgets.dart';
import 'utils.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileBloc, FileState>(
      buildWhen: (previous, current) => previous.files != current.files,
      builder: (context, state) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.files.length,
          itemBuilder: (context, index) {
            final file = state.files[index];
            final type = getMimeType(file.name);

            if (type == "image") {
              final tag = 'file_preview_image_$index';

              return FutureBuilder(
                future: file.getDownloadURL(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final url = snapshot.data!;
                    return Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height - 100,
                      ),
                      child: Hero(
                        tag: tag,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) {
                                return ImageDetailScreen(tag: tag, url: url);
                              }));
                            },
                            child: Image(
                              image: CachedNetworkImageProvider(url),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              );
            }

            return null;
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 16);
          },
        );
      },
    );
  }
}
