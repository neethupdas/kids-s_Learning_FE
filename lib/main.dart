import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'mainnew.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePageIP(title: 'IP'),
    );
  }
}

class MyHomePageIP extends StatefulWidget {
  const MyHomePageIP({super.key, required this.title});


  final String title;

  @override
  State<MyHomePageIP> createState() => _MyHomePageIPState();
}

class _MyHomePageIPState extends State<MyHomePageIP> {

  TextEditingController ipcontroller=new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/leaves.jpg'), fit: BoxFit.cover),
        ),
        child: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 10),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: ipcontroller,
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      // enabledBorder: ,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                      ),labelText: 'ip'
                  ),
                ),),
              ElevatedButton(onPressed: ()async{
                SharedPreferences Sh = await SharedPreferences.getInstance();
                Sh.setString('url', 'http://'+ipcontroller.text+":8000/myapp");
                Sh.setString('img_url', 'http://'+ipcontroller.text+":8000");
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title:'Login'),));
                // Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title:'Login'),));
              }, child: Text('SEND'))
            ],
          ),
        ),
      ),
    );
  }
}
