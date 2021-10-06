import 'dart:convert' as convert;

import 'package:agenda_esp_on/utils/prefs.dart';

class Medico {
  late String email;
  late String senha;
  late String codigo;
  late String instante;
  late bool ativo;
  late List<String> perfil;
  late String nome;
  late String dataNascimento;
  late String crm;
  late String dataInscricao;
  late int especialidadeId;

  Medico(
      {required this.email,
        required this.senha,
        required this.codigo,
        required this.instante,
        required this.ativo,
        required this.perfil,
        required this.nome,
        required this.dataNascimento,
        required this.crm,
        required this.dataInscricao,
        required this.especialidadeId, id});

  Medico.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    senha = json['senha'];
    codigo = json['codigo'];
    instante = json['instante'];
    ativo = json['ativo'];
    perfil = json['perfil'] != null ? json['perfil'].cast<String>() : null;
    nome = json['nome'];
    dataNascimento = json['data_nascimento'];
    crm = json['crm'];
    dataInscricao = json['data_inscricao'];
    especialidadeId = json['especialidade_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['codigo'] = this.codigo;
    data['instante'] = this.instante;
    data['ativo'] = this.ativo;
    data['perfis'] = this.perfil;
    data['nome'] = this.nome;
    data['data_nascimento'] = this.dataNascimento;
    data['crm'] = this.crm;
    data['data_inscricao'] = this.dataInscricao;
    data['especialidade_id'] = this.especialidadeId;
    return data;
  }

  static void clear() {
    Prefs.setString("medico.prefs", "");
  }

  void save() {
    Map map = toJson();

    String json = convert.json.encode(map);

    Prefs.setString("medico.prefs", json);
  }

  static Future<Medico?> get() async {
    String json = await Prefs.getString("medico.prefs");
    if(json.isEmpty) {
      return null;
    }
    Map<String, String> map = convert.json.decode(json);
    Medico medico = Medico.fromJson(map);
    return medico;
  }

  @override
  String toString() {
    return 'Medico{email: $email, senha: $senha, codigo: $codigo, instante: $instante, ativo: $ativo, perfil: $perfil, nome: $nome, dataNascimento: $dataNascimento, crm: $crm, dataInscricao: $dataInscricao, especialidadeId: $especialidadeId}';
  }
}