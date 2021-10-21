import 'package:agenda_esp_on/configurations/setup.dart';
import 'package:agenda_esp_on/models/usuario.dart';
import 'package:agenda_esp_on/models/usuario_lista.dart';
import 'package:agenda_esp_on/utils/prefs.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsuarioApi {
  late final perfilUser;

  static Future<Usuario?> bucarUsuPorEmail(
      String email, String senha, String token) async {
    String _token = token;
    int _id = 0;
    String _nome = '';
    String _email = email;
    String _senha = senha;
    String _codigo = '';
    String _instante = '';
    bool _ativo = false;
    List<dynamic> _perfis = [];
    String _data_nascimento = '';
    int _crm;
    String _data_inscricao = '';

    var setup = Setups();
    var url = Uri.parse(setup.conexao + '/usuarios/email?value=$_email');

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };

    var response = await http.get(url, headers: header);
    //  print(' PRINT 2 ====  Response status API usuário: ${response.statusCode}');
    String body = utf8.decode(response.bodyBytes);
    // print(body);
    final mapResponse = jsonDecode(body);

    _id = mapResponse["id"];
    _nome = mapResponse["nome"] as String;
    _email = mapResponse["email"] as String;
    _senha = senha;
    _codigo = mapResponse["codigo"] as String;
    _instante = mapResponse["instante"] as String;
    _ativo = mapResponse["ativo"] as bool;
    _perfis = mapResponse["perfis"];

    if (_perfis.contains("PACIENTE")) {
      _data_nascimento = mapResponse["data_nascimento"] as String;

      Map<String, dynamic> mapUser = {
        "id": _id,
        "nome": _nome,
        "email": _email,
        "senha": _senha,
        "codigo": _codigo,
        "instante": _instante,
        "ativo": _ativo,
        "perfis": _perfis,
        "data_nascimento": _data_nascimento,
      };
      final usuario = Usuario.fromJson(mapUser) as Usuario;

      Usuario.clear();

      if (response.statusCode == 200) {
        usuario.save();
      }

      return usuario;
    } else if (_perfis.contains("MEDICO")) {
      _crm = mapResponse["crm"];
      _data_inscricao = mapResponse["data_inscricao"] as String;

      Map<String, dynamic> mapUser = {
        "id": _id,
        "nome": _nome,
        "email": _email,
        "senha": _senha,
        "codigo": _codigo,
        "instante": _instante,
        "ativo": _ativo,
        "perfis": _perfis,
        "crm": _crm,
        "data_inscricao": _data_inscricao
      };
      final usuario = Usuario.fromJson(mapUser) as Usuario;

      Usuario.clear();

      if (response.statusCode == 200) {
        usuario.save();
      }

      return usuario;
    } else if (_perfis.contains("ADMIN")) {
      Map<String, dynamic> mapUser = {
        "id": _id,
        "nome": _nome,
        "email": _email,
        "senha": _senha,
        "codigo": _codigo,
        "instante": _instante,
        "ativo": _ativo,
        "perfis": _perfis,
      };
      final usuario = Usuario.fromJson(mapUser) as Usuario;

      Usuario.clear();

      if (response.statusCode == 200) {
        usuario.save();
      }

      return usuario;
    }
    return null;
  }
  ///
  /// Cadastra Usuário
  ///
  static Future<http.Response> saveUsu(int id, String nome, String email,
      String senha, DateTime data, String crm) async {
    DBCrypt dBCrypt = DBCrypt();
    String senha_h = dBCrypt.hashpw(senha, dBCrypt.gensalt());
    String salt = dBCrypt.gensaltWithRounds(10);
    senha_h = dBCrypt.hashpw(senha, salt);
    int _id = id;
    String _nome = nome;
    String _email = email;
    String _senha = senha;
    String _senha_c = senha_h;
    String _codigo = '';
    String _instante = '';
    bool _ativo = true;
    List<dynamic> _perfis = [];
    String _data = dateTostring(data);
    var _crm = crm;
    if (_crm == '0') {
      _perfis = ['PACIENTE'];
     } else {
      _perfis = ['MEDICO'];
    }
    int _espeId = 0;

    var setup = Setups();
    var _token;
    var url = '';

    if (_id == 0) {
      url = setup.conexao + '/pacientes';
    } else {
      Future<dynamic> _buscarToken() async {
        var setup = await Prefs.getString('user.prefs');
        Map<String, dynamic> mapResponse = json.decode(setup);
        return (mapResponse['token']);
      }
      _token = await _buscarToken();
      if(crm == '0'){
        url = setup.conexao + '/pacientes/$_id';
      } else {
        url = setup.conexao + '/medicos/$_id';
      }
    }

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8"
    };

    var header_t = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };

    Map params;
    if (id == 0) {
      if(crm == '0'){
        params = {
          "nome": _nome,
          "email": _email,
          "senha": _senha,
          "codigo": _codigo,
          "instante": _instante,
          "ativo": _ativo,
          "perfis": _perfis,
          "data_nascimento": _data
        };
      } else {
        params = {
          "nome": _nome,
          "email": _email,
          "senha": _senha,
          "codigo": _codigo,
          "instante": _instante,
          "ativo": _ativo,
          "perfis": _perfis,
          "crm": _crm,
          "data_inscricao": _data,
          "especialidade_id": _espeId
        };
      }
    } else {
      if(crm == '0') {
        params = {
          "nome": _nome,
          "email": _email,
          "senha": _senha_c,
          "data_nascimento": _data
        };
      } else {
        params = {
          "nome": _nome,
          "email": _email,
          "senha": _senha_c,
          "crm": _crm,
          "data_inscricao": _data
        };
      }
    }
    //   print("Parametros: $params");
    var _body = utf8.encode(json.encode(params));
    //   print("json a ser enviado: $_body");
    var response = await (id == 0
        ? http.post(Uri.parse(url), headers: header, body: _body)
        : http.put(Uri.parse(url), headers: header_t, body: _body));
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    switch (response.statusCode) {
      case 204:
        // Se foi alterado com sussesso - atualiza a tela de edição.
        await UsuarioApi.bucarUsuPorEmail(_email, _senha, _token);
        break;
    }
    return response;
  }

  static Future<http.Response> mudaSenhaUsu(int id, String senha, String nome,
      String email, DateTime dataNascimento) async {
    DBCrypt dBCrypt = DBCrypt();
    String senha_h = dBCrypt.hashpw(senha, dBCrypt.gensalt());
    String salt = dBCrypt.gensaltWithRounds(10);
    senha_h = dBCrypt.hashpw(senha, salt);
    int _id = id;
    String _nome = nome;
    String _email = email;
    String _senha = senha;
    String _senha_c = senha_h;
    String _data_nascimento = dateTostring(dataNascimento);
    var setup = Setups();

    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }

    var _token = await _buscarToken();

    var url = '';

    url = setup.conexao + '/pacientes/$_id';

    var header_t = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };

    Map params;

    params = {
      "nome": _nome,
      "email": _email,
      "senha": _senha_c,
      "data_nascimento": _data_nascimento
    };

    var _body = utf8.encode(json.encode(params));

    var response =
        await http.put(Uri.parse(url), headers: header_t, body: _body);

    switch (response.statusCode) {
      case 204:
        // Se foi alterado com sussesso - atualiza a tela de edição.
        await UsuarioApi.bucarUsuPorEmail(_email, _senha, _token);
        break;
    }
    return response;
  }

  static String dateTostring(DateTime dataNascimento) {
    String _stringdate = "";
    _stringdate = dataNascimento.day.toString() +
        "/" +
        dataNascimento.month.toString() +
        "/" +
        dataNascimento.year.toString();
    return _stringdate;
  }

  static Future<http.Response> mudaSenhaMedi(
      int id, String senha, String nome, String email) async {
    DBCrypt dBCrypt = DBCrypt();
    String senha_h = dBCrypt.hashpw(senha, dBCrypt.gensalt());
    String salt = dBCrypt.gensaltWithRounds(10);
    senha_h = dBCrypt.hashpw(senha, salt);
    int _id = id;
    String _nome = nome;
    String _email = email;
    String _senha = senha;
    String _senha_c = senha_h;
    var setup = Setups();

    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }

    var _token = await _buscarToken();

    var url = '';

    url = setup.conexao + '/medicos/$_id';

    var header_t = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };

    Map params;

    params = {
      "nome": _nome,
      "email": _email,
      "senha": _senha_c,
    };

    var _body = utf8.encode(json.encode(params));

    var response =
        await http.put(Uri.parse(url), headers: header_t, body: _body);

    switch (response.statusCode) {
      case 204:
        // Se foi alterado com sussesso - atualiza a tela de edição.
        await UsuarioApi.bucarUsuPorEmail(_email, _senha, _token);
        break;
    }
    return response;
  }

  static Future<http.Response> mudaSenhaAdm(
      int id, String senha, String nome, String email) async {
    DBCrypt dBCrypt = DBCrypt();
    String senha_h = dBCrypt.hashpw(senha, dBCrypt.gensalt());
    String salt = dBCrypt.gensaltWithRounds(10);
    senha_h = dBCrypt.hashpw(senha, salt);
    int _id = id;
    String _nome = nome;
    String _email = email;
    String _senha = senha;
    String _senha_c = senha_h;
    var setup = Setups();

    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }

    var _token = await _buscarToken();

    var url = '';

    url = setup.conexao + '/usuarios/$_id';

    var header_t = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };

    Map params;

    params = {
      "nome": _nome,
      "email": _email,
      "senha": _senha_c,
    };

    var _body = utf8.encode(json.encode(params));

    var response =
        await http.put(Uri.parse(url), headers: header_t, body: _body);

    switch (response.statusCode) {
      case 204:
        // Se foi alterado com sussesso - atualiza a tela de edição.
        await UsuarioApi.bucarUsuPorEmail(_email, _senha, _token);
        break;
    }
    return response;
  }

  static Future<List<UsuarioLista>> listaUsuarios() async {
    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }

    var _token = await _buscarToken();
    var setup = Setups();
    var url = Uri.parse(setup.conexao +
        '/usuarios/page?linesPerPage=20&page=0&orderBy=id&direction=DESC');

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };

    final response = await http.get(url, headers: header);

    List<UsuarioLista> listaUsu = [];

    switch (response.statusCode) {
      case 200:
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        for (var item in jsonData['content']) {
          listaUsu.add(UsuarioLista(
              id: item['id'],
              nome: item['nome'],
              email: item['email'],
              senha: item['senha']));
        }
        break;
      case 403:
    //    print('Conexão encerrada.. Entre novamente');
        break;
      default:
        throw Exception('Falha na conexão');
    }

    return listaUsu;
  }

  static Future<List<UsuarioLista>> listaMedicos() async {
    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }

    var _token = await _buscarToken();
    var setup = Setups();
    var url = Uri.parse(setup.conexao +
        '/medicos/page?linesPerPage=20&page=0&orderBy=nome&direction=ASC');

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };

    final response = await http.get(url, headers: header);

    List<UsuarioLista> listaUsu = [];

    switch (response.statusCode) {
      case 200:
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        for (var item in jsonData['content']) {
          listaUsu.add(UsuarioLista(
              id: item['id'],
              nome: item['nome'],
              email: item['email'],
              senha: item['senha']));
        }
        break;
      case 403:
  //      print('Conexão encerrada.. Entre novamente');
        break;
      default:
        throw Exception('Falha na conexão');
    }

    return listaUsu;
  }

  static Future<List<UsuarioLista>> listaPacientes() async {
    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }

    var _token = await _buscarToken();
    var setup = Setups();
    var url = Uri.parse(setup.conexao +
        '/pacientes/page?linesPerPage=20&page=0&orderBy=nome&direction=ASC');

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };

    final response = await http.get(url, headers: header);

    List<UsuarioLista> listaUsu = [];

    switch (response.statusCode) {
      case 200:
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        for (var item in jsonData['content']) {
          listaUsu.add(UsuarioLista(
              id: item['id'],
              nome: item['nome'],
              email: item['email'],
              senha: item['senha']));
        }
        break;
      case 403:
   //     print('Conexão encerrada.. Entre novamente');
        break;
      default:
        throw Exception('Falha na conexão');
    }

    return listaUsu;
  }

  static Future<int> delUsuario(id) async {
    final _id = id;

    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }

    var _token = await _buscarToken();
    var setup = Setups();

    var url = Uri.parse(setup.conexao + "/usuarios/+$_id");

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": "$_token"
    };

    var perfil = await Usuario.get();

    if (perfil!.perfis.contains('ADMIN') && _id == 1) {
      return 403;
    } else {
      var response = await http.delete(url, headers: header);
  //    print(response.statusCode);
      return response.statusCode;
    }
  }
}
