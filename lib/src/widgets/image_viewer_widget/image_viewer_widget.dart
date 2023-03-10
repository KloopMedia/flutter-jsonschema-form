import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageViewerWidget extends StatelessWidget {
  final String url;

  const ImageViewerWidget({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
        Container(
          alignment: AlignmentDirectional.center,
          child: CachedNetworkImage(
            imageUrl: url,
            progressIndicatorBuilder: (context, url, downloadProgress) {
              return CircularProgressIndicator(value: downloadProgress.progress);
            },
            errorWidget: (context, url, error) {
              print(error);
              return Dialog(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.error),
                        SizedBox(height: 12),
                        Text('Error: Failed to load the image!'),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      Align(
        alignment: Alignment.topRight,
        child: Material(
          child: IconButton(
            icon: const Icon(Icons.close_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      ]);
  }
}
