import 'package:flutter/material.dart';
import 'dart:math';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LightPage(),
    );
  }
}

class LightPage extends StatefulWidget {
  LightPage({Key key}) : super(key: key);

  @override
  _LightPageState createState() {
    return _LightPageState();
  }
}

class _LightPageState extends State<LightPage> {
  double _size = 20;
  double _topPos = -1;
  double _leftPos = -1;

  List<List<Color>> _colorMatrix = new List<List<Color>>();
  Random _rand = new Random();

  Color _generateRandColor() => Color.fromARGB(255, _rand.nextInt(255), _rand.nextInt(255), _rand.nextInt(255));
  GlobalKey _keyLightPage = GlobalKey();

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

//    return Scaffold(
//      appBar: AppBar(
//        title: Text(''),
//      ),
//      body: _buildBody(screenWidth, screenHeight),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );

//    return _buildBody(screenWidth, screenHeight);

    return Listener(
        onPointerMove: (event) => _handlePointerMove(event),
        onPointerDown: (event) => _handlePointerMove(event),
        child: _buildBody(screenWidth, screenHeight),
//        key: _keyLightPage,
    );
  }

  Widget _buildBody(double width, double height) {

    int rowsCount = height ~/ _size;
    int columnsCount = width ~/ _size;

//    int rowsCount = 1;
//    int columnsCount = 1;


    for (var i = 0; i < rowsCount; i++) {
      List<Color> row = new List<Color>();

      for (var j = 0; j < columnsCount; j++) {
        row.add(_generateRandColor());
      }

      _colorMatrix.add(row);
    }

    List<Widget> rows = new List<Widget>(rowsCount);
    for (int i = 0; i < rowsCount; i++) {

      List<Widget> cols = new List<Widget>(columnsCount);
      for(int j = 0; j < columnsCount; j++) {
        cols[j] = _buildItem(i, j);
      }
      rows[i] = new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: cols,
//        key: _keyLightPage,
      );
    }

    return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rows,
    );
  }

  Widget _buildItem(int i, int j) {

    Container itemContainer;
    if (i == 0 && j == 0) {
      itemContainer = Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: _colorMatrix[i][j],
          border: Border.all(width: 1.0, color: Colors.black),
        ),
        key: _keyLightPage,
      );
    } else {
      itemContainer = Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: _colorMatrix[i][j],
          border: Border.all(width: 1.0, color: Colors.black),
        ),
      );
    }

    return itemContainer;
  }

  void _handlePointerMove(event) {
//    print('_handlePointerMove:' + (event).toString());

    if (_topPos == -1 || _leftPos == -1) {
      final RenderBox renderBoxLightPage = _keyLightPage.currentContext.findRenderObject();
      final posLightPage = renderBoxLightPage.localToGlobal(Offset.zero);
//      final sizeRed = renderBoxLightPage.size;
//      print("SIZE of LightPage: $sizeRed");
//      print("POSITION of LightPage: $posLightPage");
      _leftPos = posLightPage.dx;
      _topPos = posLightPage.dy;
    }

    int x = ((event.position.dy - _topPos) ~/ _size);
    int y = ((event.position.dx - _leftPos) ~/ _size);
    _colorMatrix[x][y] = _generateRandColor();

    setState(() {});

//    print('_handlePointerMove:' + x.toString() + ", " + y.toString());
  }
}
