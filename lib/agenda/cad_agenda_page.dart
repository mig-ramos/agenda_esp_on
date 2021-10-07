import 'package:agenda_esp_on/apis/agenda_api.dart';
import 'package:agenda_esp_on/apis/especialidade_api.dart';
import 'package:agenda_esp_on/apis/medico_api.dart';
import 'package:agenda_esp_on/apis/motivo_api.dart';
import 'package:agenda_esp_on/components/alert.dart';
import 'package:agenda_esp_on/configurations/setup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CadAgendaPage extends StatefulWidget {
  const CadAgendaPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _CadAgendaPageState createState() => _CadAgendaPageState();
}

class _CadAgendaPageState extends State<CadAgendaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _progress = false;
  String _dropEspecialidadeValue = 'Buscar..';
  String _dropMedicoValue = 'Buscar..';
  String _dropHoraValue = 'Buscar..';
  String _dropTipoConsultaValue = 'Buscar..';

  void initState() {
    super.initState();
    _recuperaDados();
  }

  List<String> _listaEspecial = [];
  List<String> _listaMedicos = [];
  List<String> _listaHoras = [];
  List<String> _tipoConsulta = [];

  bool click = true;

  TextStyle styleValor = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 22,
    color: Colors.lightGreen,
  );

  TextStyle styleValor1 = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 22,
    color: Colors.white,
  );

  TextStyle styleCampo = TextStyle(fontSize: 22);

  DateTime currentDate = DateTime.now();
  DateTime dataInicial = DateTime.now();

  DateTime dataFinal = DateTime.now().add(Duration(days: 30));

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        // firstDate: currentDate,
        firstDate: dataInicial,
        // firstDate: DateTime(1940),
        lastDate: dataFinal);
    // lastDate: DateTime(2021).add(Duration(days: 30)));
    // if (pickedDate != null && pickedDate != currentDate)
    if (pickedDate != null)
      setState(() {
        currentDate = pickedDate;
        _recuperaHora(currentDate);
        click = false;
      });
  }

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
        child: _body(context),
      ),
    );
  }

  _body(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Text(
            'Especialidade: ',
            style: styleCampo,
          ),
          Container(
            color: Colors.lightGreen,
            padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
            width: double.infinity,
            child: DropdownButton<String>(
              value: _dropEspecialidadeValue,
              // icon: const Icon(
              //   Icons.youtube_searched_for_outlined,
              //   color: Colors.pink,
              // ),
              // iconSize: 24,
              // elevation: 16,
              dropdownColor: Colors.green,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 22,
                  color: Colors.white),
              // underline: Container(
              //   width: double.infinity,
              //   height: 2,
              //   color: Colors.pink,
              // ),
              onChanged: (String? newValue) {
                setState(() async {
                  _dropEspecialidadeValue = newValue!;
                  _dropMedicoValue = 'Buscar..';
                  await EspecialidadeApi.dropEspecialidades(_dropEspecialidadeValue);
                  _recuperaMedico(
                      _dropEspecialidadeValue); // AQUI ESOLHE OS MEDICOS
                });
              },
              // items: <String>[
              //   'Buscar..',
              //   'Dentista',
              //   'Otorrino',
              //   'Pediatra',
              //   'Clínico Geral'
              // ].map<DropdownMenuItem<String>>((String value) {
              items:
              _listaEspecial.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Divider(
            color: Colors.amber,
            height: 20,
          ),
          Text(
            'Médico: ',
            style: styleCampo,
          ),
          Container(
            color: Colors.lightGreen,
            padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
            width: double.infinity,
            child: DropdownButton<String>(
              value: _dropMedicoValue,
              // icon: const Icon(
              //   Icons.youtube_searched_for_outlined,
              //   color: Colors.pink,
              // ),
              iconSize: 24,
              elevation: 16,
              dropdownColor: Colors.green,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 22,
                  color: Colors.white),
              // underline: Container(
              //   width: double.infinity,
              //   height: 2,
              //   color: Colors.pink,
              // ),
              onChanged: (String? newValue) {
                setState(() {
                  _dropMedicoValue = newValue!;
                });
              },
              // items: <String>[
              //   'Buscar..',
              //   'Hipócratis',
              //   'Lair Ribeiro',
              //   'Clara Montes',
              //   'Raul Denix'
              // ].map<DropdownMenuItem<String>>((String value) {
              items:
              _listaMedicos.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Divider(
            color: Colors.amber,
            height: 20,
          ),
          Text(
            'Data: ',
            style: styleCampo,
          ),
          Container(
            color: Colors.lightGreen,
            padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
            width: double.infinity,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => _selectDate(context),
                child: Text(DateFormat("dd/MM/yyyy").format(currentDate),
                    style: (click == true ? styleValor : styleValor1)),
              ),
            ),
          ),
          Divider(
            color: Colors.amber,
            height: 20,
          ),
          Text(
            'Hora: ',
            style: styleCampo,
          ),
          Container(
            color: Colors.lightGreen,
            padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
            width: double.infinity,
            child: DropdownButton<String>(
              value: _dropHoraValue,
              // icon: const Icon(
              //   Icons.youtube_searched_for_outlined,
              //   color: Colors.pink,
              // ),
              iconSize: 24,
              elevation: 16,
              dropdownColor: Colors.green,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 22,
                  color: Colors.white),
              // underline: Container(
              //   width: double.infinity,
              //   height: 2,
              //   color: Colors.pink,
              // ),
              onChanged: (String? newValue) {
                setState(() {
                  _dropHoraValue = newValue!;
                  _recuperaTipoConsulta();
                //  AgendaApi.getHora(_dropHoraValue);
                });
              },
              // items: <String>[
              //   'Buscar..',
              //   '08:00',
              //   '09:00',
              //   '10:00',
              //   '13:00',
              //   '14:00'
              // ].map<DropdownMenuItem<String>>((String value) {
              items: _listaHoras.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Divider(
            color: Colors.amber,
            height: 20,
          ),
          Text(
            'Motivo: ',
            style: styleCampo,
          ),
          Container(
            color: Colors.lightGreen,
            padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
            width: double.infinity,
            child: DropdownButton<String>(
              value: _dropTipoConsultaValue,
              // icon: const Icon(
              //   Icons.youtube_searched_for_outlined,
              //   color: Colors.pink,
              // ),
              iconSize: 24,
              elevation: 16,
              dropdownColor: Colors.green,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 22,
                  color: Colors.white),
              // underline: Container(
              //   width: double.infinity,
              //   height: 2,
              //   color: Colors.pink,
              // ),
              onChanged: (String? newValue) {
                setState(() {
                  _dropTipoConsultaValue = newValue!;
                });
              },
              items:
              _tipoConsulta.map<DropdownMenuItem<String>>((String value) {
                // items: <String>['Buscar..', 'Consulta', 'Retorno']
                //     .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Divider(
            color: Colors.amber,
            height: 20,
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
                "Agendar",
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
    );
  }

  _onClickCancelar(context) {
    // Navigator.of(context).pushReplacementNamed('/');
    Navigator.pop(context);
  }

  _onClickCadastrar(context) async {

  //  String especialidade = _dropEspecialidadeValue;
    String medico = _dropMedicoValue;
    DateTime dataAgenda = currentDate;
    String hora = _dropHoraValue;
    String tipoConsulta = _dropTipoConsultaValue;

    var listEsp =  await Especial.get();
    // print('Olha o id da Especialidade');
    // print( await listEsp!.id);

    int _idEspe = listEsp!.id;
    int _idMedi = 4;
    int _idHora = 8;
    int _idTipo =0;


    // AgendaApi.getEspecialidades(especialidade);
    // AgendaApi.getMedico(medico);
    // AgendaApi.getHora(hora);
    // AgendaApi.getTipoConsulta(tipoConsulta);

  //  print('BOTÃO GRAVAR Especialidade: $especialidade - Médico: $medico - Data: ${DateFormat("dd/MM/yyyy").format(currentDate)} - Hora: $hora - Tipo de Consulta $tipoConsulta');

    if (_dropEspecialidadeValue == 'Buscar..') {
      alert(context, 'Qual a Especialidade?');
    } else if (_dropMedicoValue == 'Buscar..') {
      alert(context, 'Qual o Médico?');
    } else if (_dropHoraValue == 'Buscar..') {
      alert(context, 'Qual a Hora?');
    } else if (_dropTipoConsultaValue == 'Buscar..') {
      alert(context, 'Qual o Motivo?');
    } else {



      for(int e = 0; e < _listaEspecial.length; e++){
        if(_listaEspecial[e] == _dropEspecialidadeValue){
          _idEspe = e;
        }
      }
      for(int t = 0; t < _tipoConsulta.length; t++){
        if(_tipoConsulta[t] == _dropTipoConsultaValue){
          _idTipo = t;
        }
      }

   print('BOTÃO GRAVAR-  Especialidade: $_idEspe - Médico: $_idMedi - Data: ${DateFormat("dd/MM/yyyy").format(currentDate)} - Hora: $_idHora - Tipo de Consulta $_idTipo');

      var response = await AgendaApi.salvaAgenda(
          DateFormat("yyyy-MM-dd").format(dataAgenda),_idEspe,_idTipo,_idMedi,_idHora);
      switch (response) {
        case 204:
          Navigator.pop(context);
          alert(context, 'Alterado com sussesso!');
          break;
        case 201:
          Navigator.pop(context);
          alert(context, 'Agendado com sussesso!\nClick no Botão Atualizar\ncanto superior direito.');
          break;
        case 500:
          Navigator.pop(context);
          alert(context, 'Falha no Servidor!');
          break;
      }
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _progress = true;
    });

    // final service = FirebaseService();
    // final response = await service.cadastrar(nome, email, senha);
    //
    // if (response.ok) {
    //   push(context, HomePage(),replace:true);
    // } else {
    //   alert(context, response.msg);
    // }

    setState(() {
      _progress = false;
    });
  }

  _recuperaDados() async {
    String nome = '';
   var lista = await EspecialidadeApi.dropEspecialidades(nome);
    // Teste de subtração de hora medico
    //  if (_dropMedicoValue != 'Buscar..'){
    //    List<String> horas = [];
    //    horas = await AgendaApi.getHorasAgendamentos(_dropMedicoValue,DateFormat("yyyy-MM-dd").format(currentDate) );
    //    setState(() {
    //      _listaHoras = horas;
    //    });
    //  }
    setState(() {
      _listaEspecial = lista!;
    });
  }

  _recuperaMedico(String especialidade) async {
    for (int i = 0; i < _listaEspecial.length; i++) {
      //   print(_dropEspecialidadeValue);
      if (_listaEspecial[i] == _dropEspecialidadeValue) {
        var lista = await MedicoApi.dropMedicos(i);
        setState(() {
          _listaMedicos = lista!;
        });
      }
    }
  }

  _recuperaHora(DateTime currentDate) async {
    var data = DateFormat("yyyy-MM-dd").format(currentDate);
    if (_dropMedicoValue != "Buscar.." || _dropMedicoValue != "") {
      List<String> horas = [];
      horas = (await AgendaApi.dropHoras(_dropMedicoValue, data))!;

      setState(() {
        _listaHoras = horas;
      });
    }
  }

  _recuperaTipoConsulta() async {
    List<String> tipoConsulta = [];
    tipoConsulta = await MotivoApi.dropMotivo();
    setState(() {
      _tipoConsulta = tipoConsulta;
    });
  }
}