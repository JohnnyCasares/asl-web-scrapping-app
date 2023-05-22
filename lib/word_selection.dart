import 'package:chaleno/chaleno.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:video_player/video_player.dart';

class WordSelected extends StatefulWidget {
  const WordSelected({super.key, required this.link});
  final String link;

  @override
  State<WordSelected> createState() => _WordSelectedState();
}

class _WordSelectedState extends State<WordSelected> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  String? videoLink;
  void scrapeVideoUrl() async {
    final response = await Chaleno().load(widget.link);

    setState(() {
      try {
        videoLink =
            response!.getElementsByClassName('videocontent').first.href!;
        // print("Sign Of the Day: $videoLink");

        // print("Word: $word");
      } catch (e) {
        print("search_result.dart: $e");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => scrapeVideoUrl());
  }

  @override
  Widget build(BuildContext context) {
    _controller = VideoPlayerController.network(videoLink ??
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setVolume(0);
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the video.
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                // Use the VideoPlayer widget to display the video.
                child: VideoPlayer(_controller),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        _controller.pause();
                      },
                      child: Icon(Icons.pause)),
                  Padding(padding: EdgeInsets.all(2)),
                  ElevatedButton(
                      onPressed: () {
                        _controller.play();
                      },
                      child: Icon(Icons.play_arrow))
                ],
              )
            ],
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
