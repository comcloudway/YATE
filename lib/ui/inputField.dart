import 'package:YATE/YATEManager.dart';
import 'package:YATE/types/input/YATEInput.dart';
import 'package:YATE/types/input/YATERunnable.dart';
import 'package:YATE/types/ui/YATEOutputItem.dart';
import 'package:YATE/ui/ColorfulText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class InputField extends StatefulWidget {
  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  TextEditingController controller = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10, right: 5),
          ),
          Consumer(builder:
              (BuildContext ctx, YATEManager yateManager, Widget child) {
            return Expanded(
                child: TextFormField(
                    autofocus: true,
                    decoration: InputDecoration.collapsed(
                        hintText: 'Type \'yate help\' to get started'),
                    style: TextStyle(
                        color: ThemeProvider.themeOf(context)
                            .data
                            .iconTheme
                            .color),
                    controller: controller,
                    validator: (value) {
                      //execute command
                      yateManager.ctx = context;
                      controller.text = '';
                      if (!yateManager.running) {
                        //no command running execute new one
                        yateManager.print(YATEOutputSelf(
                            iconData: Feather.chevron_right,
                            title: ColorfulText(text: value.toString())));
                        yateManager.init();
                        yateManager.runtime.execute(
                            YATERunnable(raw: value, cmd: value.split(' ')));
                        return '';
                      } else {
                        if (yateManager.runningCMD == null)
                          return 'Error: No running process found. But lockfile exists.';
                        yateManager.runningCMD
                            .onYATEInput(YATEInput(raw: value));
                        return '';
                      }
                    }));
          }),
          Padding(
            child: IconButton(
              icon: Icon(
                Feather.send,
              ),
              splashColor: Colors.grey,
              splashRadius: 15.0,
              onPressed: () {
                _formKey.currentState.validate();
              },
            ),
            padding: EdgeInsets.only(left: 5, right: 10),
          )
        ],
      ),
    );
  }
}
