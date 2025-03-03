import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Image Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RandomImagePage(),
    );
  }
}

class RandomImagePage extends StatefulWidget {
  @override
  _RandomImagePageState createState() => _RandomImagePageState();
}

class _RandomImagePageState extends State<RandomImagePage> {
  List<String> imagePaths = [];
  late String correctImagePath;
  String? selectedImagePath;
  bool isPicked = false;

  @override
  void initState() {
    super.initState();
    ViewPuzzle();
  }

  void pickRandomImage() {
    setState(() {
      correctImagePath = imagePaths[Random().nextInt(imagePaths.length)];
      selectedImagePath = null; // Reset selectedImagePath
      isPicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Image Picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display a random image first
            if (!isPicked)
              Column(
                children: [
                  Text(
                    'Random Image:',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 10.0),
                  Image.network(
                    correctImagePath,
                    height: 150.0,
                  ),
                  SizedBox(height: 20.0),
                  // Wait for a second and then display all images
                  ElevatedButton(
                    onPressed: () {
                      Timer(Duration(seconds: 1), () {
                        setState(() {
                          isPicked = true;
                        });
                      });
                    },
                    child: Text('Next'),
                  ),
                ],
              )
            else
            // Display all images after a second
              Column(
                children: [
                  Text(
                    'Pick the correct image:',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 10.0),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: imagePaths.map((path) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedImagePath = path;
                          });
                          if (path == correctImagePath) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Correct Choice!'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        pickRandomImage(); // Pick a new random image
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Incorrect Choice!'),
                                  content: Text(
                                      'The correct image was: $correctImagePath'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        pickRandomImage(); // Pick a new random image
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Image.network(
                          path,
                          height: 100.0,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> ViewPuzzle() async {
    List<String> puzzle_image = [];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/childrenviewseq/';

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        puzzle_image.add(sh.getString('img_url').toString() +
            arr[i]['puzzle_image']);
      }

      setState(() {
        imagePaths = List.from(puzzle_image); // Copy the list
        imagePaths.shuffle(); // Shuffle the list
        pickRandomImage(); // Pick a random image after shuffling
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      // Handle error
    }
  }
}
