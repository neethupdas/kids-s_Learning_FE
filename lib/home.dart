import 'package:flutter/material.dart';
import 'package:kidsbook/scrambleword_new.dart';
import 'package:kidsbook/seq.dart';
import 'package:kidsbook/solve%20puzzle.dart';
import 'package:kidsbook/solve%20wordnew.dart';
import 'package:kidsbook/view/drawing_page.dart';
import 'package:kidsbook/viewpainting.dart';
import 'package:kidsbook/viewpuzzle.dart';
import 'package:kidsbook/viewstory.dart';
import 'package:kidsbook/listen story.dart';
import 'package:kidsbook/AnagramViewPage.dart';

import 'handwr.dart';


void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyNewHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyNewHomePage extends StatefulWidget {
  const MyNewHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyNewHomePage> createState() => _MyNewHomePageState();
}

class _MyNewHomePageState extends State<MyNewHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text("Puzzle"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewPuzzlePage(title: 'SolvePuzzle')),
                );
              },
            ),
            ListTile(
              title: Text("Image Sequencing and Memorising"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RandomImagePage()),
                );
              },
            ),
            ListTile(
              title: Text("Painting"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewPaintPage(title: '',)),
                );

                // Navigate to Painting page
              },
            ),
            ListTile(
              title: Text("Hand writing"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DrawingPagee()),
                );

                // Navigate to Painting page
              },
            ),

            ListTile(
              title: Text("Listen Story"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewStoryPage(title: 'Listen Story')),
                );
              },
            ),
            ListTile(
              title: Text("Anagram"),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => WordAssemblyPage_new()),
                // );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewAnagramPage(title: 'View Anagram',)),
                );
              },
            ),

            ListTile(
              title: Text("Puzzle new"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SolvePuzzlePage_new(imageUrl: 'https://i.pinimg.com/474x/4a/5c/2f/4a5c2f2a828314d79432bb91afeb3ef3.jpg',)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
