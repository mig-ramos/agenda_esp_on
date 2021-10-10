import 'dart:convert';
import 'package:agenda_esp_on/configurations/setup.dart';
import 'package:agenda_esp_on/utils/prefs.dart';
import 'package:http/http.dart' as http;

class HoraApi{

  static Future<List<String>> listaHora() async {

    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }
    var _token = await _buscarToken();

    var setup = Setups();

    var url = Uri.parse(setup.conexao + '/horas_disponiveis');

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };

    var response = await http.get(url, headers: header);

    List<String> listaHoras = [];

    switch (response.statusCode) {
      case 200:
        String body = utf8.decode(response.bodyBytes);

        var mapResponse = json.decode(body).cast<Map<String, dynamic>>();

        for (var item in mapResponse) {
          listaHoras.add(item['hora']);
        }
    }
    return listaHoras;
  }

  static Future<Hra> buscaIdHora(String hora) async {
    int id = 0;
    Hra hra = Hra(id, hora);

    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }
    var _token = await _buscarToken();

    var setup = Setups();

    var url = Uri.parse(setup.conexao + '/horas_disponiveis');

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };

    var response = await http.get(url, headers: header);

    List<String> listaHoras = [];

    switch (response.statusCode) {
      case 200:
        String body = utf8.decode(response.bodyBytes);

        var mapResponse = json.decode(body).cast<Map<String, dynamic>>();

        for (var item in mapResponse) {
          listaHoras.add(item['hora']);
          if (hora == item['hora']) {
            hra.id = item['id'];
            hra.hora = item['hora'];
            Hra.clear();
            hra.save();
          }
        }
    }
    return hra;
  }
}