class Agendamentos {
  late String id;
  late String especial;
  late String medico;
  late String data;
  late String hora;
  late String motivo;

  Agendamentos(id, especial, medico, data, hora, motivo) {
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

class Usu {
  late int id;
  late String nome;
  late String email;

  Usu({required this.id, required this.nome, required this.email});

  Usu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['email'] = this.email;
    return data;
  }
}
