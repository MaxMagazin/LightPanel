import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:english_words/english_words.dart';
import 'dart:io';


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

  int _rowsCount = -1;
  int _columnsCount = -1;

  int _tappedX = -1;
  int _tappedY = -1;

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

    return GestureDetector(
        onLongPress: _handleLongPress,
        child: Listener(
          onPointerMove: (event) => _handlePointerMove(event),
          onPointerDown: (event) => _handlePointerMove(event),
          onPointerUp: _handlePointerUp(),
          child: _buildBody(screenWidth, screenHeight),
        )
    );
  }

  Widget _buildBody(double width, double height) {

    _rowsCount = height ~/ _size;
    _columnsCount = width ~/ _size;

    for (var i = 0; i < _rowsCount; i++) {
      List<Color> row = new List<Color>();

      for (var j = 0; j < _columnsCount; j++) {
//        row.add(_generateRandColor());
        row.add(Colors.grey);
      }

      _colorMatrix.add(row);
    }

    List<Widget> rows = new List<Widget>(_rowsCount);
    for (int i = 0; i < _rowsCount; i++) {

      List<Widget> cols = new List<Widget>(_columnsCount);
      for(int j = 0; j < _columnsCount; j++) {
        cols[j] = _buildItem(i, j);
      }
      rows[i] = new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: cols,
      );
    }

    return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rows,
    );
  }

  Widget _buildItem(int i, int j) {

    Container itemContainer;

    //first element with _keyLightPage (to track the offsets), all others without
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

    _tappedX = x;
    _tappedY = y;

//    print('_handlePointerMove:' + x.toString() + ", " + y.toString());
  }

  _handlePointerUp() {
//    print('_handlePointerUp:' + _tappedX.toString() + ", " + _tappedY.toString());
  }

  void _handleLongPress() {
    print('_handleLongPress:' );

    _navigateToSettings(context);

//    int x = _tappedX;
//    int y = _tappedY;
//
//    for (; x >= 0 - _columnsCount || _tappedX + _tappedX - x <= _rowsCount + _columnsCount || y >= 0 || _tappedY + _tappedY - y <= _columnsCount;) {
//
//      new Future.delayed(const Duration(milliseconds: 1000), () => _updateLightPage(x,y));
//
//      x--;
//      y--;
//    }
  }

  void _updateCell(int x, int y) {
    if (x >= 0 && x < _rowsCount && y >= 0 && y < _columnsCount) {
      _colorMatrix[x][y] = _generateRandColor();
    }
  }

  void _navigateToSettings(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen())
    );

    print('settings result: ' + result.toString());
  }

  void _updateLightPage(int x, int y) {
    setState(() {

      // to the top
      _updateCell(x, _tappedY);

      //to the bottom
      int bottomX = _tappedX + _tappedX - x;
      _updateCell(bottomX, _tappedY);

      //to the left
      _updateCell(_tappedX, y);

      //to the right
      int rightY = _tappedY + _tappedY - y;
      _updateCell(_tappedX, rightY);

      //top left
      int xx = x + 1;
      for (int yy = _tappedY - 1; yy > y; yy--) {
        _updateCell(xx, yy);
        if (xx < _tappedX) {
          xx++;
        }
      }

      //top right
      xx = x + 1;
      for (int yy = _tappedY + 1; yy < rightY; yy++) {
        _updateCell(xx, yy);
        if (xx < _tappedX) {
          xx++;
        }
      }

      //bottom right
      xx = bottomX - 1;
      for (int yy = _tappedY + 1; yy < rightY; yy++) {
        _updateCell(xx, yy);
        if (xx > _tappedX) {
          xx--;
        }
      }

      //bottom left
      xx = bottomX - 1;
      for (int yy = _tappedY - 1; yy > y; yy--) {
        _updateCell(xx, yy);
        if (xx > _tappedX) {
          xx--;
        }
      }
    });
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: RandomWords(),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {

  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 16.0);

  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      onTap: () {
        Navigator.pop(context, pair.asPascalCase);
      },
    );
  }
}
