import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'repeating channel id',
        'repeating channel name',
        'repeating description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
        'repeating body', RepeatInterval.EveryMinute, platformChannelSpecifics);
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
                Text(
                  'Tesla Model 3',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            decoration: BoxDecoration(color: Colors.blue),
          )
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
