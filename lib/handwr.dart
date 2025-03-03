import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:kidsbook/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canvas Drawing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DrawingPagee(),
    );
  }
}

class DrawingPagee extends StatefulWidget {
  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPagee> {
  GlobalKey _globalKey = GlobalKey();
  List<Offset?> _points = <Offset?>[];
  Image? _overlayImage;
  String _randomLetter = '';
  String _indexNumber = '';


   List<String> a=["ക","അ","ആ","ഇ","ഉ",
     "എ","ഏ","ഒ","ക","ഖ","ഗ","ഘ","ങ","ച","ഛ","ജ","ഝ","ഞ","ട","ഠ",
     "ഡ","ഢ","ണ","ത","ഥ","ദ","ധ","ന","പ","ഫ","ബ","ഭ","മ","യ","ര",
     "റ","ല","ള","ഴ","വ","ശ","ഷ","സ","ഹ"];
   List<String> aindex=["3349","3333","3334","3335","3337",
     "3342","3343","3346","3349","3350","3351","3352","3353","3354","3355","3356","3357","3358","3359","3360",
     "3361","3362","3363","3364","3365","3366","3367","3368","3370","3371","3372","3373","3374","3375","3376",
     "3377","3378","3379","3380","3381","3382","3383","3384","3385"];


  void _setRandomLetterAndIndex() {
    _randomLetter = a[Random().nextInt(a.length)];
    int index = a.indexOf(_randomLetter);
    _indexNumber = aindex[index];
  }

  @override
  void initState() {
    super.initState();
    _loadOverlayImage();
    _setRandomLetterAndIndex();
  }

  Future<void> _loadOverlayImage() async {
    // Load your image here
    // Example:
    // ByteData data = await rootBundle.load('assets/image.png');
    // final Uint8List bytes = data.buffer.asUint8List();
    // setState(() {
    //   _overlayImage = Image.memory(bytes);
    // });
  }

  Future<void> _saveCanvas() async {
    RenderRepaintBoundary? boundary =
    _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return;

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    Uint8List pngBytes = byteData.buffer.asUint8List();

    // Replace the URL with your server endpoint to save the image
    String url = 'https://your-server-endpoint.com/save-image';
    await http.post(Uri.parse(url), body: pngBytes);

    setState(() {
      _points.clear(); // Clear points after saving
    });
  }
  Future<String> _saveCanvasToString(indexNumber) async {
    RenderRepaintBoundary? boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return '';

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return '';

    Uint8List pngBytes = byteData.buffer.asUint8List();
    String base64Image = base64Encode(pngBytes);

    print(base64Image);
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    final urls = Uri.parse('$url/handwriting/');
    try {
      final response = await http.post(urls, body: {
        'image':base64Image,
        'inum':_indexNumber,


      });
      if (response.statusCode == 200) {


          String status = jsonDecode(response.body)['status'];
          String code = jsonDecode(response.body)['code'];
          if (code== _indexNumber) {

            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Congratulations!'),
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
            _resetCanvas();

            // Navigator.push(context, MaterialPageRoute(
            //   builder: (context) => MyNewHomePage(title: "Home"),));
          }
          else
            {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Wrong!'),
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
              _resetCanvas();
            }
      }
      else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    }
    catch (e){
      Fluttertoast.showToast(msg: e.toString());
    }

    return base64Image;
  }

  void _resetCanvas() {
    setState(() {
      _points.clear();
    });
    _setRandomLetterAndIndex();
  }
  String _getIndexNumber() {
    String randomLetter = a[Random().nextInt(a.length)];
    int index = a.indexOf(randomLetter);
    return aindex[index];
  }

  @override
  Widget build(BuildContext context) {
    // String randomLetter = a[Random().nextInt(a.length)];
    // int index = a.indexOf(randomLetter);
    // String indexNumber = aindex[index];
    return Scaffold(
      appBar: AppBar(
        title: Text("Hand Writing"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed:(){
              _saveCanvasToString(_indexNumber);
            }
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetCanvas,
          ),
        ],
      ),
      body: Stack(
        children: [


         Text(_randomLetter, style: TextStyle(fontSize: 50),),


          _overlayImage != null
              ? Positioned.fill(child: _overlayImage!)
              : SizedBox(), // Overlay image
          Center(
            child: RepaintBoundary(
              key: _globalKey,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    RenderBox? renderBox =
                    context.findRenderObject() as RenderBox?;
                    if (renderBox != null)
                      _points.add(renderBox.globalToLocal(details.globalPosition));
                  });
                },
                onPanEnd: (details) => _points.add(null),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: DrawingPainter(points: _points),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;

  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
