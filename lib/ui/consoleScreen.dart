import 'package:YATE/YATEManager.dart';
import 'package:YATE/YATERuntime.dart';
import 'package:YATE/types/input/YATEControlledInput.dart';
import 'package:YATE/types/input/YATEInput.dart';
import 'package:YATE/ui/ColorfulText.dart';
import 'package:YATE/ui/inputField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class ConsoleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<YATEManager>(
        create: (context) => YATEManager(runtime: YATERuntime())..init(),
        child: Consumer<YATEManager>(
          builder: (BuildContext ctx, YATEManager yateManager, Widget child) {
            return ValueListenableProvider<List<Widget>>.value(
              value: yateManager.output,
              child: Column(
                children: <Widget>[
                  Consumer(
                    builder:
                        (BuildContext ctx, List<Widget> output, Widget child) {
                      return Expanded(
                          child: SingleChildScrollView(
                              child: Column(
                        children: output,
                      )));
                    },
                  ),
                  Container(
                    child: Padding(
                      child: Column(
                        children: <Widget>[
                          SingleChildScrollView(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                //Control-Button-Row Layout
                                GestureDetector(
                                  child: Icon(Feather.pocket,
                                      color: ThemeProvider.themeOf(context)
                                          .data
                                          .iconTheme
                                          .color
                                          .withAlpha(100)),
                                  onTapDown: (TapDownDetails tapDownDetails) {
                                    showMenu(
                                        context: context,
                                        position: RelativeRect.fromLTRB(
                                            tapDownDetails.globalPosition.dx,
                                            tapDownDetails.globalPosition.dy,
                                            MediaQuery.of(context).size.width -
                                                tapDownDetails
                                                    .globalPosition.dx,
                                            MediaQuery.of(context).size.height -
                                                tapDownDetails
                                                    .globalPosition.dy),
                                        items: [
                                          PopupMenuItem(
                                              child: GestureDetector(
                                                  child: ListTile(
                                                    title: ColorfulText(
                                                        text: 'Function Keys'),
                                                    trailing: Icon(
                                                        Feather.chevron_right),
                                                  ),
                                                  onTapDown:
                                                      (TapDownDetails tdd) {
                                                    showMenu(
                                                        context: context,
                                                        position: RelativeRect.fromLTRB(
                                                            tdd.globalPosition
                                                                .dx,
                                                            tdd.globalPosition
                                                                .dy,
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                tdd.globalPosition
                                                                    .dx,
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height -
                                                                tdd.globalPosition
                                                                    .dy),
                                                        items: [
                                                          PopupMenuItem(
                                                              child: ListTile(
                                                            title: ColorfulText(
                                                              text: 'FN 1',
                                                            ),
                                                            onTap: () {
                                                              onControlButton(
                                                                  yateManager,
                                                                  'functionkey',
                                                                  'fn1');
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          )),
                                                          PopupMenuItem(
                                                              child: ListTile(
                                                            title: ColorfulText(
                                                              text: 'FN 2',
                                                            ),
                                                            onTap: () {
                                                              onControlButton(
                                                                  yateManager,
                                                                  'functionkey',
                                                                  'fn2');
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          )),
                                                          PopupMenuItem(
                                                              child: ListTile(
                                                            title: ColorfulText(
                                                              text: 'FN 3',
                                                            ),
                                                            onTap: () {
                                                              onControlButton(
                                                                  yateManager,
                                                                  'functionkey',
                                                                  'fn3');
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          )),
                                                        ]);
                                                  })),
                                          PopupMenuItem(
                                            child: ListTile(
                                              title:
                                                  ColorfulText(text: ':q(uit)'),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                yateManager.runningCMD
                                                    .onYATEInput(
                                                        YATEInput(raw: ':q'));
                                              },
                                            ),
                                          ),
                                        ]);
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Icon(
                                    Feather.more_vertical,
                                    color: ThemeProvider.themeOf(context)
                                        .data
                                        .iconTheme
                                        .color
                                        .withAlpha(60),
                                  ),
                                ),
                                FlatButton(
                                  child: ColorfulText(text: 'Tab'),
                                  onPressed: () {},
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Icon(
                                    Feather.more_vertical,
                                    color: ThemeProvider.themeOf(context)
                                        .data
                                        .iconTheme
                                        .color
                                        .withAlpha(60),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Feather.arrow_left),
                                  onPressed: () {
                                    onControlButton(
                                        yateManager, 'arrow', 'left');
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Feather.arrow_down),
                                  onPressed: () {
                                    onControlButton(
                                        yateManager, 'arrow', 'down');
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Feather.arrow_up),
                                  onPressed: () {
                                    onControlButton(yateManager, 'arrow', 'up');
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Feather.arrow_right),
                                  onPressed: () {
                                    onControlButton(
                                        yateManager, 'arrow', 'right');
                                  },
                                ),
                              ],
                            ),
                            scrollDirection: Axis.horizontal,
                          ),
                          InputField()
                        ],
                      ),
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                    ),
                    decoration: BoxDecoration(
                        color:
                            (ThemeProvider.themeOf(context).id.contains('dark'))
                                ? Colors.black
                                : Colors.white),
                  )
                ],
              ),
            );
          },
        ));
  }
}

void onControlButton(YATEManager ymgr, String type, String value) {
  if (ymgr.running && ymgr.runningCMD != null) {
    ymgr.runningCMD.onYATEControlledInput(
      YATEControlledInput(raw: type + ' ' + value, value: value, type: type),
    );
  }
}
