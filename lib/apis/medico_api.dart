import 'dart:convert';
import 'package:agenda_esp_on/configurations/setup.dart';
import 'package:agenda_esp_on/utils/prefs.dart';
import 'package:http/http.dart' as http;

class MedicoApi {

  static Future<List<String>?> dropMedicosPorEspe(String nome) async {
    int id = 0;
    Especial.clear();
    Especial espe = Especial(id, nome);

    List<String> drop = [];
    List<String> drops = [];

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
          drop.add((item['nome']));
          if (nome == item['nome']){
         //    print('O ID: ${item['id']} O NOME:${item['nome']}');
            drops =  await MedicoApi.dropMedicos(item['id']) as List<String>;
          }
        }

        break;
      case 403:
        print('Conexão encerrada.. Entre novamente');
        break;
      default:
        throw Exception('Falha na conexão');
    }

    return drops;
  }

  static Future<List<String>?> dropMedicos(int especialidade) async {
    int _id = especialidade;
    List<String> dropMedicos = [];
    dropMedicos = ['Buscar..'];

    late List<dynamic> _medicos;

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

    switch (response.statusCode) {
      case 200:
        String body = utf8.decode(response.bodyBytes);
        Map mapResponse = json.decode(body);
        _medicos = mapResponse["medicos"];

        for (int i = 0; i < _medicos.length; i++) {
    //    print('Nome do médico: ${mapResponse["medicos"][i]["nome"]}');
          dropMedicos.add(mapResponse["medicos"][i]["nome"]);
        }
        break;
      case 404:
        dropMedicos = [];
        dropMedicos = ['Buscar..'];
    //    print('Especialidade não encontrada..');
        break;
      default:
        throw Exception('Falha na conexão');
    }

    return dropMedicos;
  }

  static Future<Medic> buscaIdMedico(String nome) async {
    int id = 0;
    Medic medi = Medic(id, nome);

    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }

    var _token = await _buscarToken();

    var setup = Setups();

    var url = Uri.parse(setup.conexao + '/medicos');

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
          if (nome == item['nome']) {
            medi.id = item['id'];
            medi.nome = item['nome'];
            Medic.clear();
            medi.save();
          }
        }

        break;
      case 403:
        print('Conexão encerrada.. Entre novamente');
        break;
      default:
        throw Exception('Falha na conexão');
    }
    return medi;
  }

  static Future<int> saveMedi(int id, String nome, String email, String senha, String codigo,String crm, String dataInscricao, int idEspe) async {

    int _id = id;
    String _nome = nome;
    String _email = email;
    String _senha = senha;
    String _codigo = codigo;
    String _crm = crm;
    String _dataInscricao = dataInscricao;
    int _idEspecialidade = idEspe;

    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }
    var _token = await _buscarToken();

    var setup = Setups();

    var url = '';

    if (_id == 0){
      url = setup.conexao+'/medicos';
    } else {
      url = setup.conexao+'/medicos/'+_id;
    }

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": _token
    };

    Map params;
    if (_id == 0) {
      params = {
        "email": _email,
        "senha": _senha,
        "codigo": _codigo,
        "instante": "",
        "ativo": true,
        "perfil": {
          "id": 2,
          "nome": "MEDICO"
        },
        "nome": _nome,
        "crm": _crm,
        "data_inscricao": _dataInscricao,
        "especialidade_id": _idEspecialidade
      };
    } else {
      params = {
        "id": _id,
        "email": _email,
        "senha": _senha,
        "codigo": _codigo,
        "instante": "",
        "ativo": true,
        "perfil": {
          "id": 2,
          "nome": "MEDICO"
        },
        "nome": _nome,
        "crm": _crm,
        "data_inscricao": _dataInscricao,
        "especialidade_id": _idEspecialidade
      };
    }
   // print("Parametros: $params");
    var _body = json.encode(params);
  // print("json a ser enviado: $_body");
    var response = await (_id == 0
        ? http.post(Uri.parse(url), headers: header, body: _body)
        : http.put(Uri.parse(url), headers: header, body: _body));
   //    print('Response status: ${response.statusCode}');
    return response.statusCode;
  }
}
