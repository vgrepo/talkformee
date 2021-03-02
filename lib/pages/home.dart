import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:sqflite/sqflite.dart';
import 'package:talkformee/database/database.dart';
import 'package:talkformee/models/rjecnik.dart';
import 'package:talkformee/models/rjecnik.dart';
import 'package:talkformee/models/rjecnik.dart';
import '../settings/settingsPref.dart';
import '../pages/settings.dart';

class Home extends StatefulWidget {
  final Settings settings;
  final Function onSettingsChanged;

  Home({
    @required this.settings,
    @required this.onSettingsChanged,
  });

  @override
  _HomeState createState() => _HomeState();
}

enum TtsState { playing, stopped }

class _HomeState extends State<Home> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Rjecnik> rjecnikList1;

  FlutterTts flutterTts = new FlutterTts();
  dynamic languages;
  String language;
  double volume = 0.5;
  double pitch = 1.1;
  double rate = 0.1;
  String _filter = 'word';
  String _newVoiceText;
  int _barIndex = 0;
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  TabController _tabController;
  ScrollController _scrollViewController;

  List _itemsBrojevi;
  List _itemsText;
  List _itemsZnakovi;
  List<String> _rjeci = new List();

  final List<String> _listBrojevi = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '20',
    '30',
    '40',
    '50',
    '60',
    '70',
    '80',
    '90',
    '100',
    '200',
    '300',
    '400',
    '500',
    '600',
    '700',
    '800',
    '900',
    '100',
    '%',
    '+',
    '-',
    '=',
    'milimetara',
    'centimetara',
    'metara',
    'kilometara',
    'kuna',
    'eura'
  ];
  bool _symmetry = false;
  bool _removeButton = true;
  bool _singleItem = false;
  bool _startDirection = false;
  bool _horizontalScroll = false;
  bool _withSuggesttions = false;
  int _count = 0;
  int _column = 0;
  double _fontSize = 24;

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  String _itemCombine = 'withTextBefore';

  String _onPressed = '';

  TextEditingController _textControler = new TextEditingController();

  @override
  initState() {
    super.initState();
    updateList();
    // _tabController = TabController(length: 2, vsync: this);
    _scrollViewController = ScrollController();
    language = widget.settings.lang;

    volume = widget.settings.volume;
    pitch = widget.settings.pitch;
    rate = widget.settings.rate;
    _itemsBrojevi = _listBrojevi.toList();
    initTts();
  }

  initTts() {
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

  void _delContent() {
    _textControler.clear();
  }

  Future _speak() async {
    await flutterTts.setLanguage(widget.settings.lang);
    await flutterTts.setVolume(widget.settings.volume);
    await flutterTts.setSpeechRate(widget.settings.rate);
    await flutterTts.setPitch(widget.settings.pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        var result = await flutterTts.speak(_newVoiceText);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems() {
    var items = List<DropdownMenuItem<String>>();
    for (String type in languages) {
      items.add(DropdownMenuItem(value: type, child: Text(type)));
    }
    return items;
  }

  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Talk For Me'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Dodaj izraz',
              onPressed: () {
                Navigator.of(context).pushNamed('/rjecniklist');
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {
                Navigator.of(context).pushNamed('/settings');
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _barIndex,
            onTap: (int index) {
              setState(() {
                this._barIndex = index;
                print(_barIndex);
                switch (_barIndex) {
                  case 0:
                    _filter = 'word';
                    break;
                  case 1:
                    _filter = 'sentences';
                    break;
                  case 2:
                    _filter = 'number';
                    break;
                  case 3:
                    _filter = 'key';
                    break;
                  default:
                    _filter = 'word';
                }
              });
              _rjeci.clear();
              updateList();
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Rijeći',
                  backgroundColor: Colors.accents[5]),
              BottomNavigationBarItem(
                  icon: Icon(Icons.mail),
                  label: 'Rečenice',
                  backgroundColor: Colors.red),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Brojevi'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Tipkovnica')
            ]),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              _inputSection(),
              _btnSection(),
              _filter == 'number' ? _tags1(_itemsBrojevi) : Container(),
              SizedBox(
                height: 10,
              ),
              //  _tags1(_itemsZnakovi),
              //  _tags1(_itemsText),
              _tags1(_rjeci)
            ])));
  }

  Widget _inputSection() => Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
      child: TextField(
        maxLines: 2,
        controller: _textControler,
        style: TextStyle(color: Colors.white),
        onChanged: (String val) {
          _onChange(val);
        },
      ));

  Widget _btnSection() => Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _buildButtonColumn(
            Colors.green, Colors.greenAccent, Icons.play_arrow, '', _speak),
        _buildButtonColumn(Colors.red, Colors.redAccent, Icons.stop, '', _stop),
        _buildButtonColumn(
            Colors.green, Colors.green, Icons.delete, '', _delContent)
      ]));

  Column _buildButtonColumn(Color color, Color splashColor, IconData icon,
      String label, Function func) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(icon),
              color: color,
              splashColor: splashColor,
              onPressed: () => func()),
          Container(
              margin: const EdgeInsets.only(top: 0.5, bottom: 20.0),
              child: Text(label,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: color)))
        ]);
  }

  Widget _tags1(List _items) {
    return Tags(
      //key: _tagStateKey,
      symmetry: _symmetry,
      columns: _column,
      horizontalScroll: _horizontalScroll,
      //verticalDirection: VerticalDirection.up, textDirection: TextDirection.rtl,
      heightHorizontalScroll: 60 * (_fontSize / 14),
      itemCount: _items.length,
      itemBuilder: (index) {
        final item = _items[index];

        return ItemTags(
          key: Key(index.toString()),
          index: index,
          title: item,
          pressEnabled: true,
          activeColor: Colors.blueGrey[600],
          singleItem: _singleItem,
          splashColor: Colors.green,
          combine: ItemTagsCombine.withTextBefore,
          textScaleFactor:
              utf8.encode(item.substring(0, 1)).length > 2 ? 0.8 : 1,
          textStyle: TextStyle(
            fontSize: _fontSize,
          ),
          onPressed: (item) {
            if (item.active == false) {
              setState(() {
                _textControler.text =
                    _textControler.text + '' + item.title.toString();
              });
              _onChange(_textControler.text);
            }
          },
        );
      },
    );
  }

  void updateList() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Rjecnik>> rjecnikListFuture =
          databaseHelper.getRjecnikList(_filter);
      rjecnikListFuture.then((rjecnikList) {
        setState(() {
          this.rjecnikList1 = rjecnikList;
          rjecnikList.forEach((k) => _rjeci.add(k.title));
        });
      });
    });
  }
}
