import 'dart:async';

import './bluetoothconnect.dart';

class RECIVE {
  static const SERVICE = 'f2f9a4de-ef95-4fe1-9c2e-ab5ef6f0d6e9';
  static const INT = 'e376bd46-0d9a-44ab-bb71-c262d06f60c7';
  static const BOOL = '5c409aab-50d4-42c2-bf57-430916e5eaf4';
  static const STRING = '9e8fafe1-8966-4276-a3a3-d0b00269541e';
}

class SEND {
  static const SERVICE = '1450dbb0-e48c-4495-ae90-5ff53327ede4';
  static const INT = 'ec693074-43fe-489d-b63b-94456f83beb5';
  static const BOOL = '45db5a06-5481-49ee-a8e9-10b411d73de7';
  static const STRING = '9393c756-78ea-4629-a53e-52fb10f9a63f';
}

class BluetoothController extends BluetoothConnector {
  double _sliderValue = 0;
  String _textfieldValue = "Hi";
  bool _buttonState = false;

  var _textStream = StreamController<String>();
  var _numberStream = StreamController<int>();
  var _boolStream = StreamController<bool>();

  @override
  sendInit() async {
    await sendSliderValue(_sliderValue);
    await sendTextFieldValue(_textfieldValue);
    await sendButtonPressed(_buttonState);
    subscribeServiceString(RECIVE.STRING, _textStream);
    subscribeServiceInt(RECIVE.INT, _numberStream);
    subscribeServiceBool(RECIVE.BOOL, _boolStream);
  }

  @override
  close() async {
    //_textStream.close();
    //_numberStream.close();
    //_boolStream.close();
  }

  BluetoothController() : super();

  sendSliderValue(double slider) async {
    _sliderValue = slider;
    int value = (slider * 100).toInt();
    await writeServiceInt(SEND.INT, value, false);
  }

  sendTextFieldValue(String text) async {
    _textfieldValue = text;
    await writeServiceString(SEND.STRING, text, true);
  }

  sendButtonPressed(bool state) async {
    _buttonState = state;
    await writeServiceBool(SEND.BOOL, state, true);
  }

  Stream<String> getStringStream() {
    return _textStream.stream;
  }

  Stream<int> getIntStream() {
    return _numberStream.stream;
  }

  Stream<bool> getBoolStream() {
    return _boolStream.stream;
  }
}