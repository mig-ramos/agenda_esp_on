import 'package:agenda_esp_on/utils/prefs.dart';
import 'dart:convert' as convert;

class TipoConsulta {
  late int id;
  late String tipoConsulta;

  TipoConsulta({required this.id, required this.tipoConsulta});

  TipoConsulta.fromJson(Map<String, dynamic> json) {
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
    Prefs.setString("usuario.prefs", "");
  }

  void save() {
    Map map = toJson();

    String json = convert.json.encode(map);

    Prefs.setString("tipoConsulta.prefs", json);
  }

  static Future<TipoConsulta?> get() async {
    String json = await Prefs.getString("tipoConsulta.prefs");
    if (json.isEmpty) {
      return null;
    }
    Map<String, String> map = convert.json.decode(json);
    TipoConsulta tipoConsulta = TipoConsulta.fromJson(map);
    return tipoConsulta;
  }

  @override
  String toString() {
    return 'TipoConsulta{id: $id, tipoConsulta: $tipoConsulta}';
  }
}
