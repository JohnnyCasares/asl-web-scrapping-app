import 'package:asl/words.dart';
import 'package:chaleno/chaleno.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({super.key, required this.search, required this.word});
  final String search;
  final String word;

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  String? videoLink;

  void scrapeVideoUrl() async {
    final response = await Chaleno().load(widget.search);

    setState(() {
      try {
        videoLink =
            response!.getElementsByClassName('videocontent').first.href!;
        // print("Sign Of the Day: $videoLink");

        // print("Word: $word");
      } catch (e) {
        print("search_result.dart: $e");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => WordsResult(
                      search: widget.search,
                      word: widget.word,
                    )));
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
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(videoLink ??
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setVolume(0);

    _controller.play();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search result for:\t${widget.word}",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: FutureBuilder(
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
      ),
    );
  }
}
