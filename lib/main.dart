import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Item {
  Item({this.itemId});
  final String itemId;

  StreamController<Item> _controller = StreamController<Item>.broadcast();
  Stream<Item> get onChanged => _controller.stream;

  String _status;
  String get status => _status;
  set status(String value) {
    _status = value;
    _controller.add(this);
  }

  /*
  static final Map<String, Route<void>> routes = <String, Route<void>>{};
  Route<void> get route {
    final String routeName = '/detail/$itemId';
    return routes.putIfAbsent(
      routeName,
          () => MaterialPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (BuildContext context) => DetailPage(itemId),
      ),
    );
  }

   */
}

final Map<String, Item> _items = <String, Item>{};
Item _itemForMessage(Map<String, dynamic> message) {
  final dynamic data = message['data'] ?? message;
  final String itemId = data['id'];
  final Item item = _items.putIfAbsent(itemId, () => Item(itemId: itemId))
    ..status = data['status'];
  return item;
}

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
  int gridPoints;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _homeScreenText = "Waiting for token...";

  void _showItemDialog(Map<String, dynamic> message) {
    showPlatformDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context, _itemForMessage(message)),
    ).then((value) {
      if (value) {
        setState(() {
          gridPoints = gridPoints + 100;
        });
      }
    });
  }

  Widget _buildDialog(BuildContext context, Item item) {
    return PlatformAlertDialog(
      title: Icon(
        Icons.error,
        size: 64,
        color: Colors.red,
      ),
      content: Text(
        'The power grid in your area is heavily loaded!  '
        'We are delaying the charging of your Tesla for the next 30 minutes. '
        'You will receive 100 GridPoints for accepting.',
        style: TextStyle(fontSize: 18),
      ),
      actions: <Widget>[
        PlatformDialogAction(
          child: const Text('Accept'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        PlatformDialogAction(
          child: const Text('Deny'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ],
    );
  }

  @override
  initState() {
    super.initState();
    gridPoints = 500;
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //_navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });
  }

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
              Icons.stars,
              color: Colors.yellow[600],
              size: 48,
            ),
            title: Text(
              gridPoints.toString(),
              style: TextStyle(fontSize: 36, color: Colors.green),
            ),
            subtitle: Text('GridPoints'),
          ),
          ListTile(
            leading: Icon(
              Icons.power,
              size: 48,
            ),
            subtitle: Text('Grid Load Status'),
            title: Text(
              'HIGH',
              style: TextStyle(
                  color: Colors.red, fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              size: 48,
            ),
            title: Text('Los Angeles Convention Center'),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.directions_car,
              size: 48,
            ),
            title: Text('Car Settings'),
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
              child: Stack(
                children: <Widget>[
                  Center(
                      child: Text(
                    '75%',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  PieChart(
                    PieChartData(
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
                          radius: 20,
                          showTitle: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
