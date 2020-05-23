import 'package:YATE/YATERuntime.dart';
import 'package:YATE/config.dart';
import 'package:YATE/types/YATECommand.dart';
import 'package:YATE/types/ui/YATEOutputItem.dart';
import 'package:YATE/ui/ColorfulText.dart';
import 'package:flutter/material.dart';

class YATEManager {
  YATEManager({Key key, this.runtime});
  ValueNotifier<List<Widget>> output = ValueNotifier([
    YATEOutputItem(
      title: ColorfulText(text: Flavour.name + '   v' + Flavour.version),
       subtitle: Wrap(direction: Axis.vertical,children: <Widget>[
        ColorfulText(text:'Yet Another Terminal Emulator'),
        ColorfulText(text: 'Run Commands using the YATE-Command-Engine'),
        ColorfulText(text: 'Not shure where to start? - Try \'yate help\''),
      ],),
    ),
    
  ]);
  bool running = false;
  bool inited = false;
  BuildContext ctx;
  YATECommand runningCMD;
  YATERuntime runtime;
  void print(Widget widget) {
    List<Widget> temp = output.value;
    output.value = temp + [widget];
  }

  void runCommand() {}
  void init() {
    if (!inited) {
      runtime.init(this);
      inited = true;
    }
  }
}
