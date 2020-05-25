import 'package:YATE/YATEManager.dart';
import 'package:YATE/types/input/YATERunnable.dart';
import 'package:YATE/ui/ColorfulText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class YATECommandEngine {
  YATECommandEngine({@required this.yateManager, @required this.yateRunnable});
  YATEManager yateManager;
  YATERunnable yateRunnable;
  //Terminal Output
  void print(String text) {
    yateManager.print(ListTile(title: ColorfulText(text: text)));
  }

  void printCustom(Widget widget) {
    yateManager.print(widget);
  }

  void warn(String text) {
    yateManager.print(ListTile(
      title: ColorfulText(text: text),
      leading: Icon(
        Feather.alert_triangle,
        color: Colors.deepOrange,
      ),
    ));
  }

  void error(String text) {
    yateManager.print(ListTile(
      title: ColorfulText(text: text),
      leading: Icon(
        Feather.alert_circle,
        color: Colors.red[900],
      ),
    ));
  }

  BuildContext getContext() {
    return yateManager.ctx;
  }

  //Process Managment
  void removeLock() {
	  this.print('Exiting...');
    yateManager.running=false;
    yateManager.runningCMD.onUnmount();
    yateManager.runningCMD=null;
  }

  //Getters
  List argv() {
    return yateRunnable.cmd;
  }
}
