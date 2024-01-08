import 'dart:convert';

import 'package:http/http.dart' as http;
import '../GraphQl/gql.dart';
import '../Models/radio.dart';
import '../Models/uploaded.dart';

Uri get Link {
  return Uri.parse("https://gql.sham.fm");
}

Map<String, String> get headers => {"Content-Type": "application/json"};

Future<Uploaded> GetUploaded() async {
  var response =
      await http.post(GQL.Link, body: GQL.uploaded(), headers: headers);
  if (response.statusCode == 200) {
    return Uploaded.fromJson(json.decode(response.body)['data']);
  } else {
    return Uploaded(android: true, ios: true);
  }
}

Future<List<RadioData>> GetRadios() async {
  var response =
      await http.post(GQL.Link, body: GQL.radioLists(), headers: headers);
  if (response.statusCode == 200) {
    return RadioData.GetRadioList(response.body);
  } else {
    return [];
  }
}
