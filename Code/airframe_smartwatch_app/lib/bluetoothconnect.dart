import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:rxdart/rxdart.dart';
import 'package:get_it/get_it.dart';

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import './settings.dart';
import './ble.dart';

GetIt getIt = GetIt.instance;
int counter = 0;

class BluetoothConnect extends StatelessWidget {
  final bluetooth = getIt.get<BluetoothController>();
  final snackbar = getIt.get<SnackbarController>();

  BluetoothConnect({Key key, String deviceName}) : super(key: key) {
    bluetooth.setTargetDeviceName(deviceName);

  }

  @override
  Widget build(BuildContext context) {
    snackbar.stream.listen(
          (snack) {
        if (snack != null) {
         ScaffoldMessenger.of(context).showSnackBar(snack);
        }
      },
    );

    return StreamBuilder<int>(
      stream: bluetooth.stream,
      initialData: 1,
      builder: (c, snapshot) {
        if (snapshot.data == 1) {
          return IconButton(
            icon: Icon(Icons.bluetooth),
            iconSize: 32,
            onPressed: () => bluetooth.startScan(),
          );
        } else if (snapshot.data == 2) {
          return IconButton(
            icon: Icon(Icons.bluetooth_searching),
            iconSize: 32,
            onPressed: () => bluetooth.stopScan(),
          );
        } else if (snapshot.data == 3) {
          return IconButton(
            icon: Icon(Icons.bluetooth_connected),
            iconSize: 32,
            onPressed: () => bluetooth.disconnect(),
          );
        } else {
          return IconButton(
            icon: Icon(Icons.bluetooth),
            iconSize: 32,
            onPressed: () => bluetooth.startScan(),
          );
        }
      },
    );
  }
}

class SnackbarController {
  BehaviorSubject<Widget> _controller;
  String _lastMsg = "";

  SnackbarController() {
    _controller = BehaviorSubject.seeded(null);
  }

  Stream<Widget> get stream => _controller.stream;
  Widget get current => _controller.value;

  openSnackbar(Widget widget, String msg) {
    if (msg != _lastMsg) {
      _lastMsg = msg;
      _controller.add(widget);
    }
  }
}

class BluetoothConnector {
  final settings = getIt.get<ConfigNameController>();
  final snackbar = getIt.get<SnackbarController>();

  BehaviorSubject<int> _controller = BehaviorSubject.seeded(0);

  BluetoothDevice device;
  String targetDeviceName;

  bool isBtAvalible = false;
  bool isScanning = false;
  bool isConnected = false;
  bool isWriting = false;

  String _lastSnackbar = "";

  List<MapEntry<String, List<int>>> msgStack = List();
  HashMap<String, BluetoothCharacteristic> map;

  sendInit() async {}
  close() async {}

  BluetoothConnector() {
    settings.stream.listen((data) {
      targetDeviceName = data;
    });
    initDevice();
  }

  Stream<int> get stream => _controller.stream;
  int get current => _controller.value;

  startScan() async {
    if (!isScanning) {
      (await FlutterBlue.instance.connectedDevices).forEach((connected) {
        print('Connected: ${connected.name}');
        setDevice(connected);
      });
      FlutterBlue.instance.startScan(timeout: Duration(seconds: 16));
    }
  }

  stopScan() async {
    if (isScanning) {
      FlutterBlue.instance.stopScan();
    }
  }

  disconnect() async {
    if (device != null) {
      showSnackbar(Icons.bluetooth_disabled, 'Disonnected from ${device.name}');
      counter=0;
      device.disconnect();
      close();

      map = null;
      device = null;
      isConnected = false;
      isScanning = false;

      calcState();
    }
  }

  setTargetDeviceName(String name) {
    targetDeviceName = name;
  }

  Future<void> initDevice() async {
    FlutterBlue.instance.state.listen((data) {
      device.requestMtu(512);
      bool isAvalible = (data == BluetoothState.on);
      isBtAvalible = isAvalible;
      if (isAvalible) {
        showSnackbar(Icons.bluetooth, 'Bluetooth is online again!');
      }
      calcState();
    });

    FlutterBlue.instance.isScanning.listen((data) {
      isScanning = data;
      print(isScanning);
      calcState();
    });

    (await FlutterBlue.instance.connectedDevices).forEach((connected) {
      print('Connected: ${connected.name}');
      setDevice(connected);
    });
    FlutterBlue.instance.scanResults.listen((scans) {
      for (var scan in scans) {
        setScanResult(scan);
      }
    });
  }

  void calcState() {
    int stage = 1; // waiting for scanning
    stage = (isScanning) ? 2 : stage; // searching
    stage = (isConnected) ? 3 : stage; // connected
    stage = (!isBtAvalible) ? 0 : stage; // not avalible
    print(stage);
    _controller.add(stage);
  }

  Future<void> setScanResult(ScanResult scan) async {
    BluetoothDevice _device = scan.device;
    await setDevice(_device);
  }

  Future<void> setDevice(BluetoothDevice _device) async {
    if (_device.name == targetDeviceName && device == null) {
      print(_device.name);

      await _device.disconnect();
      await _device.connect();

      map = new HashMap<String, BluetoothCharacteristic>();

      if(counter == 0){
        showSnackbar(Icons.bluetooth, 'Connected to ${_device.name}');
      }
      counter++;


      device = _device;
      isConnected = true;
      calcState();

      List<BluetoothService> services = await _device.discoverServices();

      for (var service in services) {
        for (var c in service.characteristics) {
          map[c.uuid.toString()] = c;
          bool read = c.properties.read;
          bool write = c.properties.write;
          bool notify = c.properties.notify;
          bool indicate = c.properties.indicate;
          String properties = "";
          properties += (read ? "R" : "") + (write ? "W" : "");
          properties += (notify ? "N" : "") + (indicate ? "I" : "");
          print('${c.serviceUuid} ${c.uuid} [$properties] found!');

          if (notify || indicate) {
            await c.setNotifyValue(true);
          }
        }
      }

      await sendInit();
    }
  }

  subscribeService<T>(String characteristicGuid, StreamController<T> controller,
      T Function(List<int>) parse) {
    if (map != null) {
      var characteristic = map[characteristicGuid];
      if (characteristic != null) {
        Stream<List<int>> listener = characteristic.value;

        listener.listen((onData) {
          if (!controller.isClosed) {
            T value = parse(onData);
            controller.sink.add(value);
          }
        });
      }
    }
  }

  subscribeServiceString(
      String guid, StreamController<String> controller) async {
    var parse = (List<int> data) => String.fromCharCodes(data);
    subscribeService<String>(guid, controller, parse);
  }

  void subscribeServiceInt(String guid, StreamController<int> controller) {
    var parse = (List<int> data) => bytesToInteger(data);
    subscribeService<int>(guid, controller, parse);
  }

  void subscribeServiceBool(String guid, StreamController<bool> controller) {
    var parse = (List<int> data) {
      if (data.isNotEmpty) {
        return data[0] != 0 ? true : false;
      }
      return false;
    };
    subscribeService<bool>(guid, controller, parse);
  }

  Future<List<int>> readService(String characteristicGuid) async {
    if (map != null) {
      BluetoothCharacteristic characteristic = map[characteristicGuid];
      print(map);
      if (characteristic != null) {
        return await characteristic.read();
      }
    }
    return List<int>();
  }

  Future<void> writeServiceInt(
      String characteristicGuid, int value, bool importand) async {
    int byte1 = value & 0xff;
    int byte2 = (value >> 8) & 0xff;
    await writeService(characteristicGuid, [byte1, byte2], importand);
  }

  Future<void> writeServiceString(
      String characteristicGuid, String msg, bool importand) async {
    await writeService(characteristicGuid, utf8.encode(msg), importand);
  }

  Future<void> writeServiceBool(
      String characteristicGuid, bool value, bool importand) async {
    int byte = value ? 0x01 : 0x00;
    await writeService(characteristicGuid, [byte], importand);
  }

  Future<void> writeService(
      String characteristicGuid, List<int> data, bool importand) async {
    // print("$characteristicGuid $isWriting");
    if (!isWriting) {
      isWriting = true;
      await writeCharacteristics(characteristicGuid, data);

      if (msgStack.length > 0) {
        for (int i = 0; i < msgStack.length; i++) {
          await writeCharacteristics(msgStack[i].key, msgStack[i].value);
        }
        msgStack = List();
      }
      isWriting = false;
    } else if (importand) {
      msgStack.add(MapEntry(characteristicGuid, data));
    }
  }

  Future<void> writeCharacteristics(
      String characteristicGuid, List<int> data) async {
    if (map != null) {
      var characteristic = map[characteristicGuid];
      if (characteristic != null) {
        await characteristic.write(data);
        return;
      }
    }
  }

  void showSnackbar(IconData icon, String msg) {
    if (msg != _lastSnackbar) {
      snackbar.openSnackbar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Row(
            children: <Widget>[
              Icon(icon),
              Text(msg),
            ],
          ),
        ),
        msg,
      );
    }
    _lastSnackbar = msg;
  }

  int bytesToInteger(List<int> bytes) {
    var value = 0;
    for (var i = 0, length = bytes.length; i < length; i++) {
      value += bytes[i] * pow(256, i);
    }
    return value;
  }
}