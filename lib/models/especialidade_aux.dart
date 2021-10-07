import 'package:agenda_esp_on/utils/prefs.dart';
import 'dart:convert' as convert;

class EspecialidadeAux{

  late String nome;

  EspecialidadeAux({required this.nome});

  EspecialidadeAux.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
     data['nome'] = this.nome;
    return data;
  }

  static void clear() {
    Prefs.setString("especialidadeNome.prefs", "");
  }

  void save() {
    Map map = toJson();
    String json = convert.json.encode(map);
    Prefs.setString("especialidadeNome.prefs", json);
  }

  static Future<EspecialidadeAux?> get() async {
    String json = await Prefs.getString("especialidadeNome.prefs");
    if(json.isEmpty) {
      return null;
    }
    Map<String, String> map = convert.json.decode(json);
    EspecialidadeAux especialidadeAux = EspecialidadeAux.fromJson(map);
    return especialidadeAux;
  }

  @override
  String toString() {
    return 'EspecialidadeAux{nome: $nome}';
  }

}