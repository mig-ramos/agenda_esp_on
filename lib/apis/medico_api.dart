import 'dart:convert';
import 'package:agenda_esp_on/configurations/setup.dart';
import 'package:agenda_esp_on/utils/prefs.dart';
import 'package:http/http.dart' as http;

class MedicoApi {


  static Future<List<String>?> dropMedicos(int especialidade) async {
    int _id = especialidade;
    print('Esse é o Id: $_id');

    List<String> dropMedicos = [];
    dropMedicos = ['Buscar..'];

// late String _nome;
// late String _descricao;
    late List<dynamic> _medicos;
// late String _medico;

    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }
    var _token = await _buscarToken();

    var setup = Setups();

    var url = Uri.parse(setup.conexao + '/especialidades/$_id');

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };

    var response = await http.get(url, headers: header);
    print(
        ' PRINT 2 ====  Response busca Especialidade: ${response.statusCode}');

    switch (response.statusCode) {
      case 200:
        String body = utf8.decode(response.bodyBytes);

        print(body);

        Map mapResponse = json.decode(body);
        print('Resposta do Servidor: $mapResponse');

// id = mapResponse["id"];
// _nome = mapResponse["nome"] as String;
// _descricao = mapResponse["descricao"] as String;
        _medicos = mapResponse["medicos"];

        for (int i = 0; i < _medicos.length; i++) {
          print('Nome do médico: ${mapResponse["medicos"][i]["nome"]}');
          dropMedicos.add(mapResponse["medicos"][i]["nome"]);
        }

//////    print('Os médicos são: ${listaDropMed[1]}');
// Map<String, dynamic> mapUser = {
// "id": _id,
// "nome": _nome,
// "descricao": _descricao,
// "medicos": _medicos,
// };

// final especialidade = Especialidade.fromJson(mapUser) as Especialidade;
//
// Especialidade.clear();
// print('PRINT 4 == $especialidade');
// especialidade.save();

// return listaDropMed;

        break;
      case 404:
        dropMedicos = [];
        dropMedicos = ['Buscar..'];
        print('Especialidade não encontrada..');
        break;
      default:
        throw Exception('Falha na conexão');
    }

    return dropMedicos;
  }
}