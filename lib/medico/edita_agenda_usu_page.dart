import 'package:agenda_esp_on/apis/agenda_api.dart';
import 'package:agenda_esp_on/components/alert.dart';
import 'package:agenda_esp_on/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class EditaAgendaUsuPage extends StatefulWidget {
  EditaAgendaUsuPage({Key? key, required this.title}) : super(key: key);
  final title;

  @override
  _EditaAgendaUsuPageState createState() => _EditaAgendaUsuPageState();
}

class _EditaAgendaUsuPageState extends State<EditaAgendaUsuPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _txtDataConsulta = TextEditingController();
  TextEditingController _txtHora = TextEditingController();
  TextEditingController _txtNome = TextEditingController();
  TextEditingController _txtEspecial = TextEditingController();
  TextEditingController _txTipoConsulta = TextEditingController();
  TextEditingController _txtUltimaAlteracao = TextEditingController();
  TextEditingController _txtObservacao = TextEditingController();

 // String _dropEspecialidadeValue = 'Buscar..';

  var _progress = false;

  TextStyle _styleCampo = TextStyle(fontSize: 22);
  TextStyle _styleValor = const TextStyle(
      fontWeight: FontWeight.normal, fontSize: 22, color: Colors.white,
      decoration: TextDecoration.underline,
      decorationColor: Colors.black38);

  TextStyle _styleValor1 = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 22,
      color: Colors.blue,
      decoration: TextDecoration.underline,
      decorationColor: Colors.black38);

  DateTime currentDate = DateTime.now();
  TextStyle styleCampo = TextStyle(fontSize: 22);

  void initState() {
    super.initState();
    _recuperaFicha();
  }
  var _id;

  final ButtonStyle _elevatedButtonOk = ElevatedButton.styleFrom(
    textStyle: TextStyle(fontSize: 28, color: Colors.black),
    shadowColor: Colors.green,
    onPrimary: Colors.white,
    primary: Colors.green,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );

  final ButtonStyle _elevatedButtonNo = ElevatedButton.styleFrom(
    textStyle: TextStyle(fontSize: 28, color: Colors.black),
    shadowColor: Colors.white,
    onPrimary: Colors.white,
    primary: Colors.white,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _txtDataConsulta,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe a Data';
                  }
                  return null;
                },
                enabled: false,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  labelText: "Data marcada: ",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  hintText: "Digite a data da consulta",
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              TextFormField(
                controller: _txtHora,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe a Hora';
                  }
                  return null;
                },
                enabled: false,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  labelText: "Hora marcada: ",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  hintText: "Digite a hora",
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              TextFormField(
                controller: _txtNome,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o Paciente';
                  }
                  return null;
                },
                enabled: false,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  labelText: "Nome do Paciente: ",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  hintText: "Digite o nome do Paciente",
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              TextFormField(
                controller: _txtEspecial,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe a especialidade';
                  }
                  return null;
                },
                enabled: false,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  labelText: "Especialidade requerida: ",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  hintText: "Digite a especialidade",
                  hintStyle: TextStyle(
                    color: Colors.black38,
                    fontSize: 18,
                  ),
                ),
              ),
              TextFormField(
                controller: _txTipoConsulta,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o motivo';
                  }
                  return null;
                },
                enabled: false,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  labelText: "Motivo da Consulta:",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                  hintText: "Digite o motivo",
                  hintStyle: TextStyle(
                    color: Colors.black38,
                    fontSize: 18,
                  ),
                ),
              ),
              TextFormField(
                controller: _txtUltimaAlteracao,
                validator: (value) {
                  if (value!.length < 2) {
                    return "Senha precisa ter mais de 2 caracteres";
                  }
                  return null;
                },
                enabled: false,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  labelText: "Última edição",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                  hintText: "Digite data da edição",
                  hintStyle: TextStyle(
                    color: Colors.black38,
                    fontSize: 18,
                  ),
                ),
              ),
              TextFormField(
                controller: _txtObservacao,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Alguma observação?';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  labelText: "Observação (situação):",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  hintText: "Digite uma observação",
                  hintStyle: TextStyle(
                    color: Colors.black38,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                height: 46,
                margin: EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  style: _elevatedButtonOk,
                  child: _progress
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                      : Text(
                          "Gravar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                  onPressed: () {
                    _onClickCadastrar(context);
                  },
                ),
              ),
              Container(
                height: 46,
                margin: EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  style: _elevatedButtonNo,
                  child: Text(
                    "Cancelar",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 22,
                    ),
                  ),
                  onPressed: () {
                    _onClickCancelar(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onClickCancelar(context) async {
    Navigator.pop(context);
  }

  _onClickCadastrar(context) async {
      int id = _id;
      String observacao = _txtObservacao.text;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _progress = true;
    });

    var response = await AgendaApi.editaAgenda( id, observacao);

      switch (response) {
        case 204:
          Navigator.pop(context);
          alert(context, 'Agenda editada \ncom sucesso!!');
          break;
        case 201:
          Navigator.pop(context);
          alert(context, 'Agenda criada \ncom sucesso!!');
          break;
        case 400:
          Navigator.pop(context);
          alert(context, 'FALHA \nna transmissão de dados..');
          break;
        case 500:
          alert(context, 'Falha no Servidor :- (');
          break;
        default:
      }
      setState(() {
        _progress = false;
      });
  }

  _recuperaFicha() async {
    Map<String, dynamic> mapResponse =
        json.decode(await Prefs.getString('agendamento.prefs'));
//    print('Aqui estamos: $mapResponse');
    _id = (mapResponse["id"]);
    _txtDataConsulta.text = stringToFormat(mapResponse["data"]);
    _txtHora.text = mapResponse["hora"];
    _txtNome.text = mapResponse["usuario"];
    _txtEspecial.text = mapResponse["especial"];
    _txTipoConsulta.text = mapResponse["motivo"];
    _txtUltimaAlteracao.text = mapResponse["ultimaAlteracao"];
    _txtObservacao.text = mapResponse["observacao"];
  }

  String stringToFormat(String date){
    String _dateString = "";
    _dateString = date.substring(8,10)+'/'+date.substring(5,7)+'/'+date.substring(0,4);
    return _dateString;
  }
}
