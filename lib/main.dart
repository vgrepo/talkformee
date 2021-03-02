import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talkformee/pages/rjecnikDetail.dart';
import 'package:talkformee/pages/rjecnikList.dart';
import 'package:talkformee/settings/theme.dart';
import 'models/rjecnik.dart';
import 'pages/home.dart';
import 'pages/settings.dart';
import 'settings/settingsPref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp(settings: Settings(prefs), prefs: prefs));
}

class MyApp extends StatefulWidget {
  final Settings settings;
  final SharedPreferences prefs;

  MyApp({this.settings, this.prefs});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _onSettingsChanged() {
    setState(() {});
    widget.settings.save();
  }

  @override
  initState() {
    var _settings = widget.prefs.getString('settings');
    if (_settings == null) {
      widget.settings.save();
    }
    super.initState();
    print('object');
    print('object');
    print('object');
  }

  @override
  Widget build(BuildContext context) {
    //portraitModeOnly();
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => Home(
              settings: widget.settings,
              onSettingsChanged: _onSettingsChanged,
            ),
        '/settings': (BuildContext context) => SettingsScreen(
              settings: widget.settings,
              onSettingsChanged: _onSettingsChanged,
            ),
        '/rjecniklist': (BuildContext context) => RjecnikList(),
        '/rjecnikdetail': (BuildContext context) =>
            RjecnikDetail(Rjecnik('', '', '', '', '', 0), "Dodja izraz"),
      },
      debugShowCheckedModeBanner: false,
      title: 'Talk For Mee',
      theme: ThemeData(
          // brightness: Brightness.dark,
          primaryColor: Colors.blue,
          accentColor: Colors.blueAccent,
          scaffoldBackgroundColor: Color(0xff014886),
          //scaffoldBackgroundColor: Colors.lightBlue,
          appBarTheme:
              AppBarTheme(textTheme: TextTheme(title: AppBarTextstyle)),
          textTheme: TextTheme(
            title: TitleTextStyle,
            body1: Body1TextStyle,
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Color(0xff015dad),
            textTheme: ButtonTextTheme.accent,
          )),
      home: Home(
        settings: widget.settings,
        onSettingsChanged: _onSettingsChanged,
      ),
    );
  }
}
