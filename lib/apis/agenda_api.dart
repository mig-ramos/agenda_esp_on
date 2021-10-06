import 'dart:convert';
import 'package:agenda_esp_on/configurations/setup.dart';
import 'package:agenda_esp_on/utils/prefs.dart';
import 'package:http/http.dart' as http;
import 'package:agenda_esp_on/models/agendamentos.dart';

class AgendaApi{

  static Future<List<Agendamentos>> getAgenda() async {

    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }
    var _token = await _buscarToken();

    var setup = Setups();

    var url = Uri.parse(setup.conexao+'/agendamentos/paciente?linesPerPage=8&page=0&direction=DESC');

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };
    final response = await http.get(url, headers: header);

    List<Agendamentos> Agendamentoss = [];

    switch (response.statusCode) {
      case 200:
        String body = utf8.decode(response.bodyBytes);
        final mapResponse = jsonDecode(body);
        print(mapResponse['content'][0]['medico']['nome']);


        for (var item in mapResponse['content']) {
          print(item['especialidade']['nome']);
          Agendamentoss.add(Agendamentos(item['id'].toString(),item['especialidade']['nome'],item['medico']['nome'],item['dataDisponivel'],item['hora']['hora'],item['tipoConsulta']['tipoConsulta']));
        }
        print(Agendamentoss);
        return Agendamentoss;
        break;
      default:
        throw Exception('Conexão falhou :(');
    }
  }

  static Future<int> delAgenda(id) async {

    final _id = id;

    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }
    var _token = _buscarToken();

    var setup = Setups();

    var url = setup.conexao+'/agendamentos/$_id';

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };

    var response = await http.delete(url, headers: header);

    return response.statusCode;
  }
}