import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chaleno/chaleno.dart';

// import 'package:url_launcher/url_launcher.dart';

class SignOfTheDay extends StatefulWidget {
  const SignOfTheDay({super.key});

  @override
  State<SignOfTheDay> createState() => _SignOfTheDayState();
}

class _SignOfTheDayState extends State<SignOfTheDay> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  String? videoLink;
  String? word;

  void scrapeVideoUrl() async {
    final response = await Chaleno().load("https://www.signingsavvy.com");
    setState(() {
      try {
        videoLink =
            response!.getElementsByClassName('videocontent').first.href!;
        // print("Sign Of the Day: $videoLink");
        word = response
            .getElementsByTagName("a")!
            .firstWhere((element) => element.href.toString() == "signoftheday")
            .text;
        // print("Word: $word");
      } catch (e) {
        print("sign_of_day.dart: $e");
      }
    });
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(
      () async {
        (scrapeVideoUrl());
      },
    );
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(videoLink ??
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setVolume(0);
    _controller.setLooping(true);
    _controller.play();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        // Use a FutureBuilder to display a loading spinner while waiting for the
        // VideoPlayerController to finish initializing.
        FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the VideoPlayerController has finished initialization, use
              // the data it provides to limit the aspect ratio of the video.
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                // Use the VideoPlayer widget to display the video.
                child: VideoPlayer(_controller),
              );
            } else {
              // If the VideoPlayerController is still initializing, show a
              // loading spinner.
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        word != null
            ? Text("Sign of the day:  $word")
            : const Text("Sign of the Day could not be retrieved")
      ]),
    );
  }
}
