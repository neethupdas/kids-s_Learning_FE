import 'dart:async';
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

void main() {
  runApp(ImagePuzzleApp());
}

class ImagePuzzleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Puzzle',
      home: SolvePuzzlePage_new(
        imageUrl: 'https://i.pinimg.com/474x/4a/5c/2f/4a5c2f2a828314d79432bb91afeb3ef3.jpg',
      ),
    );
  }
}

class SolvePuzzlePage_new extends StatefulWidget {
  final String imageUrl;

  const SolvePuzzlePage_new({required this.imageUrl});

  @override
  _SolvePuzzlePage_newState createState() => _SolvePuzzlePage_newState();
}

class _SolvePuzzlePage_newState extends State<SolvePuzzlePage_new> {
  late List<int> puzzleState;
  late List<Uint8List> puzzlePieces;

  @override
  void initState() {
    super.initState();
    resetPuzzle();
  }

  Future<void> resetPuzzle() async {
    puzzleState = List.generate(9, (index) => index);
    List<Uint8List> croppedPieces = await cropImage(widget.imageUrl);
    // Shuffle the puzzle pieces before setting the state
    puzzlePieces = shuffleList(croppedPieces);
    setState(() {});
  }

  // Method to shuffle a list
  List<T> shuffleList<T>(List<T> list) {
    var random = Random();
    for (var i = list.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);
      var temp = list[i];
      list[i] = list[n];
      list[n] = temp;
    }
    return list;
  }

  Future<List<Uint8List>> cropImage(String imageUrl) async {
    try {
      var response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // Decode the image data
        img.Image image = img.decodeImage(response.bodyBytes)!;

        // Calculate piece dimensions based on image size
        int pieceWidth = image.width ~/ 3;
        int pieceHeight = image.height ~/ 3;

        // Crop the image into puzzle pieces
        List<Uint8List> pieces = [];
        for (int y = 0; y < 3; y++) {
          for (int x = 0; x < 3; x++) {
            img.Image piece = img.copyCrop(
              image,
              x: x * pieceWidth,
              y: y * pieceHeight,
              width: pieceWidth,
              height: pieceHeight,
            );
            pieces.add(Uint8List.fromList(img.encodePng(piece)));
          }
        }

        return pieces;
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading image: $e');
      throw Exception('Failed to load image');
    }
  }

  void swapPieces(int index) {
    setState(() {
      final emptyIndex = puzzleState.indexOf(0);
      if (_canMove(index, emptyIndex)) {
        puzzleState[emptyIndex] = puzzleState[index];
        puzzleState[index] = 0;
        if (puzzleState.every((piece) => piece == puzzleState.indexOf(piece))) {
          _showCompletionDialog();
        }
      }
    });
  }

  bool _canMove(int index1, int index2) {
    if (index1 == index2) return false;
    final row1 = index1 ~/ 3;
    final col1 = index1 % 3;
    final row2 = index2 ~/ 3;
    final col2 = index2 % 3;
    return (row1 == row2 && (col1 - col2).abs() == 1) || (col1 == col2 && (row1 - row2).abs() == 1);
  }

  void _showCompletionDialog() {
    if (puzzleState.every((piece) => piece == puzzleState.indexOf(piece))) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You solved the puzzle!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Puzzle'),
      ),
      body: Center(
        child: puzzlePieces != null
            ? GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: puzzleState.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                swapPieces(index);
              },
              child: Container(
                color: puzzleState[index] == 0 ? Colors.grey : Colors.blue,
                child: Center(
                  child: puzzleState[index] == 0 ? Text("0") : Image.memory(puzzlePieces[puzzleState[index]]),
                ),
              ),
            );
          },
        )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: resetPuzzle,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
