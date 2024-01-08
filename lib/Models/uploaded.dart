import 'dart:io';

class Uploaded {
  final bool android, ios;

  Uploaded({
    required this.android,
    required this.ios,
  });

  bool get platformSpecific =>
      (Platform.isIOS && ios) || (Platform.isAndroid && android);

  static fromJson(Map<String, dynamic> data) {
    return Uploaded(
      android: data['isUploaded']['uploaded'].toString() == 'true',
      ios: data['isUploaded']['uploadedIOS'].toString() == 'true',
    );
  }
}
