import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:gridsmartr/car_settings.dart';
import 'package:gridsmartr/scheduler.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationController.add(payload);
  });
  runApp(MyApp());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final StreamController<String> selectNotificationController =
    StreamController<String>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      title: 'GridSmartr',
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        enableLights: true);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Charge Modification',
        'There is high power use in your area. '
            'Your charging will be shifted 30 mintues to ease the load.',
        platformChannelSpecifics,
        payload: 'item x');
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return PlatformScaffold(
      android: (_) => MaterialScaffoldData(
          drawer: Drawer(
              child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage('assets/portrait.jpg'),
                  radius: 50,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Brad\'s',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      'Tesla',
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                    Text(
                      'Model 3',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            leading: Icon(
              Icons.power,
              size: 48,
            ),
            subtitle: Text('Grid Status'),
            title: Text(
              'HIGH',
              style: TextStyle(
                  color: Colors.red, fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              size: 48,
            ),
            title: Text('Los Angeles Convention Center'),
          ),
          ListTile(
            leading: Icon(
              Icons.directions_car,
              size: 48,
            ),
            title: Text('Car Settings'),
            onTap: () => Navigator.push(
                context,
                platformPageRoute(
                    context: context, builder: (context) => CarSettings())),
          ),
          ListTile(
            leading: Icon(
              Icons.calendar_view_day,
              size: 48,
            ),
            title: Text('Scheduler'),
            onTap: () => Navigator.push(
                context,
                platformPageRoute(
                    context: context, builder: (context) => Schedule())),
          ),
          PlatformButton(
            child: Text('Draw Notification'),
            onPressed: () => showNotification(),
          ),
        ],
      ))),
      appBar: PlatformAppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Charge Status',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: 90,
              height: 90,
              child: PieChart(PieChartData(
                borderData: FlBorderData(show: false),
                centerSpaceRadius: 20,
                startDegreeOffset: 180,
                sections: [
                  PieChartSectionData(
                      value: 25,
                      color: Colors.grey,
                      showTitle: false,
                      radius: 5),
                  PieChartSectionData(
                    value: 75,
                    color: Colors.green,
                    title: '75%',
                    radius: 10,
                    showTitle: false,
                  ),
                ],
              )),
            ),
            Text(
              'Remaining Time',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '2:30',
              style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: WebView(
                initialUrl: Uri.dataFromString(
                        '<iframe width="400" height="400" src="https://xyz.here.com/viewer/?project_id=348ec274-36f6-4a96-b121-6b6af803e87a" frameborder="0"></iframe>',
                        mimeType: 'text/html')
                    .toString(),
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
