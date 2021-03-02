import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_tags/flutter_tags.dart';
import '../settings/settingsPref.dart';

class SettingsScreen extends StatefulWidget {
  final Settings settings;
  final Function onSettingsChanged;

  SettingsScreen({@required this.settings, @required this.onSettingsChanged});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

enum TtsState { playing, stopped }

class _SettingsScreenState extends State<SettingsScreen> {
  bool nightMode;
  bool silentMode;
  FlutterTts flutterTts;
  dynamic languages;
  String language;
  double volume = 0.5;
  double pitch = 1.1;
  double rate = 0.1;
  ScrollController _scrollViewController;
  List _items;
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  @override
  initState() {
    _scrollViewController = ScrollController();
    language = widget.settings.lang;
    volume = widget.settings.volume;
    pitch = widget.settings.pitch;
    rate = widget.settings.rate;
    initTts();
    super.initState();
  }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    flutterTts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    if (languages != null) setState(() => languages);
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems() {
    var items = List<DropdownMenuItem<String>>();
    for (String type in languages) {
      items.add(DropdownMenuItem(value: type, child: Text(type)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String selectedType) {
    setState(() {
      language = selectedType;
      widget.settings.lang = language;
      flutterTts.setLanguage(language);
      widget.onSettingsChanged();
    });
  }

  Widget _languageDropDownSection() => Container(
      padding: EdgeInsets.only(top: 50.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          children: [
            Text('Language:  '),
            DropdownButton(
              value: language,
              items: getLanguageDropDownMenuItems(),
              onChanged: changedLanguageDropDownItem,
            ),
          ],
        )
      ]));

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Speak'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {
                Navigator.of(context).pushNamed('/settings');
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              //  _inputSection(),
              //  _btnSection(),
              languages != null ? _languageDropDownSection() : Text(""),
              _buildSliders(),
              //  _tags1,
            ])));
  }

  Widget _buildSliders() {
    return Column(
      children: [_volume(), _pitch(), _rate()],
    );
  }

  Widget _volume() {
    return Container(
      width: double.infinity,
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Text('Volume'),
          Slider(
              value: volume,
              onChanged: (newVolume) {
                setState(() {
                  volume = newVolume;
                  widget.settings.volume = newVolume;
                  widget.onSettingsChanged();
                });
              },
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: "Volume: $volume"),
        ],
      ),
    );
  }

  Widget _pitch() {
    return Container(
      child: Column(
        children: [
          Text('Pitch'),
          Slider(
            value: pitch,
            onChanged: (newPitch) {
              setState(() {
                pitch = newPitch;
                widget.settings.pitch = newPitch;
                widget.onSettingsChanged();
              });
            },
            min: 0.5,
            max: 2.0,
            divisions: 15,
            label: "Pitch: $pitch",
            activeColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _rate() {
    return Container(
      child: Column(
        children: [
          Text('Rate'),
          Slider(
            value: rate,
            onChanged: (newRate) {
              setState(() {
                rate = newRate;
                widget.settings.rate = newRate;
                widget.onSettingsChanged();
              });
            },
            min: 0.0,
            max: 1.0,
            divisions: 10,
            label: "Rate: $rate",
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
