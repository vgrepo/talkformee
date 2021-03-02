import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  final SharedPreferences _prefs;

  double volume;
  String lang;
  double pitch;
  double rate;
  /* int easyMove;
  int normalMove;
  int hardMove;
  int easyWin;
  int normalWin;
  int hardWin;
  int easyPlayed;
  int normalPlayed;
  int hardPlayed;*/

  Settings(this._prefs) {
    Map<String, dynamic> json =
        jsonDecode(_prefs.getString('settings') ?? '{}');
    volume = json['volume'] ?? 0.5;
    lang = json['lang'] ?? 'hr';
    pitch = json['pitch'] ?? 1.0;
    rate = json['rate'] ?? 0.1;
    /*easyMove = json['easyMove'] ?? 0;
    normalMove = json['normalMove'] ?? 0;
    hardMove = json['hardMove'] ?? 0;
    easyWin = json['easyWin'] ?? 0;
    normalWin = json['normalWin'] ?? 0;
    hardWin = json['hardWin'] ?? 0;
    easyPlayed = json['easyPlayed'] ?? 0;
    normalPlayed = json['normalPlayed'] ?? 0;
    hardPlayed = json['hardPlayed'] ?? 0;*/
  }

  save() {
    _prefs.setString('settings', jsonEncode(this));
  }

  Map<String, dynamic> toJson() => {
        'volume': volume,
        'lang': lang,
        'pitch': pitch,
        'rate': rate,
        /*  'easyMove': easyMove,
        'normalMove': normalMove,
        'hardMove': hardMove,
        'easyWin': easyWin,
        'normalWin': normalWin,
        'hardWin': hardWin,
        'easyPlayed': easyPlayed,
        'normalPlayed': normalPlayed,
        'hardPlayed': hardPlayed,*/
      };
}

/// blocks rotation; sets orientation to: portrait
void portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void enableRotation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}
