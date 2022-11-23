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
  // late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    // ..initialize().then((_) {
    //   chewieController = ChewieController(
    //     videoPlayerController: videoPlayerController,
    //     autoPlay: true,
    //   );
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController.value.isInitialized) {
      return AspectRatio(
        aspectRatio: videoPlayerController.value.aspectRatio,
        child: VideoPlayer(videoPlayerController),
      );
      // return Scaffold(
      //   backgroundColor: Colors.black,
      //   appBar: AppBar(
      //     backgroundColor: Colors.black,
      //   ),
      //   body: Chewie(controller: chewieController),
      // );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    // chewieController.dispose();
  }
}
