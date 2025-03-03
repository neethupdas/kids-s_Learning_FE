import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart'as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';



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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(title: 'Login'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});


  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController unamecontroller=new TextEditingController();
  TextEditingController passcontroller = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(5),child: TextField(
                controller: unamecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),labelText: 'Username'
                ),
              ),),
              Padding(padding: EdgeInsets.all(5),child: TextField(
                controller: passcontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),labelText: 'Password'
                ),
              ),),
              ElevatedButton(onPressed: (){
                _send_data();
              }, child: Text('Login'),
              ),
              SizedBox(height: 20,),
              // TextButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       // MaterialPageRoute(builder: (context) => MySignupPage(title: 'Signup')),
              //     );
              //   },
              //   child: Text("Signup"),
              // ),
            ],
          ),
        ),
      ),
    );
  }



  void _send_data() async{


    String uname=unamecontroller.text;
    String password=passcontroller.text;


    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    final urls = Uri.parse('$url/and_login/');
    try {
      final response = await http.post(urls, body: {
        'name':uname,
        'password':password,


      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {
          String lid=jsonDecode(response.body)['lid'];
          String type=jsonDecode(response.body)['type'];
          if(type=='parent') {
            sh.setString("lid", lid);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => MyNewHomePage(title: "Home"),));
          }}else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      }
      else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    }
    catch (e){
      Fluttertoast.showToast(msg: e.toString());
    }
  }




}
