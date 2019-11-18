import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CarSettings extends StatefulWidget {
  CarSettings({Key key}) : super(key: key);

  @override
  _CarSettingsState createState() => _CarSettingsState();
}

class _CarSettingsState extends State<CarSettings> {
  List<bool> isSelected;
  @override
  void initState() {
    isSelected = [false];
    super.initState();
  }

  bool _toggle1 = false;
  bool _toggle2 = false;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Car Settings'),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: SwitchListTile(
              title: const Text('Enable charging during peak times',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              value: _toggle1,
              onChanged: (bool value) {
                setState(() {
                  _toggle1 = value;
                });
              },
              secondary: const Icon(null),
            ),
          ),
          Center(
            child: SwitchListTile(
              title: const Text('Enable economy charging mode',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              value: _toggle2,
              onChanged: (bool value) {
                setState(() {
                  _toggle2 = value;
                });
              },
              secondary: const Icon(null),
            ),
          )
        ],
      ),
    );
  }
}
