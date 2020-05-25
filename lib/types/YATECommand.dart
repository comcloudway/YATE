import 'package:YATE/YATECommandEngine.dart';
import 'package:YATE/types/input/YATEControlledInput.dart';
import 'package:YATE/types/input/YATEInput.dart';
import 'package:flutter/material.dart';

abstract class YATECommand {
  YATECommand({Key key});
  YATECommandEngine _yce;
  bool _mounted = false;
  @protected
  void onYATEInput(YATEInput yateInput)=>{
	if(yateInput.raw==':q'||yateInput.raw==':quit') {
//		_yce.print('Exiting..'),
		_yce.removeLock(),
	}
  };

  @protected
  void onYATEControlledInput(YATEControlledInput yateControlledInput)=>{};

  @protected
  void onMount(YATECommandEngine yce)=>{_yce=yce,_mounted=true};

  @protected
  void onUnmount()=>{
	  _mounted=false,
  };

  @protected
  final Map<String,dynamic> autocomplete = {};

  @protected 
  String get id => '';

  @protected
  String get name => '';

  @protected
  String get description => '';
}
