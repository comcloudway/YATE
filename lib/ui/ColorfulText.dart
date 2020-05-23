import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class ColorfulText extends StatelessWidget {
  ColorfulText({Key key,@required this.text}):super(key:key);
  String text;
  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(
      color: ThemeProvider.themeOf(context).data.iconTheme.color,
      fontSize: 20
    ),);
  }
}