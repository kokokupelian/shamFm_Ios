import 'dart:convert';

class RadioData {
  final String link, imageLink, name;
  RadioData({required this.link, required this.imageLink, required this.name});

  static List<RadioData> GetRadioList(String body) {
    List<dynamic> data = json.decode(body)['data']['RadioList'];

    List<RadioData> output = [];

    for (var element in data) {
      output.add(FromJSON(element));
    }
    return output;
  }

  static RadioData FromJSON(Map<String, dynamic> data) {
    return RadioData(
        link: data["radio"], imageLink: data["image"], name: data["name"]);
  }
}
