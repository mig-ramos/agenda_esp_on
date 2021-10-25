import 'dart:convert';
import 'package:agenda_esp_on/models/especialidade_aux.dart';
import 'package:agenda_esp_on/models/especialidade_lista.dart';
import 'package:http/http.dart' as http;
import 'package:agenda_esp_on/configurations/setup.dart';
import 'package:agenda_esp_on/models/especialidade.dart';
import 'package:agenda_esp_on/utils/prefs.dart';

import 'medico_api.dart';

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
        //      print(body);
        final jsonData = jsonDecode(body).cast<Map<String, dynamic>>();
        //       print(jsonData);

        for (var item in jsonData) {
          esps.add(Especialidade(
              id: item['id'],
              nome: item['nome'],
              descricao: item['descricao']));
          dropEspecialidades.add(EspecialidadeAux(nome: item['nome']));
          //      print(item['nome']);
        }
        final dropEsp = dropEspecialidades;
        EspecialidadeAux.clear();
        //    print('Printando a lista: $dropEsp');
        break;
      case 403:
        print('Conexão encerrada.. Entre novamente');
        break;
      default:
        throw Exception('Falha na conexão');
    }

    return esps;
  }

  static Future<List<EspecialidadeLista>> listEspecialidades() async {
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

    List<EspecialidadeLista> listaEspe = [];

    int status = response.statusCode;

    switch (status) {
      case 200:
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body).cast<Map<String, dynamic>>();
        for (var item in jsonData) {
          listaEspe.add(EspecialidadeLista(
              id: item['id'],
              nome: item['nome'],
              descricao: item['descricao']));
        }
        break;
      case 403:
    //    print('Conexão encerrada.. Entre novamente');
        break;
      default:
        throw Exception('Falha na conexão');
    }
    return listaEspe;
  }

  static Future<List<String>?> dropEspecialidades(String nome) async {
    int id = 0;
    Especial espe = Especial(id, nome);
    // Especial.clear();
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
        Especial.clear();
        for (var item in jsonData) {
          dropEspecialidades.add((item['nome']));
          if (nome == item['nome']) {
            espe.id = item['id'];
            espe.nome = item['nome'];
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

  static Future<int> delEspecialidade(id) async {
    final _id = id;

    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }

    var _token = await _buscarToken();

    var setup = Setups();

    var url = Uri.parse(setup.conexao + "/especialidades/+$_id");

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };

    var response = await http.delete(url, headers: header);

    return response.statusCode;
  }

  static Future<http.Response> saveEspe(int id, String nome, String descricao) async {

    int _id = id;
    String _nome = nome;
    String _descricao = descricao;

    var setup = Setups();
    var _token;
    var url = '';

      Future<dynamic> _buscarToken() async {
        var setup = await Prefs.getString('user.prefs');
        Map<String, dynamic> mapResponse = json.decode(setup);
        return (mapResponse['token']);
      }
      _token = await _buscarToken();

      if(_id==0){
        url = setup.conexao + '/especialidades';
      } else{
        url = setup.conexao + '/especialidades/$_id';
      }

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };

    Map params;
    if (id == 0) {
         params = {
          "nome": _nome,
          "descricao": _descricao
        };
      } else {
        params = {
          "nome": _nome,
          "descricao": _descricao
        };
      }

    var _body = utf8.encode(json.encode(params));
    var response = await (id == 0
        ? http.post(Uri.parse(url), headers: header, body: _body)
        : http.put(Uri.parse(url), headers: header, body: _body));

    return response;
  }
}
