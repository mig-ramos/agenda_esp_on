import 'package:agenda_esp_on/utils/prefs.dart';
import 'dart:convert' as convert;
///
/// Configuração da url API
///
class Setups {
  var _conexao = 'http://192.168.15.15:8080';
  // var url = Uri.parse('https://agenda-online-tcc.herokuapp.com');
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
