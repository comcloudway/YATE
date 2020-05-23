import 'dart:async';

import 'package:YATE/YATECommandEngine.dart';
import 'package:YATE/types/YATECommand.dart';
import 'package:YATE/types/input/YATEInput.dart';
import 'package:YATE/types/input/YATEControlledInput.dart';
import 'package:YATE/ui/ColorfulText.dart';
import 'package:flutter/material.dart';

class _Clock extends YATECommand {
  @override
  final String id = 'clock';
  @override
  final String name = 'Clock';
  @override
  final String description =
      'Simple Clock Widget used to display the current time';

  @override
  void onMount(YATECommandEngine yce) {
    super.onMount(yce);
    yce.printCustom(ListTile(
      title: ColorfulText(text: 'Clock'),
      subtitle: _ClockWidget(),
    ));
    yce.removeLock();
  }

  @override
  void onUnmount() {
    super.onUnmount();
  }

  @override
  void onYATEControlledInput(YATEControlledInput yateControlledInput) {
    super.onYATEControlledInput(yateControlledInput);
  }

  @override
  void onYATEInput(YATEInput yateInput) {
    super.onYATEInput(yateInput);
  }
}

class _ClockWidget extends StatefulWidget {
  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State {
  String time = 'loading...';
  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    String temp =
        ((now.hour < 10) ? '0' + now.hour.toString() : now.hour.toString()) +
            ':' +
            ((now.minute < 10)
                ? '0' + now.minute.toString()
                : now.minute.toString());
    if (temp != time) {
      setState(() {
        time = temp;
      });
    }
    Timer.periodic(Duration(seconds: 10), (timer) {
      var now = DateTime.now();
      String temp =
          ((now.hour < 10) ? '0' + now.hour.toString() : now.hour.toString()) +
              ':' +
              ((now.minute < 10)
                  ? '0' + now.minute.toString()
                  : now.minute.toString());
      if (temp != time) {
        setState(() {
          time = temp;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColorfulText(text: time);
  }
}

List<YATECommand> pkgClock = [_Clock()];
