import 'package:agenda_esp_on/utils/prefs.dart';
import 'dart:convert' as convert;

class Especialidade {
  late int id;
  late String nome;
  late String descricao;
  late List<dynamic> medicos;

  Especialidade({required this.id, required this.nome, required this.descricao});

  Especialidade.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
    medicos = json['medicos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    data['medicos'] = this.medicos;
    return data;
  }

  static void clear() {
    Prefs.setString("especialidade.prefs", "");
  }

  void save() {
    Map map = toJson();

    String json = convert.json.encode(map);

    Prefs.setString("especialidade.prefs", json);
  }

  static Future<Especialidade?> get() async {
    String json = await Prefs.getString("especialidade.prefs");
    if (json.isEmpty) {
      return null;
    }
    Map<String, String> map = convert.json.decode(json);
    Especialidade especialidade = Especialidade.fromJson(map);
    return especialidade;
  }

  @override
  String toString() {
    return 'Especialidade{id: $id, nome: $nome, descricao: $descricao, medicos: $medicos}';
  }
}