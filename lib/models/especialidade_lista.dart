import 'package:agenda_esp_on/utils/prefs.dart';
import 'dart:convert' as convert;

class EspecialidadeLista {
  late int id;
  late String nome;
  late String descricao;

  EspecialidadeLista({required this.id, required this.nome, required this.descricao});

  EspecialidadeLista.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    return data;
  }

  static void clear() {
    Prefs.setString("especialidadeLista.prefs", "");
  }

  void save() {
    Map map = toJson();

    String json = convert.json.encode(map);

    Prefs.setString("especialidadeLista.prefs", json);
  }

  static Future<EspecialidadeLista?> get() async {
    String json = await Prefs.getString("especialidadeLista.prefs");
    if (json.isEmpty) {
      return null;
    }
    Map<String, String> map = convert.json.decode(json);
    EspecialidadeLista especialidadeLista = EspecialidadeLista.fromJson(map);
    return especialidadeLista;
  }

  @override
  String toString() {
   return 'EspecialidadeLista{id: $id, nome: $nome, descricao: $descricao}';
  }
}