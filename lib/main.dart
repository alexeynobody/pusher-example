import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pusher_websocket_flutter/pusher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pusher Example App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Channel _channel;

  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    initPusher();
  }

  Future<void> initPusher() async {
    try {
      // change from settings in Pusher
      await Pusher.init(
        "Your App Key here",
        PusherOptions(cluster: "eu"),
        enableLogging: true,
      );
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onTestEvent(Event event) {
    DateTime now = DateTime.now();

    var eventText =
        '$now Get event: name - ${event.event}, channel - ${event.channel}, data - ${event.data}';
    _textEditingController.text =
        '\n\n' + eventText + _textEditingController.text;

    debugPrint(eventText);
  }

  void _connectToPusherButtonTap() {
    Pusher.connect(onConnectionStateChange: (connectionState) async {
      debugPrint('Connected to Pusher');
      _channel = await Pusher.subscribe('main');
      await _channel.bind('test-event', _onTestEvent);
    }, onError: (x) {
      debugPrint("Error: ${x.message}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pusher example app'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            FlatButton.icon(
              color: Colors.blue,
              icon: Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: _connectToPusherButtonTap,
              label: Text(
                'Connect to Pusher',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextField(
              controller: _textEditingController,
              readOnly: true,
              obscureText: false,
              minLines: 10,
              maxLines: 30,
              decoration: InputDecoration(
                fillColor: Colors.grey,
                hoverColor: Colors.grey,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  left: 15,
                  bottom: 11,
                  top: 11,
                  right: 15,
                ),
                hintText: '',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
