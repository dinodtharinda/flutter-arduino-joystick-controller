// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../constants/constant.dart';

class BTService with ChangeNotifier {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult>? scanSubScription;
  BluetoothDevice? targetDevice;
  BluetoothCharacteristic? targetCharacteristic;
  bool _isLoading = false;
  String _connectionText = "";

  String get connectionText {
    return _connectionText;
  }

  bool get isLoading {
    return _isLoading;
  }

  void changeText(String text) {
    _connectionText = text;
notifyListeners();
  }

  void setIsLoading(bool state) {
    _isLoading = state;
    notifyListeners();

  }

  startScan() {
    setIsLoading(true);
    changeText("Start Scanning");
    stopScan();
    scanSubScription = flutterBlue.scan().listen((scanResult) {
      if (scanResult.device.name == Constants.TARGET_DEVICE_NAME) {
        print('DEVICE found');
        stopScan();
        changeText("Found Target Device");
        targetDevice = scanResult.device;
        connectToDevice();
      }
      setIsLoading(false);
    }, onDone: () =>stopScan());
  }

  stopScan() {
    if (scanSubScription != null) {
      scanSubScription!.cancel();
      scanSubScription = null;
    }
    changeText("Scan Stoped!");
     connectToDevice();
  }

  connectToDevice() async {
    setIsLoading(true);
    changeText("Device Connecting");
    await targetDevice!.disconnect();
    if (targetDevice == null) return;
    await targetDevice!.connect();
    print('DEVICE CONNECTED');
    changeText("Device Connected");
    discoverServices();
    setIsLoading(false);
  }

  disconnectFromDevice() {
    if (targetDevice == null) return;
    targetDevice!.disconnect();
    changeText("Device Disconnected");
    connectToDevice();
  }

  discoverServices() async {
    setIsLoading(true);
    if (targetDevice == null) return;
    List<BluetoothService> services = await targetDevice!.discoverServices();
    services.forEach((service) {
      // do something with service
      if (service.uuid.toString() == Constants.SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == Constants.CHARACTERISTIC_UUID) {
            targetCharacteristic = characteristic;
            // writeData("Hi there, ESP32!!");
            _connectionText = "All Ready with ${targetDevice!.name}";
          }
        });
      }
    });
    setIsLoading(false);
  }

  writeData(String data) async {
    if (targetCharacteristic == null) return;
    List<int> bytes = utf8.encode(data);
    try {
      await targetCharacteristic!.write(bytes);
    } catch (e) {
      writeData(data);
    }
  }
}
