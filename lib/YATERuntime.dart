import 'package:YATE/YATECommandEngine.dart';
import 'package:YATE/YATEManager.dart';
import 'package:YATE/packages/packages.dart';
import 'package:YATE/types/YATECommand.dart';
import 'package:YATE/types/input/YATERunnable.dart';
import 'package:flutter/material.dart';

class YATERuntime {
  YATERuntime({
    Key key,
  });
  YATEManager manager;
  bool _init = false;
  void init(YATEManager mgr) {
    manager = mgr;
    _init=true;
  }

  void execute(YATERunnable yateRunnable) {
    if(!_init) {print('ERROR');return;}
    int found = 0;
    int running = 0;
    for(YATECommand cmd in packages) {
      if(yateRunnable.cmd[0]==cmd.id&&found <1) {
        found++;
        if(!manager.running) {
          running++;
          manager.running=true;
          manager.runningCMD=cmd;
          cmd.onMount(YATECommandEngine(yateManager: manager,yateRunnable: yateRunnable));
        }
      }
    }
    if(found==0) {
      YATECommandEngine(yateManager: manager,yateRunnable: null).error('Command not found');
      manager.running=false;
    } else if(running==0) {
      YATECommandEngine(yateManager: manager,yateRunnable: null).error('Command could not be run');
      manager.running=false;
    }
  }
}
