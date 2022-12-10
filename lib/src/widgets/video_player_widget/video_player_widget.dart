import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          autoPlay: true,
        );
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Chewie(controller: chewieController),
      );
    } else {
      return const Dialog(
        child: SizedBox(
          width: 150,
          height: 150,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController.dispose();
  }
}
