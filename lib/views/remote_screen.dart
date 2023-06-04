// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../Joystick/views/joystick_view.dart';

class RemoteScreen extends StatefulWidget {
  BluetoothCharacteristic? targetCharacteristic;
   RemoteScreen({
    Key? key,
    required this.targetCharacteristic,
  }) : super(key: key);
  
  @override
  State<RemoteScreen> createState() => _RemoteScreenState();
}

class _RemoteScreenState extends State<RemoteScreen> {

  writeData(String data) async {
    if (widget.targetCharacteristic == null) return;

    List<int> bytes = utf8.encode(data);
    try {
      await widget.targetCharacteristic!.write(bytes);
    } catch (e) {
      writeData(data);
    }
  }
  @override
  void dispose() {
   widget.targetCharacteristic = null;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Future onDirectionChanged(double degrees, double distance) async {
      String data =
          "${degrees.toStringAsFixed(2)} ${distance.toStringAsFixed(2)}";
      print(data);
      writeData(data);
    }
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:40,bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                JoystickView(
                  interval: const Duration(milliseconds: 200),
                  opacity: 0.4,
                  onDirectionChanged: onDirectionChanged
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
