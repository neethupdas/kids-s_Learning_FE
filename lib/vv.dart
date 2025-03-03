// import 'package:flutter/material.dart';
// import 'package:kidsbook/solve%20puzzle.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const LoginPage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key, required this.title});
//
//
//
//   final String title;
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   TextEditingController usernameController=new TextEditingController();
//   TextEditingController passwordController=new TextEditingController();
//
//   final _formkey=GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//
//         title: Text(widget.title),
//       ),
//       body: Center(
//
//         child: Column(
//
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextFormField(
//               controller: usernameController,
//
//               decoration: InputDecoration(
//                   border: OutlineInputBorder(),label:
//               Text("username")
//
//               ),),
//             TextFormField(
//               controller: passwordController,
//               decoration: InputDecoration(
//                   border: OutlineInputBorder(),label:
//               Text("password")
//
//               ),),
//             ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>SolvepuzzlePage(title: 'SolvePuzzle',)));
//             }, child: Text("login"))
//
//
//
//           ],
//         ),
//       ),
//
//     );
//   }
// }
