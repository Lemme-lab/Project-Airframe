import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'data.dart';
import 'globals.dart' as globals;
import 'dart:developer';

import 'package:flutter_blue/flutter_blue.dart';

class BluetoothIsolate {
  static void start() async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_isolateEntryPoint, receivePort.sendPort);
    final sendPort = await receivePort.first;

    // Start Bluetooth scanning by sending a message to the isolate.
    sendPort.send('startScan');
  }

  static void _isolateEntryPoint(SendPort sendPort) async {
    // Initialize Bluetooth
    final flutterBlue = FlutterBlue.instance;

    // Connect to the 'data' characteristic when a device is selected
    BluetoothDevice? connectedDevice;
    StreamSubscription? _readSubscription;

    // Start Bluetooth scanning
    flutterBlue.scan().listen((scanResult) async {
      log('Scan: $scanResult');
      if (scanResult.device.name == "Airframe-Watch") {
        sendPort.send(scanResult.device);

        // Wait for the connected device to be set before connecting
        await Future.delayed(Duration(milliseconds: 500));

        if (connectedDevice != null && scanResult.device == connectedDevice) {
          return;
        }

        if (connectedDevice != null) {
          await connectedDevice?.disconnect();
        }
        await scanResult.device.connect();
        final services = await scanResult.device.discoverServices();

        for (final service in services) {
          final characteristics = await service.characteristics;

          log('Devices: $connectedDevice');

          for (final characteristic in characteristics) {
            if (characteristic.uuid.toString() ==
                "0000fff1-0000-1000-8000-00805f9b34fb") {
              _readSubscription =
                  characteristic.value.listen((value) async {
                    final jsonStr = utf8.decode(value);
                    final data = receivedData.fromJson(json.decode(jsonStr));

                    globals.last_update = data.last_update;
                    globals.software_version = data.software_version;
                    globals.steps = data.steps;
                    globals.senors = data.senors;
                    globals.wireless = data.wireless;
                    globals.hardware_version = data.hardware_version;
                    globals.watch_type = data.watch_type;
                    globals.daily_progress = data.daily_progress;
                    globals.training_status = data.training_status;
                    globals.past_distance_day = data.past_distance_day;
                    globals.past_distance_month = data.past_distance_month;
                    globals.past_sleep = data.past_sleep;
                    globals.heart_Min = data.heart_Min;
                    globals.heart_Max = data.heart_Max;
                    globals.heart_AVG = data.heart_AVG;
                    globals.Oxy_Min = data.Oxy_Min;
                    globals.Oxy_Max = data.Oxy_Max;
                    globals.Oxy_AVG = data.Oxy_AVG;
                    globals.altitude = data.altitude;
                    globals.temperature = data.temperature;
                    globals.heartrate = data.heartrate;
                    globals.O2stand = data.O2stand;
                    globals.kcal = data.kcal;
                    globals.battery = data.battery;
                    globals.bpm = data.bpm;
                    globals.flash = data.flash;
                    globals.hours = data.hours;
                    globals.minutes = data.minutes;
                    globals.ram = data.ram;
                    globals.soc = data.soc;

                    sendPort.send(data);
                  });
              connectedDevice = scanResult.device;
              sendPort.send(connectedDevice);
            }
          }
        }
      }
    });

    sendPort.send('scanStarted');
  }
}

