// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// void main() {
//   runApp(AnagramSolver());
// }
//
// class AnagramSolver extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Anagram Solver',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: AnagramViewPage(),
//     );
//   }
// }
//
// class AnagramViewPage extends StatefulWidget {
//   @override
//   _AnagramViewPageState createState() => _AnagramViewPageState();
// }
//
// class _AnagramViewPageState extends State<AnagramViewPage> {
//   List<String> words = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchWords();
//   }
//
//   Future<void> fetchWords() async {
//     final response = await http.get(Uri.parse('YOUR_API_ENDPOINT'));
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       final List<String> fetchedWords = data.map((e) => e.toString()).toList();
//       setState(() {
//         words = fetchedWords;
//       });
//     } else {
//       throw Exception('Failed to load words');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Anagram Solver')),
//       body: words.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: words.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(words[index]),
//             onTap: () {
//               navigateToAnagramPage(words[index]);
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   void navigateToAnagramPage(String word) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => AnagramPage(word: word)),
//     );
//   }
// }
//
// class AnagramPage extends StatelessWidget {
//   final String word;
//
//   const AnagramPage({required this.word});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Anagram Solver')),
//       body: Center(
//         child: AnagramSolverWidget(word: word),
//       ),
//     );
//   }
// }
//
// class AnagramSolverWidget extends StatefulWidget {
//   final String word;
//
//   const AnagramSolverWidget({required this.word});
//
//   @override
//   _AnagramSolverWidgetState createState() => _AnagramSolverWidgetState();
// }
//
// class _AnagramSolverWidgetState extends State<AnagramSolverWidget> {
//   String guess = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text('Anagram: ${widget.word}'),
//         TextField(
//           onChanged: (value) {
//             setState(() {
//               guess = value;
//             });
//           },
//           decoration: InputDecoration(labelText: 'Enter your guess'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             checkGuess();
//           },
//           child: Text('Check Guess'),
//         ),
//       ],
//     );
//   }
//
//   void checkGuess() {
//     if (guess.toLowerCase() == widget.word.toLowerCase()) {
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: Text('Congratulations!'),
//           content: Text('Your guess is correct.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     } else {
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: Text('Incorrect!'),
//           content: Text('Your guess is incorrect. Try again.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }
