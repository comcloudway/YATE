import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class YATEOutputItem extends StatelessWidget{
  YATEOutputItem({
    Key key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing
  }):super(key:key);
  Widget title;
  Widget leading;
  Widget trailing;
  Widget subtitle;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      leading: leading,
      trailing: trailing,
      subtitle: subtitle,
    );
  }
}

class YATEOutputSelf extends YATEOutputItem {
  IconData iconData;
  Widget title;
  YATEOutputSelf({
    Key key,
    this.iconData,
    this.title
  });
  @override 
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      leading: Icon(iconData,color: ThemeProvider.themeOf(context).data.accentColor),
    );
  }
}