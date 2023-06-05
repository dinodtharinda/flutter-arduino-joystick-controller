// ignore_for_file: avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:joy/services/bluetooth_service.dart';
import 'package:provider/provider.dart';
import '../Joystick/views/joystick_view.dart';

class RemoteScreen extends StatefulWidget {
  BTService btService;
  RemoteScreen({
    Key? key,
    required this.btService,
  }) : super(key: key);

  @override
  State<RemoteScreen> createState() => _RemoteScreenState();
}

class _RemoteScreenState extends State<RemoteScreen> {
  @override
  void initState() {
    widget.btService.startScan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String msg = Provider.of<BTService>(context, listen: true).connectionText;
    bool isLoading = Provider.of<BTService>(context, listen: true).isLoading;

    Future onDirectionChanged(double degrees, double distance) async {
      String data =
          "${degrees.toStringAsFixed(2)} ${distance.toStringAsFixed(2)}";
      print(data);
      widget.btService.writeData(data);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(msg),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      JoystickView(
                          interval: const Duration(milliseconds: 200),
                          opacity: 0.4,
                          onDirectionChanged: onDirectionChanged),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        widget.btService.writeData('incrementCounter');
      }),
    );
  }
}
