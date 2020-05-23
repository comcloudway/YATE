import 'package:YATE/YATECommandEngine.dart';
import 'package:YATE/packages/packages.dart';
import 'package:YATE/types/YATECommand.dart';
import 'package:YATE/types/input/YATEControlledInput.dart';
import 'package:YATE/types/input/YATEInput.dart';
import 'package:YATE/ui/ColorfulText.dart';
import 'package:flutter/cupertino.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:flutter/material.dart';

class _Yate extends YATECommand {
  @override
  String get id => 'yate';
  @override
  String get name => 'Yet Another Terminal Emulator';
  @override
  String get description =>
      'Use the yate command to configure the terminal to your likeings\nManage Theme:\n yate theme list - List Available Themes\n yate theme set {id} - Set theme by id\nTools:\n yate clear - Clears the terminal\n yate help - displays this interactive help menu';
  _HelpPageViewer _helpPageViewer;
  @override
  void onMount(YATECommandEngine yce) {
    super.onMount(yce);
    String inp;
    try {
	    inp=yce.argv()[1];
    } catch(e) {
	inp=null;
    }
    if(inp!=null){
    switch (inp) {
      case 'clear':
        yce.yateManager.output.value = [];
        yce.removeLock();
        break;
      case 'help':
        dynamic val;
        try {
          val = yce.argv()[2];
        } catch (e) {
          val = null;
        }

        if (val == null) {
          _helpPageViewer = _HelpPageViewer(
            pages: List.generate(packages.length, (index) {
              return [
                packages[index].id,
                packages[index].name,
                packages[index].description
              ];
            }),
          );

          yce.printCustom(_helpPageViewer);
        } else {
          int c = 0;
          List temp = [];
          for (YATECommand cmd in packages) {
            if (cmd.id == yce.argv()[2]) {
              //found package
              c++;
              //add package to list
              temp.add([cmd.id, cmd.name, cmd.description]);
            }
          }
          if (c == 0) {
            yce.error('Package ${yce.argv()[2]} not found');
            yce.removeLock();
          } else {
            _helpPageViewer = _HelpPageViewer(
              pages: temp,
            );
            yce.printCustom(_helpPageViewer);
          }
        }
        break;
      case 'theme':
        List<String> themes = ['material-light', 'material-dark'];
        String val;
        try {
          val = yce.argv()[2];
        } catch (e) {
          val = null;
        }
        if (val == null) {
          yce.warn('No Options specified');
          yce.removeLock();
        } else {
          if (val == 'list') {
            yce.printCustom(ListTile(
                title: Column(
              children: List.generate(themes.length, (int i) {
                return ColorfulText(text: '+   ' + themes[i]);
              }),
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
            )));
            yce.removeLock();
          } else if (val == 'set') {
            String id;
            try {
              id = yce.argv()[3];
            } catch (e) {
              id = null;
            }
            if (id == null) {
              yce.print('No Theme specified');
              yce.removeLock();
            } else {
              if (themes.contains(id)) {
                ThemeProvider.controllerOf(yce.getContext()).setTheme(id);
                yce.print('Done!');
                yce.removeLock();
              } else {
                yce.warn('Theme not found');
                yce.removeLock();
              }
            }
          }
        }
        break;
      default:
        yce.print('yate ${yce.argv()[1]} not found');
        yce.removeLock();
    }}else {
	yce.error('No option specified');
	yce.removeLock();
    }
  }

  @override
  void onYATEControlledInput(YATEControlledInput yateControlledInput) {
    if (_helpPageViewer != null) {
      _helpPageViewer.onArrowKey(yateControlledInput.value);
    }
  }
  @override
  void onYATEInput(YATEInput yateInput) {
  super.onYATEInput(yateInput);
  }
  @override
  void onUnmount() {
    super.onUnmount();
    _helpPageViewer = null;
  }
}

class _HelpPageViewer extends StatefulWidget {
  _HelpPageViewer({Key key, @required this.pages}) : super(key: key);
  final _HelpPageViewerState state = _HelpPageViewerState();
  void onArrowKey(String value) => {state.onArrowKey(value)};
  List pages = [];
  _HelpPageViewerState createState() => state;
}

class _HelpPageViewerState extends State<_HelpPageViewer> {
  void onArrowKey(String value) => {
        if (value == 'right')
          {
            if (index + 2 <= widget.pages.length)
              {
                setState(() => {index++})
              }
            else
              {
                setState(() => {index = 0})
              }
          }
        else if (value == 'left')
          {
            if (index == 0)
              {
                setState(() => {index = widget.pages.length - 1})
              }
            else
              {
                setState(() => {index = index - 1})
              }
          }
      };

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ColorfulText(
            text:
                'Use the left and right arrow keys to navigate between help pages'),
        ColorfulText(
            text:
                'To view the help page for a specific command run \' yate help [command name]\''),
        ColorfulText(
          text:
              'type :q to quit or select the :q(uit) option from the command pocket',
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        ColorfulText(text: widget.pages[index][0]),
        ColorfulText(text: widget.pages[index][1]),
        ColorfulText(text: widget.pages[index][2]),
      ],
    );
  }
}

//exports
List<YATECommand> pkgYate = [_Yate()];
