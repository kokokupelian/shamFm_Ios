import 'package:audio_service/audio_service.dart';
import 'package:flutter/Material.dart';
import '../../../Helpers/radio_handler.dart';
import 'package:flutter/material.dart';
import '../../../Models/radio.dart';

import '../Models/uploaded.dart';

class MainProvider extends ChangeNotifier {
  Uploaded _isUploaded = Uploaded(android: true, ios: true);
  Uploaded get isUploaded {
    return _isUploaded;
  }

  setisUploaded(Uploaded isUploaded) {
    _isUploaded = isUploaded;
  }

  final ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode {
    return _themeMode;
  }

  late List<RadioData> radio = [];

  setRadioList(List<RadioData> list) {
    radio = list;
    _selectedRadio = list[0];
  }

  late ValueNotifier radioChanged = ValueNotifier(null);

  bool isRadioInit = false;

  late AudioHandler audioHandler;

  late RadioData _selectedRadio;
  RadioData get selectedRadio {
    return _selectedRadio;
  }

  setselectedRadio(RadioData value) {
    _selectedRadio = value;
    notifyListeners();
  }

  Future<void> initRadio(BuildContext context) async {
    audioHandler = await AudioService.init(
      builder: () {
        return RadioHandler(context, radioLink: selectedRadio.link);
      },
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.ulcode.shamfm.radio',
        androidNotificationChannelName: 'Radio',
        androidShowNotificationBadge: true,
      ),
    );
    isRadioInit = true;
  }
}
