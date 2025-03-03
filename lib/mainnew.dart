import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kidsbook/signin_button.dart';
import 'package:kidsbook/bear_log_in_controller.dart';
import 'package:kidsbook/tracking_text_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bear_log_in_Controller _bear_log_inController;

  String usernamejis="";
  String passwordjis="";
  @override
  initState() {
    _bear_log_inController = bear_log_in_Controller();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: Color.fromRGBO(93, 142, 155, 1.0),
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  // Box decoration takes a gradient
                  gradient: LinearGradient(
                    // Where the linear gradient begins and ends
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    stops: [0.0, 1.0],
                    colors: [
                      Color(0xffde2e2e),
                      Color(0xff80136d),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: devicePadding.top + 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        height: 200,
                        padding:  EdgeInsets.only(left: 30.0, right: 30.0),
                        child: FlareActor(
                          "assets/Teddy.flr",
                          shouldClip: false,
                          alignment: Alignment.bottomCenter,
                          fit: BoxFit.contain,
                          controller: _bear_log_inController,
                        )),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Form(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TrackingTextInput(
                                label: "Email",
                                hint: "What's your email address?",
                                onCaretMoved: (Offset? caret) {
                                  _bear_log_inController
                                      .coverEyes(caret == null);
                                  _bear_log_inController.lookAt(caret);
                                },
                                  onTextChanged: (text) {


usernamejis=text.toString();

                                  },
                              ),
                              TrackingTextInput(
                                label: "Password",
                                hint: "I'm not watching",
                                isObscured: true,
                                onCaretMoved: (Offset? caret) {
                                  _bear_log_inController
                                      .coverEyes(caret != null);
                                  _bear_log_inController.lookAt(null);
                                },
                                onTextChanged: (String value) {

                                  passwordjis= value;

                                  // usernamejis=value.toString();


                                  _bear_log_inController.setPassword(value);
                                },
                              ),
                              SigninButton(
                                child: Text("Sign In",
                                    style: TextStyle(
                                        fontFamily: "RobotoMedium",
                                        fontSize: 16,
                                        color: Colors.white)),
                                onPressed: () async {

                                  SharedPreferences sh = await SharedPreferences.getInstance();
                                  String url = sh.getString('url').toString();

                                  final urls = Uri.parse('$url/and_login/');
                                  try {
                                    final response = await http.post(urls, body: {
                                      'name':usernamejis,
                                      'password':passwordjis,


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

                                  // _bear_log_inController.submitPassword();
                                },
                              ),
                              // TextButton(onPressed: (){
                              //
                              // }, child: Text("Register"))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
