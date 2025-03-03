import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: SolvePuzzlePage(
      imageUrl: 'https://example.com/your_image.jpg', // Insert your image URL here
    ),
  ));
}

class SolvePuzzlePage extends StatefulWidget {
  final String imageUrl;

  const SolvePuzzlePage({required this.imageUrl});

  @override
  _SolvePuzzlePageState createState() => _SolvePuzzlePageState();
}

class _SolvePuzzlePageState extends State<SolvePuzzlePage> {
  late ui.Image originalImage;
  late List<int> shuffledIndices;
  late Random random;
  List<Uint8List> puzzlePieces = [];

  @override
  void initState() {
    super.initState();
    loadAndShuffleImage();
  }

  Future<ui.Image> loadImage(String imagePath) async {
    try {
      var response = await http.get(Uri.parse(imagePath));
      Uint8List bytes = response.bodyBytes;
      return await decodeImageFromList(bytes);
    } catch (e) {
      print('Error loading image: $e');
      throw Exception('Failed to load image');
    }
  }

  Future<List<Uint8List>> cropImage(ui.Image image, int rows, int cols) async {
    final imageWidth = image.width;
    final imageHeight = image.height;

    final pieceWidth = imageWidth ~/ cols;
    final pieceHeight = imageHeight ~/ rows;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawImage(image, Offset.zero, Paint());

    List<Uint8List> pieces = [];

    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        final offset = Offset(x * pieceWidth.toDouble(), y * pieceHeight.toDouble());
        final rect = Rect.fromLTWH(offset.dx, offset.dy, pieceWidth.toDouble(), pieceHeight.toDouble());
        final imageByteData = await recorder
            .endRecording()
            .toImage(pieceWidth, pieceHeight)
            .then((image) => image.toByteData(format: ui.ImageByteFormat.rawRgba));

        final imageBytes = imageByteData!.buffer.asUint8List();

        pieces.add(imageBytes);
      }
    }

    return pieces;
  }

  void loadAndShuffleImage() async {
    random = Random();
    try {
      originalImage = await loadImage(widget.imageUrl);
      final rows = 4; // Specify the number of rows
      final cols = 4; // Specify the number of columns
      shuffledIndices = List.generate(rows * cols, (index) => index)..shuffle(random);
      List<Uint8List> croppedPieces = await cropImage(originalImage, rows, cols);
      puzzlePieces = shuffledIndices.map((index) => croppedPieces[index]).toList();
      setState(() {});
    } catch (e) {
      print('Error loading and shuffling image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Solver'),
      ),
      body: Center(
        child: puzzlePieces.isNotEmpty
            ? GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: originalImage.width ~/ 4, // Assuming the puzzle grid is 4x4
          ),
          itemCount: puzzlePieces.length,
          itemBuilder: (BuildContext context, int index) {
            return Image.memory(puzzlePieces[index]);
          },
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}
