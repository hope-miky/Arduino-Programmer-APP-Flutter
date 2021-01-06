import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('flutter.native/helper');

  String _responseFromNativeCode = 'Waiting for Response...';
  final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));

  @override
  initState() {
    super.initState();

    // Platforms -> Dart
    platform.setMethodCallHandler(_platformCallHandler);
  }

  Future<void> responseFromNativeCode() async {
    String response = "";
    try {
      final String result = await platform.invokeMethod('helloFromNativeCode');
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
    setState(() {
      _responseFromNativeCode = response;
    });
  }

  Future<void> requestPermission() async {
    String response = "";
    try {
      final String result = await platform.invokeMethod('requestPermission');
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to reqest permission.";
    }
    setState(() {
      _responseFromNativeCode = response;
    });
  }

  Future<void> uploadToBoard() async {
    String response = "";
    try {
      final String result = await platform.invokeMethod('uploadToBoard');
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to reqest permission.";
    }
    setState(() {
      _responseFromNativeCode = response;
    });
  }


  Future<dynamic> _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'callMe':
        print('call callMe : arguments = ${call.arguments}');
        setState(() {
          _responseFromNativeCode = call.arguments.toString();
        });
        return Future.value('called from platform!');
    //return Future.error('error message!!');
      default:
        print('Unknowm method ${call.method}');
        throw MissingPluginException();
        break;
    }
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Check permission"),
              onPressed: requestPermission,
            ),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              _responseFromNativeCode,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: uploadToBoard,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
