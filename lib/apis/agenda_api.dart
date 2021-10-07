import 'dart:convert';
import 'package:agenda_esp_on/configurations/setup.dart';
import 'package:agenda_esp_on/utils/prefs.dart';
import 'package:http/http.dart' as http;
import 'package:agenda_esp_on/models/agendamentos.dart';

import 'hora_api.dart';

class AgendaApi {
  static Future<List<Agendamentos>> getAgenda() async {
    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }

    var _token = await _buscarToken();

    var setup = Setups();

    var url = Uri.parse(setup.conexao +
        '/agendamentos/paciente?linesPerPage=8&page=0&direction=DESC');

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };
    final response = await http.get(url, headers: header);

    List<Agendamentos> agendamentos = [];

    switch (response.statusCode) {
      case 200:
        String body = utf8.decode(response.bodyBytes);
        final mapResponse = jsonDecode(body);
        print(mapResponse['content'][0]['medico']['nome']);

        for (var item in mapResponse['content']) {
          print(item['especialidade']['nome']);
          agendamentos.add(Agendamentos(
              item['id'].toString(),
              item['especialidade']['nome'],
              item['medico']['nome'],
              item['dataDisponivel'],
              item['hora']['hora'],
              item['tipoConsulta']['tipoConsulta']));
        }
        //   print(agendamentos);
        return agendamentos;
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
    var _token = await _buscarToken();

    var setup = Setups();

   var url = Uri.parse(setup.conexao +"/agendamentos/+$_id");

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };

    var response = await http.delete(url, headers: header);

    return response.statusCode;
  }

  static Future<List<String>?> dropHoras(
      String dropMedicoValue, String data) async {
    List<String>? dropHoras = [];
    dropHoras = ['Buscar..'];
    var listaHoras = await HoraApi.listaHora();

    print('Print lista de horas: $listaHoras');

    List<Agendamentos> listaAgenda = await getAgenda();
    print('Printando lista de agendamentos: $listaAgenda');

    if (listaAgenda.length > 0) {
      for (int i = 0; i < listaAgenda.length; i++) {
        // print('Print dropMedicoValue: $dropMedicoValue = Médico da Agenda: ${listaAgenda[i].medico}');
        // print('Print dropData: $data = Data da Agenda: ${listaAgenda[i].data}');
        if (dropMedicoValue == listaAgenda[i].medico &&
            data == listaAgenda[i].data) {
          listaHoras.remove(listaAgenda[i].hora);
          print(
              'Print dropMedicoValue: $dropMedicoValue = Médico da Agenda: ${listaAgenda[i].medico}');
        }
      }
    }
    dropHoras += listaHoras;
    return dropHoras;
  }

  static Future<int> salvaAgenda(String dataDisponivel, int idEspe, int idTipo, int idMedi, int idHora) async {

    int _id = 0;

    int _idEspe = idEspe;
    int _idMedi = idMedi;
    String _data = dataDisponivel;
    int _idHr = idHora;
    int _idCons = idTipo;
    // Usu _usu = Usu(id: _idUsu, email: _emailUsu, nome: _nomeUsu);
    Usu _usu = Usu(id: 2, email: 'p.ephemeris@gmail.com', nome: 'Miguel Arcanjo Ramos');
    String _obs = '';


    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }
    var _token = await _buscarToken();

    var setup = Setups();

    var url = '';

    if (_id == 0){
      url = setup.conexao+'/agendamentos';
    } else {
      url = setup.conexao+'/agendamentos/'+_id;
    }

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": _token
    };

    Map params;
    if (_id == 0) {
      params = {
        "especialidade": {'id':_idEspe},
        "medico": {'id':_idMedi},
        "dataDisponivel": _data,
        "hora": {'id': _idHr},
        "tipoConsulta": {'id': _idCons},
        "usuario": _usu,
        //   "observacao": _obs,
      };
    } else {
      params = {
        "id": _id,
        "especialidade": {'id':_idEspe},
        "medico": {'id':_idMedi},
        "dataDisponivel": _data,
        "hora": {'id': _idHr},
        "tipoConsulta": {'id': _idCons},
        "usuario": _usu,
        "observacao": _obs,
      };
    }

    print("Parametros: $params");

    var _body = json.encode(params);
    print("json a ser enviado: $_body");

    var response = await (_id == 0
        ? http.post(Uri.parse(url), headers: header, body: _body)
        : http.put(Uri.parse(url), headers: header, body: _body));

    print('Response status: ${response.statusCode}');

    return response.statusCode;
  }

}
