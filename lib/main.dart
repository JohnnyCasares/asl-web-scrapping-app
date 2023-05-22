import 'package:asl/home.dart';
import 'package:asl/sign_of_day.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const WebScraperApp());

class WebScraperApp extends StatefulWidget {
  const WebScraperApp({super.key});

  @override
  _WebScraperAppState createState() => _WebScraperAppState();
}

class _WebScraperAppState extends State<WebScraperApp> {
  List<Map<String, dynamic>>? productNames;
  late List<Map<String, dynamic>> productDescriptions;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "American Sign Language",
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          textTheme: TextTheme(
            displayLarge: GoogleFonts.raleway(fontSize: 99),
            displayMedium: GoogleFonts.raleway(
              fontSize: 62,
            ),
            displaySmall: GoogleFonts.raleway(fontSize: 49),
            headlineLarge: GoogleFonts.raleway(fontSize: 35),
            headlineMedium: GoogleFonts.raleway(fontSize: 25),
            headlineSmall: GoogleFonts.raleway(
              fontSize: 21,
            ),
            titleLarge: GoogleFonts.raleway(
              fontSize: 16,
            ),
            titleMedium: GoogleFonts.raleway(
              fontSize: 14,
            ),
            bodyLarge: GoogleFonts.karla(
              fontSize: 18,
            ),
            bodySmall: GoogleFonts.karla(
              fontSize: 16,
            ),
          )),
      home: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Column(
                children: [
                  Text(
                    "American Sign Language",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "powered by signing savvy",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [Home(), SignOfTheDay()],
              ),
            ),
          )),
    );
  }
}
