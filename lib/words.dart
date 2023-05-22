import 'package:asl/search_result.dart';
import 'package:chaleno/chaleno.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class WordsResult extends StatefulWidget {
  const WordsResult({super.key, required this.search, required this.word});
  final String search;
  final String word;

  @override
  State<WordsResult> createState() => _WordsResultState();
}

class _WordsResultState extends State<WordsResult> {
  List<String> link = [];
  List<String> meaning = [];

  void scrapeWords() async {
    final response = await Chaleno().load(widget.search);

    setState(() {
      try {
        // response!.getElementsByClassName('search_results').forEach((element) {
        //   link.add(element.href!);
        //   print("LOOP ${element.href!}");
        // });
        // print("Sign Of the Day: $videoLink");
        String htmlElement =
            response!.getElementsByClassName('search_results').first.html!;

        // print("Print result $link");
        // print("Print result $description");

        dom.Document document = parser.parse(htmlElement);

        List<dom.Element> emTags = document.getElementsByTagName('em');
        meaning = emTags.map((element) => element.text).toList();
        List<dom.Element> aTags = document.getElementsByTagName('a');
        link = aTags.map((element) => element.attributes['href']!).toList();
        print("Print result $meaning");
        print("Print result $link");
      } catch (e) {
        print("words.dart: $e");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrapeWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Results"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.word,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: link.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ExpansionTile(
                      title: Text(
                        meaning[index].substring(1, meaning[index].length - 1),
                      ),
                      children: [
                        Text("https://www.signingsavvy.com/sign/" + link[index])
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
