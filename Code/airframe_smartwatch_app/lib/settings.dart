import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';
import 'package:get_it/get_it.dart';
import 'ble.dart';

GetIt getIt = GetIt.instance;

BluetoothController bluetoothController = BluetoothController();

class ConfigNameController {
  BehaviorSubject<String> _controller;

  ConfigNameController(String deviceName) {
    _controller = BehaviorSubject.seeded(deviceName);
  }

  Stream<String> get stream => _controller.stream;
  String get current => _controller.value;

  setDeviceName(String name) {
    _controller.add(name);
  }
}

class SettingsButton extends StatefulWidget {
  @override
  createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
  final name = getIt.get<ConfigNameController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text("Settings", style: Theme.of(context).textTheme.headline6),
            ),
            IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(Icons.close),
              color: Theme.of(context).primaryColor,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(labelText: "Device Name"),
          initialValue: name.current,
          onFieldSubmitted: (String text) {
            name.setDeviceName(text);
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }
}