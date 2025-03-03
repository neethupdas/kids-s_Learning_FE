// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// void main() {
//   runApp(AnagramViewer());
// }
//
// class AnagramViewer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Anagram Viewer',
//       theme: ThemeData(primarySwatch: Colors.pink),
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
//       appBar: AppBar(title: Text('Anagram Viewer')),
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
// class AnagramPage extends StatefulWidget {
//   final String word;
//
//   const AnagramPage({required this.word});
//
//   @override
//   _AnagramPageState createState() => _AnagramPageState();
// }
//
// class _AnagramPageState extends State<AnagramPage> {
//   List<String> anagrams = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchAnagrams(widget.word);
//   }
//
//   Future<void> fetchAnagrams(String word) async {
//     final response = await http.get(Uri.parse('YOUR_API_ENDPOINT/$word'));
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       final List<String> fetchedAnagrams = data.map((e) => e.toString()).toList();
//       setState(() {
//         anagrams = fetchedAnagrams;
//       });
//     } else {
//       throw Exception('Failed to load anagrams');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Anagrams of ${widget.word}')),
//       body: anagrams.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: anagrams.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(anagrams[index]),
//           );
//         },
//       ),
//     );
//   }
// }
