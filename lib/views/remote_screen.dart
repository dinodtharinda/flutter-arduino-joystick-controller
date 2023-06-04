import 'package:flutter/material.dart';

import '../Joystick/views/joystick_view.dart';

class RemoteScreen extends StatelessWidget {
  const RemoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  opacity: 0.4,
                  onDirectionChanged: (e, r) {
                    print("${e.toStringAsFixed(4)} ${r.toStringAsFixed(4)}");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
