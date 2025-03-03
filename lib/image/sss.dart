// // import 'dart:async';
// // import 'dart:math';
// //
// // import 'package:flutter/material.dart';
// //
// // void main() {
// //   runApp(SolvePuzzle());
// // }
// //
// // class SolvePuzzle extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Puzzle Solver',
// //       home: SolvePuzzlePage(),
// //     );
// //   }
// // }
// //
// // class SolvePuzzlePage extends StatefulWidget {
// //   @override
// //   _SolvePuzzlePageState createState() => _SolvePuzzlePageState();
// // }
// //
// // class _SolvePuzzlePageState extends State<SolvePuzzlePage> {
// //   final List<int> initialState = [1, 2, 3, 4, 5, 6, 7, 8, 0];
// //   late List<int> puzzleState;
// //   late Random random;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     resetPuzzle();
// //   }
// //
// //   void resetPuzzle() {
// //     puzzleState = List.from(initialState);
// //     random = Random();
// //     // Shuffle the puzzle by making a series of random moves
// //     for (int i = 0; i < 100; i++) {
// //       makeRandomMove();
// //     }
// //     setState(() {});
// //   }
// //
// //   void makeRandomMove() {
// //     // Get empty cell position
// //     int emptyIndex = puzzleState.indexWhere((element) => element == 0);
// //     List<int> neighbors = [];
// //     // Determine valid moves
// //     if (emptyIndex % 3 > 0) neighbors.add(emptyIndex - 1); // Left
// //     if (emptyIndex % 3 < 2) neighbors.add(emptyIndex + 1); // Right
// //     if (emptyIndex >= 3) neighbors.add(emptyIndex - 3); // Up
// //     if (emptyIndex < 6) neighbors.add(emptyIndex + 3); // Down
// //     // Randomly choose a move
// //     int randomIndex = neighbors[random.nextInt(neighbors.length)];
// //     // Swap empty cell with the chosen neighbor
// //     int temp = puzzleState[emptyIndex];
// //     puzzleState[emptyIndex] = puzzleState[randomIndex];
// //     puzzleState[randomIndex] = temp;
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Puzzle Solver'),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             GridView.builder(
// //               shrinkWrap: true,
// //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                 crossAxisCount: 3,
// //               ),
// //               itemCount: 9,
// //               itemBuilder: (BuildContext context, int index) {
// //                 return GestureDetector(
// //                   onTap: () {
// //                     makeMove(index);
// //                   },
// //                   child: Container(
// //                     margin: EdgeInsets.all(4),
// //                     color: puzzleState[index] == 0 ? Colors.grey : Colors.blue,
// //                     child: Center(
// //                       child: Text(
// //                         puzzleState[index] == 0 ? '' : puzzleState[index].toString(),
// //                         style: TextStyle(color: Colors.white, fontSize: 24),
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //             SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: () {
// //                 resetPuzzle();
// //               },
// //               child: Text('Reset Puzzle'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void makeMove(int index) {
// //     int emptyIndex = puzzleState.indexWhere((element) => element == 0);
// //     if (index == emptyIndex) return; // Cannot move empty cell
// //     if (index % 3 == emptyIndex % 3 || index ~/ 3 == emptyIndex ~/ 3) {
// //       // If the clicked cell is in the same row or column as the empty cell
// //       setState(() {
// //         // Swap empty cell with the clicked cell
// //         int temp = puzzleState[emptyIndex];
// //         puzzleState[emptyIndex] = puzzleState[index];
// //         puzzleState[index] = temp;
// //       });
// //     }
// //   }
// // }
// //
// //
// //
// //
//
// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
//
// void main() {
//   runApp(SolvePuzzle());
// }
//
// class SolvePuzzle extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Puzzle Solver',
//       home: SolvePuzzlePage(),
//     );
//   }
// }
//
// class SolvePuzzlePage extends StatefulWidget {
//   @override
//   _SolvePuzzlePageState createState() => _SolvePuzzlePageState();
// }
//
// class _SolvePuzzlePageState extends State<SolvePuzzlePage> {
//   final List<int> initialState = [1, 2, 3, 4, 5, 6, 7, 8, 0];
//   late List<int> puzzleState;
//   late Random random;
//   late ui.Image image;
//   List<ui.Image> puzzlePieces = [];
//
//   @override
//   void initState() {
//     super.initState();
//     resetPuzzle();
//   }
//
//   Future<ui.Image> loadImage(String imagePath) async {
//     ByteData data = await rootBundle.load(imagePath);
//     Uint8List bytes = data.buffer.asUint8List();
//     return decodeImageFromList(Uint8List.view(bytes.buffer));
//   }
//
//   Future<List<ui.Image>> cropImage(ui.Image image, int rows, int cols) async {
//     final imageWidth = image.width;
//     final imageHeight = image.height;
//     final pieceWidth = imageWidth ~/ cols;
//     final pieceHeight = imageHeight ~/ rows;
//
//     List<ui.Image> pieces = [];
//
//     for (int y = 0; y < rows; y++) {
//       for (int x = 0; x < cols; x++) {
//         final recorder = ui.PictureRecorder();
//         final canvas = Canvas(recorder);
//         canvas.drawImageRect(
//           image,
//           Rect.fromLTWH(x * pieceWidth.toDouble(), y * pieceHeight.toDouble(), pieceWidth.toDouble(), pieceHeight.toDouble()),
//           Rect.fromLTWH(0, 0, pieceWidth.toDouble(), pieceHeight.toDouble()),
//           Paint(),
//         );
//         final picture = recorder.endRecording();
//         final img = await picture.toImage(pieceWidth, pieceHeight);
//         final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
//         final Uint8List pngBytes = byteData!.buffer.asUint8List();
//         final ui.Image pieceImage = await decodeImageFromList(pngBytes);
//         pieces.add(pieceImage);
//       }
//     }
//
//     return pieces;
//   }
//
//   void resetPuzzle() async {
//     puzzleState = List.from(initialState);
//     random = Random();
//     image = await loadImage('assets/puzzle_image.jpg');
//     puzzlePieces = await cropImage(image, 3, 3);
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Puzzle Solver'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GridView.builder(
//               shrinkWrap: true,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//               ),
//               itemCount: 9,
//               itemBuilder: (BuildContext context, int index) {
//                 return GestureDetector(
//                   onTap: () {
//                     makeMove(index);
//                   },
//                   child: Container(
//                     margin: EdgeInsets.all(4),
//                     color: puzzleState[index] == 0 ? Colors.grey : Colors.blue,
//                     child: Center(
//                       child: Text(
//                         puzzleState[index] == 0 ? '' : puzzleState[index].toString(),
//                         style: TextStyle(color: Colors.white, fontSize: 24),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 resetPuzzle();
//               },
//               child: Text('Reset Puzzle'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void makeMove(int index) {
//     int emptyIndex = puzzleState.indexWhere((element) => element == 0);
//     if (index == emptyIndex) return; // Cannot move empty cell
//     if (index % 3 == emptyIndex % 3 || index ~/ 3 == emptyIndex ~/ 3) {
//       // If the clicked cell is in the same row or column as the empty cell
//       setState(() {
//         // Swap empty cell with the clicked cell
//         int temp = puzzleState[emptyIndex];
//         puzzleState[emptyIndex] = puzzleState[index];
//         puzzleState[index] = temp;
//       });
//     }
//   }
// }