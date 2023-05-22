import 'package:asl/search_result.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String baseLink = "https://www.signingsavvy.com/search/";
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text("Search for a word"),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Type a word or phrase',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // print("HOME.DART " + (search + _controller.text));
                  String search = baseLink + _controller.text;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResult(
                          search: search,
                          word: _controller.text,
                        ),
                      ));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "Signing Savvy is a sign language dictionary containing several thousand high resolution videos of American Sign Language (ASL) signs, fingerspelled words, and other common signs used within the United States and Canada."),
          )
        ],
      ),
    );
  }
}
