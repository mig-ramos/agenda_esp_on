import 'dart:convert' as convert;

import 'package:agenda_esp_on/utils/prefs.dart';

class Hora {
  late int id;
  late String hora;

  Hora({required this.id, required this.hora});

  Hora.fromJson(Map<String, dynamic> json) {
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

  static Future<Hora?> get() async {
    String json = await Prefs.getString("usuario.prefs");
    if(json.isEmpty) {
      return null;
    }
    Map<String, String> map = convert.json.decode(json);
    Hora hora = Hora.fromJson(map);
    return hora;
  }

  @override
  String toString() {
    return 'Hora{id: $id, hora: $hora}';
  }
}