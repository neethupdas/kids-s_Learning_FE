import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const ListenStory());
}

class ListenStory extends StatelessWidget {
  const ListenStory({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Listen Story',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.deepOrangeAccent),
      ),
      home: const ListenStoryPage(title: 'Listen Story'),
    );
  }
}

class ListenStoryPage extends StatefulWidget {
  const ListenStoryPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ListenStoryPage> createState() => _ListenStoryPageState();
}

class _ListenStoryPageState extends State<ListenStoryPage> {
  AudioPlayer _audioPlayer = AudioPlayer();

  _ListenStoryPageState() {
    _sendData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red,
              Colors.orangeAccent,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  storyTitle_,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16.0),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl_),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  description_,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.play_arrow),
                      iconSize: 25,
                      onPressed: () {
                        _playAudio(UrlSource(audioUrl_));
                      },
                    ),
                  ),
                  SizedBox(height: 100),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.pause),
                      iconSize: 25,
                      onPressed: () {
                        _audioPlayer.stop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String id_ = "";
  String storyTitle_ = "";
  String audioUrl_ = "";
  String description_ = "";
  String imageUrl_ = "";

  void _sendData() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    String sid = sh.getString('sid').toString();

    final urls = Uri.parse('$url/childrenlistenstory/');
    try {
      final response = await http.post(urls, body: {
        'lid': lid,
        'sid': sid,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          String id = jsonDecode(response.body)['id'].toString();
          String storyTitle = jsonDecode(response.body)['story_title'].toString();
          String audioUrl = sh.getString('img_url').toString() + jsonDecode(response.body)['audio'].toString();
          String description = jsonDecode(response.body)['description'].toString();
          String imageUrl = sh.getString('img_url').toString() + jsonDecode(response.body)['image'].toString();

          setState(() {
            id_ = id;
            storyTitle_ = storyTitle;
            audioUrl_ = audioUrl;
            description_ = description;
            imageUrl_ = imageUrl;
          });
        } else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void _playAudio(Source url) {
    _audioPlayer.play(url);
  }
}
