import 'dart:convert';

import 'package:YATE/YATECommandEngine.dart';
import 'package:YATE/types/YATECommand.dart';
import 'package:YATE/types/input/YATEControlledInput.dart';
import 'package:YATE/types/input/YATEInput.dart';
import 'package:YATE/ui/ColorfulText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

YATECommandEngine YCE;

class _DuckDuckGo extends YATECommand {
  @override
  String get id => 'duckduckgo';
  @override
  String get name => 'DuckDuckGo Api Search';
  @override
  String get description =>
      'Search the Web using the duckduckgo api to retrieve basic information.\n use \'duckduckgo [search term]\' to search. To navigate between results, use the left - and right arrow keys';
  @override
  // TODO: implement autocomplete
  Map<String, dynamic> get autocomplete => super.autocomplete;
  @override
  void onUnmount() {
    super.onUnmount();
    wdg = null;
  }

  _DuckDuckGoWidget wdg;
  @override
  void onMount(YATECommandEngine yce) {
    super.onMount(yce);
    YCE = yce;
    if (yce.argv().length <= 1) {
      //no arguments
      yce.error('No Search Term specified');
      yce.removeLock();
    } else {
      String _t = '';
      List args = yce.argv();
      args.removeAt(0);
      for (String p in args) {
        _t += ' ' + p;
      }
      _t = _t.substring(1, _t.length);
      wdg = _DuckDuckGoWidget(term: _t);
      yce.printCustom(ListTile(
        title: wdg,
      ));
    }
  }

  @override
  void onYATEInput(YATEInput yateInput) {
    super.onYATEInput(yateInput);
  }

  @override
  void onYATEControlledInput(YATEControlledInput yateControlledInput) {
    super.onYATEControlledInput(yateControlledInput);
    if (wdg != null && yateControlledInput.type == 'arrow') {
      wdg.onArrowKey(yateControlledInput.value);
    }
  }
}

class _DuckDuckGoWidget extends StatefulWidget {
  _DuckDuckGoWidget({Key key, this.term}) : super(key: key);
  String term;
  _DuckDuckGoWidgetState state = _DuckDuckGoWidgetState();
  void onArrowKey(String value) {
    state.onArrowKey(value);
  }

  @override
  _DuckDuckGoWidgetState createState() => state;
}

class _DuckDuckGoWidgetState extends State<_DuckDuckGoWidget> {
  List<Widget> _view = [
    ListTile(
      leading: Image.asset(
        'assets/duckduckgo.png',
        width: 50.0,
        height: 50.0,
      ),
      title: ColorfulText(text: 'Search Results provided by DuckDuckGo'),
    )
  ];
  List<Widget> disp = [];
  int index = 0;
  int count = 0;
  dynamic results;
  void onArrowKey(String value) {
    if (value == 'right' && ((results != null) ? count >= 1 : false)) {
      if (index + 2 <= count) {
        setState(() {
          index += 1;
        });
      } else {
        setState(() {
          index = 0;
        });
      }
    } else if (value == 'left' && ((results != null) ? count >= 1 : false)) {
      if (index - 1 < 0) {
        setState(() {
          index = count - 1;
        });
      } else {
        setState(() {
          index = index - 1;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    (() async {
      http.Response resp = await http.get(
          'https://api.duckduckgo.com/?format=json&t=YATE&q=${Uri.encodeFull(widget.term)}');
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        //success
        dynamic json = jsonDecode(resp.body);
        if (json['RelatedTopics'] == null) return;
        if (json['RelatedTopics'].length == 0) {
          setState(() {
            _view += [
              ColorfulText(
                text: 'No Results',
              )
            ];
          });
          YCE.removeLock();
        } else {
          results = json;
          List<Widget> temp = [];
          RegExp regExp = RegExp('(href=(((\\")([^]+)(\\"))>))');
          int l = 0;
          for (var i in json['RelatedTopics']) {
            if (i['Result'] == null && i['Topics'] == null) continue;
            if (i['Topics'] != null) {
              //do it all over again
              for (var e in i['Topics']) {
                if (e['Result'] == null) continue;
                l++;
                var match = regExp.firstMatch(e['Result']);
                temp.add(ListTile(
                  onTap: () async {
                    if (match.group(5).toString() != null &&
                        match.group(5).toString() != '') {
                      String url = match.group(5).toString();
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    }
                  },
                  title: ColorfulText(
                      text: ((e['Text'] != null && e['Text'] != '')
                          ? e['Text']
                          : 'No title provided')),
                  leading: ((e['Icon'] != null)
                      ? ((e['Icon']['URL'] == '' || e['Icon']['URL'] == null)
                          ? Icon(Feather.globe)
                          : Image.network(
                              e['Icon']['URL'],
                              width: 50.0,
                              height: 50.0,
                            ))
                      : Icon(Feather.globe)),
                ));
              }
            } else {
              l++;
              var match = regExp.firstMatch(i['Result']);
              temp.add(
                ListTile(
                  onTap: () async {
                    if (match.group(5).toString() != null &&
                        match.group(5).toString() != '') {
                      String url = match.group(5).toString();
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    }
                  },
                  leading: (i['Icon']['URL'] == '')
                      ? Icon(Feather.globe)
                      : Image.network(
                          i['Icon']['URL'],
                          width: 50.0,
                          height: 50.0,
                        ),
                  title: ColorfulText(
                      text: (i['Text'] != null && i['Text'] != '')
                          ? i['Text']
                          : 'No Title provided'),
                ),
              );
            }
          }
          count = l;
          if (temp.length >= 1) {
            setState(() {
              disp = temp;
            });
          } else {
            setState(() {
              _view += [
                ColorfulText(
                  text: 'No results',
                )
              ];
              YCE.removeLock();
            });
          }
        }
      } else {
        //error
        setState(() {
          _view = _view + [ColorfulText(text: 'Request failed')];
        });
        YCE.removeLock();
      }
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _view +
          ((disp.length == 0)
              ? []
              : [
                  ColorfulText(text: 'Result ${index + 1}/${count}'),
                  disp[index]
                ]),
    );
  }
}

List<YATECommand> pkgDuckDuckGo = [_DuckDuckGo()];
