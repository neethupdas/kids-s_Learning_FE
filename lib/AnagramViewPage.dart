import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:kidsbook/home.dart';
import 'package:kidsbook/scrambleword_new.dart';
// import 'package:kidsbook/solve%20puzzle.dart';
// import 'package:kidsbook/solve%20wordnew.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:audioplayers/audioplayers.dart';
import '';
// import 'listen story.dart';

void main() {
  runApp(const ViewAnagram());
}

class ViewAnagram extends StatelessWidget {
  const ViewAnagram({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Anagram',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 82, 98)),
        useMaterial3: true,
      ),
      home: const ViewAnagramPage(title: 'View Anagram'),
    );
  }
}

class ViewAnagramPage extends StatefulWidget {
  const ViewAnagramPage({super.key, required this.title});

  final String title;

  @override
  State<ViewAnagramPage> createState() => _ViewAnagramPageState();
}

class _ViewAnagramPageState extends State<ViewAnagramPage> {
  // AudioPlayer _audioPlayer = AudioPlayer();

  _ViewAnagramPageState() {
    ViewAnagram();
  }

  List<String> did_ = <String>[];
  List<String> orginal_word_ = <String>[];
  // List<String> audio_= <String>[];
  List<String> shuffle_word_ = <String>[];
  List<String> level_ = <String>[];

  Future<void> ViewAnagram() async {
    List<String> did = <String>[];
    List<String> orginal_word = <String>[];
    // List<String> audio = <String>[];
    List<String> shuffle_word = <String>[];
    List<String> level = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/childrenviewanagram/';

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        did.add(arr[i]['id'].toString());
        orginal_word.add(arr[i]['puzzle_name']);
        // audio.add(sh.getString('img_url').toString()+arr[i]['audio']);

        shuffle_word
            .add(sh.getString('img_url').toString() + arr[i]['puzzle_image']);
        level.add(arr[i]['level']);
      }

      setState(() {
        did_ = did;
        orginal_word_ = orginal_word;
        shuffle_word_ = shuffle_word;
        level_ = level;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyNewHomePage(
                            title: 'HOME',
                          )),
                );
              },
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(widget.title),
          ),
          body: Column(
            children: [
              InkWell(
                onTap: () async {
                  SharedPreferences sh=await SharedPreferences.getInstance();
                  sh.setString("level", "easy");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WordAssemblyPage_new()),
                  );
                },
                child: Card(
                  child: ListTile(
                    title: Text("Easy",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    subtitle: Text("Tap to view anagrams",
                        style: TextStyle(color: Colors.black)),
                  ),
                  elevation: 8,
                ),
              ),
              InkWell(
                onTap: () async {
                  SharedPreferences sh=await SharedPreferences.getInstance();
                  sh.setString("level", "medium");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WordAssemblyPage_new()),
                  );
                },
                child: Card(
                  child: ListTile(
                    title: Text("Medium",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent)),
                    subtitle: Text("Tap to view anagrams",
                        style: TextStyle(color: Colors.black)),
                  ),
                  elevation: 8,
                ),
              ),
              InkWell(
                onTap: () async {
                  SharedPreferences sh=await SharedPreferences.getInstance();
                  sh.setString("level", "hard");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WordAssemblyPage_new()),
                  );
                },
                child: Card(
                  child: ListTile(
                    title: Text("Hard",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                    subtitle: Text("Tap to view anagrams",
                        style: TextStyle(color: Colors.black)),
                  ),
                  elevation: 8,
                ),
              ),
            ],
          )),
    );
  }
}
