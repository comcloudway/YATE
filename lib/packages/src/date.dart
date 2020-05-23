import 'dart:async';

import 'package:YATE/YATECommandEngine.dart';
import 'package:YATE/types/YATECommand.dart';
import 'package:YATE/types/input/YATEControlledInput.dart';
import 'package:YATE/types/input/YATEInput.dart';
import 'package:YATE/ui/ColorfulText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _Date extends YATECommand {
  @override
  void onMount(YATECommandEngine yce) {
    super.onMount(yce);
    yce.printCustom(_DateWidget());
    yce.removeLock();
  }

  @override
  void onUnmount() {
    super.onUnmount();
  }

  @override
  String get description => 'Simple Date Widget';
  @override
  String get id => 'date';
  @override
  String get name => 'Date';
  @override
  void onYATEInput(YATEInput yateInput) {
    super.onYATEInput(yateInput);
  }

  @override
  void onYATEControlledInput(YATEControlledInput yateControlledInput) {
    super.onYATEControlledInput(yateControlledInput);
  }
}

class _DateWidget extends StatefulWidget {
  @override
  _DateWidgetState createState() => _DateWidgetState();
}

class _DateWidgetState extends State<_DateWidget> {
  String _d = 'Loading...';
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    String temp = ((now.day < 10) ? '0' : '') +
        now.day.toString() +
        '.' +
        ((now.month < 10) ? '0' : '') +
        now.month.toString() +
        '.' +
        now.year.toString();
    if (temp != _d) {
      setState(() {
        _d = temp;
      });
    }
    Timer.periodic(Duration(seconds: 30), (Timer t) {
      DateTime now = DateTime.now();
      String temp = ((now.day < 10) ? '0' : '') +
          now.day.toString() +
          '.' +
          ((now.month < 10) ? '0' : '') +
          now.month.toString() +
          '.' +
          now.year.toString();
      if (temp != _d) {
        setState(() {
          _d = temp;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: ColorfulText(text: 'DATE'),
      subtitle: ColorfulText(text: _d),
    );
  }
}

List<YATECommand> pkgDate = [_Date()];
