import 'dart:convert';

import 'package:http/http.dart' as http;

final endpoint = 'https://mobileapi.dsbcontrol.de';
final appVersion = '36';
final osVersion = '30';

String _buildAuthUrl(String appVersion, String osVersion, String username, String password) =>
    '$endpoint/authid'
        '?bundleid=de.heinekingmedia.dsbmobile'
        '&appversion=$appVersion'
        '&osversion=$osVersion'
        '&pushid'
        '&user=$username'
        '&password=$password';

class DSBApi {
  String username;
  String password;

  late String token;

  DSBApi(this.username, this.password);

  Future<void> login() async {
    final url = _buildAuthUrl(appVersion, osVersion, username, password);

    final token = await http.get(Uri.parse(url)).then((response) {
      final body = response.body.replaceAll('"', '');
      if (body.isEmpty) throw Exception('Error while authenticating');
      return body;
    });

    this.token = token;
  }

  Future<List> getTimetables() async {
    final json = jsonDecode(await http.get(Uri.parse('$endpoint/dsbtimetables?authid=$token')).then((response) => response.body));

    if (json is Map && json.containsKey('Message')) throw Exception(json['Message']);

    if(json is List) {
      return json.map((e) => e['Childs'][0]).toList();
    }

    return List.empty();
  }
}
