class Agendamentos{

  late String id;
  late String especial;
  late String medico;
  late String data;
  late String hora;
  late String motivo;

  Agendamentos(id, especial, medico, data, hora, motivo){
    this.id = id;
    this.especial = especial;
    this.medico = medico;
    this.data = data;
    this.hora = hora;
    this.motivo = motivo;
  }

  @override
  String toString() {
    return 'Agendamentos{id: $id, especial: $especial, medico: $medico, data: $data, hora: $hora, motivo: $motivo}';
  }
}