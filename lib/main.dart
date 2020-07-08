import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Battery'),
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
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  // Get battery level.
  int _batteryLevel = 100;
  Future<void> _getBatteryLevel() async {
    int batteryLevel;
    String batteryLevelText;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel=result;
    } on PlatformException catch (e) {
      batteryLevelText = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }
  @override
  Widget build(BuildContext context) {
    _getBatteryLevel();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          Text(_batteryLevel.toString()+'%'),
            if(_batteryLevel<=10)
            TimerWidget(),
      Container(
        width: MediaQuery.of(context).size.width*0.40,
        height: MediaQuery.of(context).size.height*0.60,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 8,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: WaveWidget(
            duration:21,
            config: CustomConfig(
              gradients: [
                if(_batteryLevel<=100&&_batteryLevel>60)
                [Colors.green, Colors.amberAccent],
                [Colors.green, Colors.amberAccent],
                [Colors.amberAccent, Colors.lightGreen],
                [Colors.green, Colors.lightGreen],
                if(_batteryLevel<=60&&_batteryLevel>20)
                [Colors.orange, Colors.amberAccent],
                if(_batteryLevel<=20&&_batteryLevel>0)
                  [Colors.red, Colors.red],
              ],
              durations: [35000, 19440, 10800, 6000],
              heightPercentages:
              [1-_batteryLevel/100, 1-_batteryLevel/100,
                1-_batteryLevel/100, 1-_batteryLevel/100],
              blur: MaskFilter.blur(BlurStyle.inner, 5),
              gradientBegin: Alignment.centerLeft,
              gradientEnd: Alignment.centerRight,
            ),
            waveAmplitude: 1,
            backgroundColor: Colors.transparent,
            size: Size(double.infinity, double.infinity)

        ),
      ),
          ],
        ),
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  State createState() => new _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer _timer;
  int _seconds = 600;
  String timeFormat="10:00";
  @override
  void initState() {
    startTimer();
    super.initState();
  }
void startTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    } else {
      _timer = new Timer.periodic(
        const Duration(seconds: 1),
            (Timer timer) => setState(
              () {
            if (_seconds < 1) {
              timer.cancel();
            } else {
              _seconds = _seconds - 1;
            }
            int min=(_seconds/60).floor();
            int sec =(_seconds%60);
            timeFormat=min.toString()+":"+sec.toString();
          },
        ),
      );
    }
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return new Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              startTimer();
            },
            child: Text("start"),
          ),
          Text(timeFormat)
        ],
    );

  }
}
