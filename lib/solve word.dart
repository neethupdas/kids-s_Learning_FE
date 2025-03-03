import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(ImagePuzzleApp());
}

class ImagePuzzleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Puzzle',
      home: SolvePuzzlePage(
        imageUrl: 'https://i.pinimg.com/474x/4a/5c/2f/4a5c2f2a828314d79432bb91afeb3ef3.jpg',
      ),
    );
  }
}

class SolvePuzzlePage extends StatefulWidget {
  final String imageUrl;

  const SolvePuzzlePage({required this.imageUrl});

  @override
  _SolvePuzzlePageState createState() => _SolvePuzzlePageState();
}

class _SolvePuzzlePageState extends State<SolvePuzzlePage> {
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
    setState(() {
      puzzlePieces = croppedPieces;
    });
  }

  Future<List<Uint8List>> cropImage(String imageUrl) async {
    try {
      var response = await http.get(Uri.parse(imageUrl));
      // Here you should implement your logic to crop the image into puzzle pieces
      // For the sake of example, I'm just generating random colors for puzzle pieces

      List<Uint8List> pieces = List.generate(9, (index) {
        final color = Color.fromARGB(255, index * 20, index * 30, index * 40);
        return Uint8List.fromList(List.generate(1000, (index) => color.value & 0xFF));
      });

      return pieces;
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
                margin: EdgeInsets.all(4),
                color: puzzleState[index] == 0 ? Colors.grey : Colors.blue,
                child: Center(
                  child: Image.memory(puzzlePieces[puzzleState[index]]),
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
