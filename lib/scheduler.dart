import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  Schedule({Key key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  bool sumVal = false;
  bool winVal = false;

  final leftSection = new Container();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scheduler"),
        centerTitle: true,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Text("Summer"),
                  Card(
                    child: Text('12am - 7am'),
                  ),
                  Card(
                    child: Text('7am - 7pm'),
                  ),
                  Card(
                    child: Text('7pm - 12am'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Text("Winter"),
                  Card(
                    child: Text('12am - 7am'),
                  ),
                  Card(
                    child: Text('7am - 7pm'),
                  ),
                  Card(
                    child: Text('7pm - 12am'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
