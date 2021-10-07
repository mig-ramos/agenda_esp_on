import 'dart:convert';
import 'package:agenda_esp_on/models/especialidade_aux.dart';
import 'package:http/http.dart' as http;
import 'package:agenda_esp_on/configurations/setup.dart';
import 'package:agenda_esp_on/models/especialidade.dart';
import 'package:agenda_esp_on/utils/prefs.dart';

class EspecialidadeApi {
  static Future<List<Especialidade>> listaEspecialidades() async {
    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }

    var _token = await _buscarToken();

    var setup = Setups();

    var url = Uri.parse(setup.conexao + '/especialidades');

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };

    var response = await http.get(url, headers: header);

    Especialidade.clear();
    List<Especialidade> esps = [];

    EspecialidadeAux.clear();
    List<EspecialidadeAux> dropEspecialidades = [];

    int status = response.statusCode;

    switch (status) {
      case 200:
        String body = utf8.decode(response.bodyBytes);
        print(body);
        final jsonData = jsonDecode(body).cast<Map<String, dynamic>>();
        print(jsonData);

        for (var item in jsonData) {
          esps.add(Especialidade(
              id: item['id'],
              nome: item['nome'],
              descricao: item['descricao']));
          dropEspecialidades.add(EspecialidadeAux(nome: item['nome']));
          print(item['nome']);
        }
        final dropEsp = dropEspecialidades;
        EspecialidadeAux.clear();
        print('Printando a lista: $dropEsp');
        break;
      case 403:
        print('Conexão encerrada.. Entre novamente');
        break;
      default:
        throw Exception('Falha na conexão');
    }

    return esps;
  }

  static Future<List<String>?> dropEspecialidades(String nome) async {
    int id = 0;
    Especial espe = Especial(id, nome);



    List<String> dropEspecialidades = [];
    dropEspecialidades = ['Buscar..'];

    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }

    var _token = await _buscarToken();

    var setup = Setups();

    var url = Uri.parse(setup.conexao + '/especialidades');

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };

    var response = await http.get(url, headers: header);

    int status = response.statusCode;

    switch (status) {
      case 200:
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body).cast<Map<String, dynamic>>();

        for (var item in jsonData) {
          dropEspecialidades.add((item['nome']));
          if (nome == item['nome']){
            espe.id = item['id'];
            espe.nome = item['nome'];
            Especial.clear();
            espe.save();
          }
        }

        break;
      case 403:
        print('Conexão encerrada.. Entre novamente');
        break;
      default:
        throw Exception('Falha na conexão');
    }

    return dropEspecialidades;
  }
}
