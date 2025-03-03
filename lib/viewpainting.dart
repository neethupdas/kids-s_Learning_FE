
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:kidsbook/home.dart';
import 'package:kidsbook/solve%20puzzle.dart';
import 'package:kidsbook/solve%20wordnew.dart';
import 'package:kidsbook/view/drawing_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

import 'listen story.dart';

void main() {
  runApp(const ViewPaint());
}

class ViewPaint extends StatelessWidget {
  const ViewPaint({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Paint',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 82, 98)),
        useMaterial3: true,
      ),
      home: const ViewPaintPage(title: 'View Paint'),
    );
  }
}

class ViewPaintPage extends StatefulWidget {
  const ViewPaintPage({super.key, required this.title});

  final String title;

  @override
  State<ViewPaintPage> createState() => _ViewPaintPageState();
}

class _ViewPaintPageState extends State<ViewPaintPage> {
  // AudioPlayer _audioPlayer = AudioPlayer();

  _ViewPaintPageState(){
    ViewPaint();
  }


  List<String> id_ = <String>[];
  List<String> image_= <String>[];
  // List<String> audio_= <String>[];
  List<String> description_= <String>[];
  // List<String> level_= <String>[];

  Future<void> ViewPaint() async {
    List<String> id = <String>[];
    List<String> image = <String>[];
    // List<String> audio = <String>[];
    List<String> description = <String>[];
    // List<String> level= <String>[];


    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/childrenviewpaint/';

      var data = await http.post(Uri.parse(url), body: {

        'lid':lid

      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        // image.add(arr[i]['puzzle_name']);
        // audio.add(sh.getString('img_url').toString()+arr[i]['audio']);

        image.add(sh.getString('img_url').toString()+arr[i]['image']);
        description.add(arr[i]['description']);
      }

      setState(() {
        id_ = id;
        image_ = image;
        description_ = description;
        // level_ = level;
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
      onWillPop: () async{ return true; },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton( onPressed:() {

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyNewHomePage(title: '',)),);

          },),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(widget.title),
        ),
        body: ListView.builder(
          physics: BouncingScrollPhysics(),
          // padding: EdgeInsets.all(5.0),
          // shrinkWrap: true,
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
                        child:
                        Row(
                            children: [
                              Column(
                                children: [
                                  // Padding(
                                  //   padding: EdgeInsets.all(5),
                                  //   child: Text(puzzle_name_[index],
                                  //       style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.pink)),
                                  // ),
                                  Ink.image(image: NetworkImage(image_[index]),height: 200,width: 200,),


                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(description_[index],
                                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black)),
                                  ),




                                  ElevatedButton(onPressed: ()async{
                                    SharedPreferences sh = await SharedPreferences.getInstance();
                                    sh.setString('pid', id_[index]);
                                    sh.setString('image', image_[index]);


                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => DrawingPage()),
                                    );




                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>SolvePuzzlePage(imageUrl: puzzle_image_[index],)));

                                  }, child: Text('Solve'))


                                ],
                              ),

                            ]
                        ),

                        elevation: 8,
                        margin: EdgeInsets.all(10),
                      ),
                    ],
                  )),
            );
          },
        ),



      ),
    );
  }
}

