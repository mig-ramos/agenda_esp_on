import 'package:agenda_esp_on/utils/prefs.dart';
import 'dart:convert' as convert;

class Usuario {
  late int id;
  late String nome;
  late String email;
  late String senha;
  late String codigo;
  late String instante;
  late bool ativo;
  late List<dynamic> perfis;
  late String dataNascimento;
  late int crm;
  late String dataInscricao;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.codigo,
    required this.instante,
    required this.ativo,
    required this.perfis,
    required this.dataNascimento,
    required this.crm,
    required this.dataInscricao,
  });

  Usuario.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    nome = json['nome'];
    email = json['email'];
    senha = json['senha'];
    codigo = json['codigo'];
    instante = json['instante'];
    ativo = json['ativo'];
    perfis = json['perfis'];
    dataNascimento = (json['data_nascimento'] ?? '');
    crm = (json['crm'] ?? 0);
    dataInscricao = (json['data_inscricao'] ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['codigo'] = this.codigo;
    data['instante'] = this.instante;
    data['ativo'] = this.ativo;
    data['perfis'] = this.perfis;
    data['data_nascimento'] = this.dataNascimento;
    data['crm'] = this.crm;
    data['data_inscricao'] = this.dataInscricao;
    return data;
  }

  static void clear() {
    Prefs.setString("usuario.prefs", "");
  }

  void save() {
    Map map = toJson();

    String json = convert.json.encode(map);

    Prefs.setString("usuario.prefs", json);
  }

  static Future<Usuario?> get() async {
    String json = await Prefs.getString("usuario.prefs");
    if (json.isEmpty) {
      return null;
    }
    Map<String, dynamic> map = convert.json.decode(json);
    Usuario usuario = Usuario.fromJson(map);
    return usuario;
  }

  @override
  String toString() {
    return 'Usuario{id: $id, nome: $nome, email: $email, senha: $senha, codigo: $codigo, instante: $instante, ativo: $ativo, perfis: $perfis, dataNascimento: $dataNascimento, crm: $crm, dataInscricao: $dataInscricao}';
  }
}
