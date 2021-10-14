class Agendamentos {
  late String id;
  late String especial;
  late String medico;
  late String usuario;
  late String data;
  late String hora;
  late String motivo;
  late String ultimaAlteracao;
  late String observacao;


  Agendamentos(id, especial, medico, usuario, data, hora, motivo, ultimaAlteracao, observacao) {
    this.id = id;
    this.especial = especial;
    this.medico = medico;
    this.usuario = usuario;
    this.data = data;
    this.hora = hora;
    this.motivo = motivo;
    this.ultimaAlteracao = ultimaAlteracao;
    this.observacao = observacao;
  }

  @override
  String toString() {
    return 'Agendamentos{id: $id, especial: $especial, medico: $medico, usuario: $usuario, data: $data, hora: $hora, motivo: $motivo, ultimaAlteracao: $ultimaAlteracao, observacao: $observacao}';
  }
}


