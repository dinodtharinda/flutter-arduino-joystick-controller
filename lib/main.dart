// ignore_for_file: non_constant_identifier_names, avoid_print, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:joy/views/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]).then(
    (_) {
      runApp(
        const MaterialApp(
          home: SplashScreen(),
        ),
      );
    },
  );
}



