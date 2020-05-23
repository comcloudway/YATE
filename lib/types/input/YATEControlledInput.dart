import 'package:flutter/material.dart';

class YATEControlledInput {
  //Index content
  String type; //arrow|hotkey|functionkey
  String value; //left,right,up,down|Tab|fn1,fn2,fn3
  String raw; //e.g. arrow left, hotkey Tab, functionkey fn2

  YATEControlledInput({
    @required this.raw,
    @required this.value,
    @required this.type
  });
}
