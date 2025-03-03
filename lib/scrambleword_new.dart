// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'dart:math';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   runApp(WordAssemblyApp());
// }
//
// class WordAssemblyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Word Assembly',
//       home: WordAssemblyPage_new(),
//     );
//   }
// }
//
//
// class WordAssemblyPage_new extends StatefulWidget {
//   @override
//   _WordAssemblyPage_newState createState() => _WordAssemblyPage_newState();
// }
//
// class _WordAssemblyPage_newState extends State<WordAssemblyPage_new> {
//   List<String> words = ['F', 'L', 'U', 'T', 'E']; // Sample list of characters
//   List<String> sortedWords = ['F', 'L', 'U', 'T', 'E']; // Correct order of characters
//
//
//
//   int ii=0;
//
//   // get http => null;
//   @override
//   void initState() {
//     super.initState();
//     // words.shuffle();
//
//     ViewAnagrams();
//     // Shuffle the characters initially
//   }
//
//
//   List<String> id_ = <String>[];
//   List<String> orginal_word_ = <String>[];
//
//   // List<String> audio_= <String>[];
//   List<String> shuffle_word_ = <String>[];
//
//    List<String> level_= <String>[];
//
//   Future<void> ViewAnagrams() async {
//     List<String> id = <String>[];
//     List<String> orginal_word = <String>[];
//     // List<String> audio = <String>[];
//     List<String> shuffle_word = <String>[];
//      List<String> level= <String>[];
//
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//       String url = '$urls/childrenviewanagram/';
//
//       var data = await http.post(Uri.parse(url), body: {
//
//         'lid': lid
//       });
//       var jsondata = json.decode(data.body);
//       String statuss = jsondata['status'];
//
//       var arr = jsondata["data"];
//
//       print(arr.length);
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id'].toString());
//         orginal_word.add(arr[i]['orginal_word'].toString());
//         // audio.add(sh.getString('img_url').toString()+arr[i]['audio']);
//         shuffle_word.add(arr[i]['shuffle_word'].toString());
//         // image.add(sh.getString('img_url').toString()+arr[i]['image']);
//         level.add(arr[i]['level'].toString());
//       }
//
//       setState(() {
//         id_ = id;
//         orginal_word_ = orginal_word;
//         shuffle_word_ = shuffle_word;
//          level_ = level;
//
//
//          String s=orginal_word_[0];
//          String d=shuffle_word_[0];
//
//         List<String> words_ = []; // Sample list of characters
//         List<String> sortedWords_ = []; // Correct order of characters
//
//
//         for(int i=0;i<s.length;i++)
//           {
//
//             words_.add(d[i]+"");
//             sortedWords_.add(s[i]+"");
//
//
//           }
//
//         words=words_;
//         sortedWords=sortedWords_;
//
//
//         // words.shuffle();
//       });
//
//
//
//       print(statuss);
//     } catch (e) {
//       print("Error ------------------- " + e.toString());
//       //there is error during converting file image to base64 encoding.
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Word Assembly'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Arrange the letters to form a word:',
//               style: TextStyle(fontSize: 20.0),
//             ),
//             SizedBox(height: 20.0),
//             Wrap(
//               spacing: 10.0,
//               children: words.map((word) {
//                 return Draggable(
//                   data: word,
//                   feedback: Material(
//                     child: Container(
//                       padding: EdgeInsets.all(10.0),
//                       color: Colors.blue[100],
//                       child: Text(
//                         word,
//                         style: TextStyle(fontSize: 20.0),
//                       ),
//                     ),
//                   ),
//                   child: DragTarget<String>(
//                     builder: (BuildContext context, List<String?> candidateData, List<dynamic> rejectedData) {
//                       return Material(
//                         child: Container(
//                           padding: EdgeInsets.all(10.0),
//                           color: Colors.blue[200],
//                           child: Text(
//                             word,
//                             style: TextStyle(fontSize: 20.0),
//                           ),
//                         ),
//                       );
//                     },
//                     onWillAccept: (data) => true,
//                     onAccept: (data) {
//                       setState(() {
//                         int originalIndex = words.indexOf(data!);
//                         int targetIndex = words.indexOf(word);
//                         String temp = words[originalIndex];
//                         words[originalIndex] = words[targetIndex];
//                         words[targetIndex] = temp;
//                         if (words.join() == sortedWords.join()) {
//     // All letters are in the correct order
//     // Show next set of buttons or proceed to the next step
//     print('Correct! Show next set of buttons or proceed.');
//
//
//     if(ii<orginal_word_.length) {
//       setState(() {
//         ii = ii + 1;
//
//
//         String s = orginal_word_[ii];
//         String d = shuffle_word_[ii];
//         List<String> words_ = []; // Sample list of characters
//         List<String> sortedWords_ = []; // Correct order of characters
//         for (int i = 0; i < s.length; i++) {
//           words_.add(d[i] + "");
//           sortedWords_.add(s[i] + "");
//         }
//
//         words = words_;
//         sortedWords = sortedWords_;
//
//
//         // words.shuffle();
//
//
//       });
//     }
//
//     else
//       {
//         Fluttertoast.showToast(msg: "Completed");
//       }
//
//                         }
//                       });
//                     },
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'dart:math';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'AnagramViewPage.dart';
//
// void main() {
//   runApp(WordAssemblyApp());
// }
//
// class WordAssemblyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Anagram',
//       home: WordAssemblyPage_new(),
//     );
//   }
// }
//
// class WordAssemblyPage_new extends StatefulWidget {
//   @override
//   _WordAssemblyPage_newState createState() => _WordAssemblyPage_newState();
// }
//
// class _WordAssemblyPage_newState extends State<WordAssemblyPage_new> {
//   List<String> words = ['F', 'L', 'U', 'T', 'E']; // Sample list of characters
//   List<String> sortedWords = [
//     'F',
//     'L',
//     'U',
//     'T',
//     'E'
//   ]; // Correct order of characters
//
//   int ii = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     ViewAnagrams();
//   }
//
//   List<String> id_ = <String>[];
//   List<String> orginal_word_ = <String>[];
//   List<String> shuffle_word_ = <String>[];
//   List<String> level_ = <String>[];
//
//   Future<void> ViewAnagrams() async {
//     List<String> id = <String>[];
//     List<String> orginal_word = <String>[];
//     List<String> shuffle_word = <String>[];
//     List<String> level = <String>[];
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//       String url = '$urls/childrenviewanagram/';
//
//       var data = await http.post(Uri.parse(url), body: {
//         "lvl":sh.getString("level").toString(),
//         'lid': lid});
//       var jsondata = json.decode(data.body);
//       String statuss = jsondata['status'];
//
//       var arr = jsondata["data"];
//
//       print(arr.length);
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id'].toString());
//         orginal_word.add(arr[i]['orginal_word'].toString());
//         shuffle_word.add(arr[i]['shuffle_word'].toString());
//         level.add(arr[i]['level'].toString());
//       }
//
//       setState(() {
//         id_ = id;
//         orginal_word_ = orginal_word;
//         shuffle_word_ = shuffle_word;
//         level_ = level;
//
//         if (ii < orginal_word_.length) {
//           String s = orginal_word_[ii];
//           String d = shuffle_word_[ii];
//
//           if (s.length == d.length) {
//             List<String> words_ = [];
//             List<String> sortedWords_ = [];
//
//             for (int i = 0; i < s.length; i++) {
//               words_.add(d[i] + "");
//               sortedWords_.add(s[i] + "");
//             }
//
//             words = words_;
//             sortedWords = sortedWords_;
//           } else {
//             print("Error: Lengths of original word and shuffled word do not match.");
//           }
//         } else {
//           Fluttertoast.showToast(msg: "Completed");
//           Navigator.push(context, MaterialPageRoute(
//             builder: (context) => ViewAnagramPage(title: "Level"),));
//         }
//       });
//
//       print(statuss);
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Word Assembly'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Arrange the letters to form a word:',
//               style: TextStyle(fontSize: 20.0),
//             ),
//             SizedBox(height: 20.0),
//             Wrap(
//               spacing: 10.0,
//               children: words.map((word) {
//                 return Draggable(
//                   data: word,
//                   feedback: Material(
//                     child: Container(
//                       padding: EdgeInsets.all(10.0),
//                       color: Colors.red[500],
//                       child: Text(
//                         word,
//                         style: TextStyle(fontSize: 20.0),
//                       ),
//                     ),
//                   ),
//                   child: DragTarget<String>(
//                     builder: (BuildContext context, List<String?> candidateData,
//                         List<dynamic> rejectedData) {
//                       return Material(
//                         child: Container(
//                           padding: EdgeInsets.all(10.0),
//                           color: Colors.pink[200],
//                           child: Text(
//                             word,
//                             style: TextStyle(fontSize: 20.0),
//                           ),
//                         ),
//                       );
//                     },
//                     onWillAccept: (data) => true,
//                     onAccept: (data) {
//                       setState(() {
//                         int originalIndex = words.indexOf(data!);
//                         int targetIndex = words.indexOf(word);
//                         String temp = words[originalIndex];
//                         words[originalIndex] = words[targetIndex];
//                         words[targetIndex] = temp;
//                         if (words.join() == sortedWords.join()) {
//                           print('Correct! Show next set of buttons or proceed.');
//
//                           if (ii < orginal_word_.length) {
//                             setState(() {
//                               ii++;
//                               ViewAnagrams();
//                             });
//                           } else {
//                             Navigator.push(context, MaterialPageRoute(
//                               builder: (context) => ViewAnagramPage(title: "Level"),));
//                             Fluttertoast.showToast(msg: "Completed");
//                           }
//                         }
//                       });
//                     },
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'AnagramViewPage.dart';

void main() {
  runApp(WordAssemblyApp());
}

class WordAssemblyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anagram',
      home: WordAssemblyPage_new(),
    );
  }
}

class WordAssemblyPage_new extends StatefulWidget {
  @override
  _WordAssemblyPage_newState createState() => _WordAssemblyPage_newState();
}

class _WordAssemblyPage_newState extends State<WordAssemblyPage_new> {
  List<String> words = ['F', 'L', 'U', 'T', 'E']; // Sample list of characters
  List<String> sortedWords = [
    'F',
    'L',
    'U',
    'T',
    'E'
  ]; // Correct order of characters

  int ii = 0;

  @override
  void initState() {
    super.initState();
    ViewAnagrams();
  }

  List<String> id_ = <String>[];
  List<String> orginal_word_ = <String>[];
  List<String> shuffle_word_ = <String>[];
  List<String> level_ = <String>[];

  Future<void> ViewAnagrams() async {
    List<String> id = <String>[];
    List<String> orginal_word = <String>[];
    List<String> shuffle_word = <String>[];
    List<String> level = <String>[];
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/childrenviewanagram/';
      var data = await http.post(Uri.parse(url), body: {
        "lvl":sh.getString("level").toString(),
        'lid': lid});
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];
      var arr = jsondata["data"];
      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        orginal_word.add(arr[i]['orginal_word'].toString());
        shuffle_word.add(arr[i]['shuffle_word'].toString());
        level.add(arr[i]['level'].toString());
      }

      setState(() {
        id_ = id;
        orginal_word_ = orginal_word;
        shuffle_word_ = shuffle_word;
        level_ = level;

        if (ii < orginal_word_.length) {
          String s = orginal_word_[ii];
          String d = shuffle_word_[ii];

          if (s.length == d.length) {
            List<String> words_ = [];
            List<String> sortedWords_ = [];

            for (int i = 0; i < s.length; i++) {
              words_.add(d[i] + "");
              sortedWords_.add(s[i] + "");
            }

            words = words_;
            sortedWords = sortedWords_;
          } else {
            print("Error: Lengths of original word and shuffled word do not match.");
          }
        } else {
          Fluttertoast.showToast(msg: "Completed");
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ViewAnagramPage(title: "Level"),));
        }
      });

      print(statuss);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Assembly'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/p2.jpg', // Replace 'background_image.jpg' with your image file
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Arrange the letters to form a word:',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 20.0),
                Wrap(
                  spacing: 10.0,
                  children: words.map((word) {
                    return Draggable(
                      data: word,
                      feedback: Material(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          color: Colors.red[500],
                          child: Text(
                            word,
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                      child: DragTarget<String>(
                        builder: (BuildContext context, List<String?> candidateData,
                            List<dynamic> rejectedData) {
                          return Material(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              color: Colors.pink[200],
                              child: Text(
                                word,
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                          );
                        },
                        onWillAccept: (data) => true,
                        onAccept: (data) {
                          setState(() {
                            int originalIndex = words.indexOf(data!);
                            int targetIndex = words.indexOf(word);
                            String temp = words[originalIndex];
                            words[originalIndex] = words[targetIndex];
                            words[targetIndex] = temp;
                            if (words.join() == sortedWords.join()) {
                              print('Correct! Show next set of buttons or proceed.');

                              if (ii < orginal_word_.length) {
                                setState(() {
                                  ii++;
                                  ViewAnagrams();
                                });
                              } else {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ViewAnagramPage(title: "Level"),));
                                Fluttertoast.showToast(msg: "Completed");
                              }
                            }
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
