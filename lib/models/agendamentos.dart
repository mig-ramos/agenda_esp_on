import 'package:agenda_esp_on/utils/prefs.dart';
import 'dart:convert' as convert;

class Agendamentos {
  late int id;
  late int idEspecial;
  late String especial;
  late int idMedico;
  late String medico;
  late int idUsuario;
  late String usuario;
  late String data;
  late int idHora;
  late String hora;
  late int idMotivo;
  late String motivo;
  late String ultimaAlteracao;
  late String observacao;

  Agendamentos(id, idEspecial, especial, idMedico, medico, idUsuario, usuario,
      data, idHora, hora, idMotivo, motivo, ultimaAlteracao, observacao) {
    this.id = id;
    this.idEspecial = idEspecial;
    this.especial = especial;
    this.idMedico = idMedico;
    this.medico = medico;
    this.idUsuario = idUsuario;
    this.usuario = usuario;
    this.data = data;
    this.idHora = idHora;
    this.hora = hora;
    this.idMotivo = idMotivo;
    this.motivo = motivo;
    this.ultimaAlteracao = ultimaAlteracao;
    this.observacao = observacao;
  }

  Agendamentos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idEspecial = json['idEspecial'];
    especial = json['especial'];
    idMedico = json['idMedico'];
    medico = json['medico'];
    idUsuario = json['idUsuario'];
    usuario = json['usuario'];
    data = json['data'];
    idHora = json['idHora'];
    hora = json['hora'];
    idMotivo = json['idMotivo'];
    motivo = json['motivo'];
    ultimaAlteracao = json['ultimaAlteracao'];
    observacao = json['observacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idEspecial'] = this.idEspecial;
    data['especial'] = this.especial;
    data['idMedico'] = this.idMedico;
    data['medico'] = this.medico;
    data['idUsuario'] = this.idUsuario;
    data['usuario'] = this.usuario;
    data['data'] = this.data;
    data['idHora'] = this.idHora;
    data['hora'] = this.hora;
    data['idMotivo'] = this.idMotivo;
    data['motivo'] = this.motivo;
    data['ultimaAlteracao'] = this.ultimaAlteracao;
    data['observacao'] = this.observacao;
    return data;
  }

  static void clear() {
    Prefs.setString("agendamento.prefs", "");
  }

  void save() {
    Map map = toJson();
    String json = convert.json.encode(map);
    Prefs.setString("agendamento.prefs", json);
  }

  static Future<Agendamentos?> get() async {
    String json = await Prefs.getString("agendamento.prefs");
    if (json.isEmpty) {
      return null;
    }
    Map<String, String> map = convert.json.decode(json);
    Agendamentos agendamentos = Agendamentos.fromJson(map);
    return agendamentos;
  }

  @override
  String toString() {
    return 'Agendamentos{id: $id, idEspecial: $idEspecial, especial: $especial, idMedico: $idMedico, medico: $medico, idUsuario: $idUsuario, usuario: $usuario, data: $data, idHora: $idHora, hora: $hora, idMotivo: $idMotivo, motivo: $motivo, ultimaAlteracao: $ultimaAlteracao, observacao: $observacao}';
  }
}
