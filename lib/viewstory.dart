import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:kidsbook/home.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

import 'listen story.dart';

void main() {
  runApp(const ListenStory());
}

class ListenStory extends StatelessWidget {
  const ListenStory({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Reply',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 82, 98)),
        useMaterial3: true,
      ),
      home: const ViewStoryPage(title: 'View Reply'),
    );
  }
}

class ViewStoryPage extends StatefulWidget {
  const ViewStoryPage({super.key, required this.title});

  final String title;

  @override
  State<ViewStoryPage> createState() => _ViewStoryPageState();
}

class _ViewStoryPageState extends State<ViewStoryPage> {
  AudioPlayer _audioPlayer = AudioPlayer();

  _ViewStoryPageState() {
    ListenStory();
  }

  List<String> id_ = <String>[];
  List<String> story_title_ = <String>[];

  // List<String> audio_= <String>[];
  List<String> description_ = <String>[];

  // List<String> image_= <String>[];

  Future<void> ListenStory() async {
    List<String> id = <String>[];
    List<String> story_title = <String>[];
    // List<String> audio = <String>[];
    List<String> description = <String>[];
    // List<String> image= <String>[];


    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/childrenviewstory/';

      var data = await http.post(Uri.parse(url), body: {

        'lid': lid
      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        story_title.add(arr[i]['story_title']);
        // audio.add(sh.getString('img_url').toString()+arr[i]['audio']);
        description.add(arr[i]['description']);
        // image.add(sh.getString('img_url').toString()+arr[i]['image']);
      }

      setState(() {
        id_ = id;
        story_title_ = story_title;
        // audio_ = audio;
        description_ = description;
        // image_ = image;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }

  void _playAudio(Source url) {
    _audioPlayer.play(url);
  }

  void _stopAudio(Source url) {
    _audioPlayer.stop();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyNewHomePage(title: '',)),);
          },),
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .primary,
          title: Text(widget.title),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF060857),
                Color(0xFFAF0966)
              ], // Light Blue to Blue
            ),
          ),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: id_.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onLongPress: () {
                  print("long press" + index.toString());
                },
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Card(
                        child: Row(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(story_title_[index],
                                        style: TextStyle(fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pink[500])),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      width: 150,
                                      child: Text(description_[index],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          // Make text bold
                                          fontStyle: FontStyle.italic,),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      SharedPreferences sh = await SharedPreferences
                                          .getInstance();
                                      sh.setString('sid', id_[index]);
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              ListenStoryPage(title: '',)));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red[300],
                                      // Change the button color here
                                      onPrimary: Colors.black,
                                      // Change the text color here
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      // Adjust padding if needed
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // Adjust border radius if needed
                                      ),
                                    ),
                                    child: Text(
                                      'LISTEN',
                                      style: TextStyle(
                                        fontWeight: FontWeight
                                            .bold, // Apply bold font weight here
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]
                        ),
                        elevation: 8,
                        margin: EdgeInsets.all(10),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
