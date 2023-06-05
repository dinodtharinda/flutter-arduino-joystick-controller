
import 'package:flutter/material.dart';

import 'package:joy/services/bluetooth_service.dart';
import 'package:joy/views/remote_screen.dart';
import 'package:provider/provider.dart';

class FindDevicesScreen extends StatefulWidget {
  const FindDevicesScreen({super.key});

  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BTService btService = Provider.of<BTService>(context, listen: false);
    btService.startScan();
    return RemoteScreen(btService: btService);
  }
}
