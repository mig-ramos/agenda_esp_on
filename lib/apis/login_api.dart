import 'dart:convert';
import 'package:agenda_esp_on/configuratios/setup.dart';
import 'package:agenda_esp_on/models/user.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  static Future<int> login(String user, String password) async {
    String _email = user;
    String _senha = password;
    String _token = '';

    var setup = Setups();

    var url = Uri.parse(setup.conexao + '/login');
    var header = setup.cabecalho;

    Map params = {"email": user, "senha": password};

    var _body = json.encode(params);

    var response = await http.post(url, headers: header, body: _body);

    int status = response.statusCode;

    print(status);

    switch (status) {
      case 200:
        Map<String, dynamic> mapResponse = json.decode(response.body);
        _token = (mapResponse["Authorization"] == null)
            ? ''
            : mapResponse["Authorization"];

        Map<String, String> mapUser = {
          "email": _email,
          "senha": _senha,
          "token": _token
        };

        final usser = User.fromJson(mapUser);
        User.clear();
        usser.save();
        return response.statusCode;
        break;
      default:
        return response.statusCode;
    }
  }
}
