import 'package:agenda_esp_on/utils/prefs.dart';
import 'dart:convert' as convert;

class UsuarioLista{
  late int id;
  late String nome;
  late String email;
  late String senha;

  UsuarioLista({
      required this.id,
      required this.nome,
      required this.email,
      required this.senha
});

  UsuarioLista.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    nome = json['nome'];
    email = json['email'];
    senha = json['senha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['senha'] = this.senha;
    return data;
  }

  static void clear() {
    Prefs.setString("usuarioLista.prefs", "");
  }

  void save() {
    Map map = toJson();

    String json = convert.json.encode(map);

    Prefs.setString("usuarioLista.prefs", json);
  }

  static Future<UsuarioLista?> get() async {
    String json = await Prefs.getString("usuarioLista.prefs");
    if (json.isEmpty) {
      return null;
    }
    Map<String, dynamic> map = convert.json.decode(json);
    UsuarioLista usuarioLista = UsuarioLista.fromJson(map);
    return usuarioLista;
  }

  @override
  String toString() {
    return 'Usuario{id: $id, nome: $nome, email: $email, senha: $senha}';
  }
}
