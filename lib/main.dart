import 'package:YATE/config.dart';
import 'package:YATE/ui/consoleScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';

void main() {
  runApp(YATEThemeProvider());
}
class YATEThemeProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      defaultThemeId: 'material-dark',
      themes: [
        AppTheme(
            id: 'material-light',
            description: 'Light Material Theme',
            data: ThemeData(
              textTheme: GoogleFonts.vt323TextTheme(),
              brightness: Brightness.light,
              primarySwatch: Colors.blueGrey,
              accentColor: Colors.blueGrey,
              iconTheme:  IconThemeData(color: Colors.black),
            )),
        AppTheme(
            id: 'material-dark',
            description: 'Dark Material Theme',
            data: ThemeData(
              textTheme: GoogleFonts.vt323TextTheme(),
              iconTheme:  IconThemeData(color: Colors.white),
              brightness: Brightness.dark,
              primarySwatch: Colors.blueGrey,
              accentColor: Colors.lightBlueAccent,
            )),
      ],
      loadThemeOnInit: true,
      saveThemesOnChange: true,
      child: _YATEApp(),
    );
  }
}

class _YATEApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
        child: MaterialApp(
      theme: ThemeProvider.themeOf(context).data,
      home: _YATEMain(),
    ));
  }
}

class _YATEMain extends StatefulWidget {
  @override
  _YATEMainState createState() => _YATEMainState();
}

class _YATEMainState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Flavour.name),
      ),
      body: ConsoleScreen(),
    );
  }
}
