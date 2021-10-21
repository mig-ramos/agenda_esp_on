import 'package:agenda_esp_on/utils/prefs.dart';
import 'dart:convert' as convert;
///
/// Configuração da url API
///
class Setups {
 var _conexao = 'http://192.168.15.15:8080';
  // var _conexao = 'https://agenda-online-tcc.herokuapp.com';

  var _cabecalho = {
    "Content-Type": "application/json",
    "Accept-Charset": "utf-8"
  };

  get conexao => _conexao;
  set conexao(value) {
    _conexao = value;
  }

  get cabecalho => _cabecalho;
  set cabecalho(value) {
    _cabecalho = value;
  }

  @override
  String toString() {
    return 'Setups{conexao: $conexao, cabecalho: $cabecalho}';
  }
}

class Especial{
  late int id;
  late String nome;

  Especial(this.id, this.nome);
  Especial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    return data;
  }

  static void clear() {
    Prefs.setString("especial.prefs", "");
  }

  void save() {
    Map map = toJson();

    String json = convert.json.encode(map);

    Prefs.setString("especial.prefs", json);
  }

  static Future<Especial?> get() async {
    String json = await Prefs.getString("especial.prefs");
    if (json.isEmpty) {
      return null;
    }
    Map<String, dynamic> map = convert.json.decode(json);
    Especial especial = Especial.fromJson(map);
    return especial;
  }

  @override
  String toString() {
    return 'Especial{id: $id, nome: $nome}';
  }
}

class Medic{
  late int id;
  late String nome;

  Medic(this.id, this.nome);
  Medic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    return data;
  }

  static void clear() {
    Prefs.setString("medic.prefs", "");
  }

  void save() {
    Map map = toJson();

    String json = convert.json.encode(map);

    Prefs.setString("medic.prefs", json);
  }

  static Future<Medic?> get() async {
    String json = await Prefs.getString("medic.prefs");
    if (json.isEmpty) {
      return null;
    }
    Map<String, dynamic> map = convert.json.decode(json);
    Medic medic = Medic.fromJson(map);
    return medic;
  }

  @override
  String toString() {
    return 'Medic{id: $id, nome: $nome}';
  }
}

class Hra{
  late int id;
  late String hora;

  Hra(this.id, this.hora);
  Hra.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hora = json['hora'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hora'] = this.hora;
    return data;
  }

  static void clear() {
    Prefs.setString("hora.prefs", "");
  }

  void save() {
    Map map = toJson();

    String json = convert.json.encode(map);

    Prefs.setString("hora.prefs", json);
  }

  static Future<Hra?> get() async {
    String json = await Prefs.getString("hora.prefs");
    if (json.isEmpty) {
      return null;
    }
    Map<String, dynamic> map = convert.json.decode(json);
    Hra especial = Hra.fromJson(map);
    return especial;
  }

  @override
  String toString() {
    return 'Hra{id: $id, hora: $hora}';
  }
}

class Motivo{
  late int id;
  late String tipoConsulta;

  Motivo(this.id, this.tipoConsulta);
  Motivo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tipoConsulta = json['tipoConsulta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tipoConsulta'] = this.tipoConsulta;
    return data;
  }

  static void clear() {
    Prefs.setString("motivo.prefs", "");
  }

  void save() {
    Map map = toJson();

    String json = convert.json.encode(map);

    Prefs.setString("motivo.prefs", json);
  }

  static Future<Motivo?> get() async {
    String json = await Prefs.getString("motivo.prefs");
    if (json.isEmpty) {
      return null;
    }
    Map<String, dynamic> map = convert.json.decode(json);
    Motivo motivo = Motivo.fromJson(map);
    return motivo;
  }

  @override
  String toString() {
    return 'Motivo{id: $id, tipoConsulta: $tipoConsulta}';
  }
}

class Usu {
  late int id;
  late String nome;
  late String email;

  Usu({required this.id, required this.nome, required this.email});

  Usu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['email'] = this.email;
    return data;
  }

  static void clear() {
    Prefs.setString("usu.prefs", "");
  }

  void save() {
    Map map = toJson();
    String json = convert.json.encode(map);
    Prefs.setString("usu.prefs", json);
  }

  static Future<Usu?> get() async {
    String json = await Prefs.getString("usu.prefs");
    if (json.isEmpty) {
      return null;
    }
    Map<String, dynamic> map = convert.json.decode(json);
    Usu usu = Usu.fromJson(map);
    return usu;
  }

  @override
  String toString() {
    return 'Usu{id: $id, nome: $nome, email: $email}';
  }
}