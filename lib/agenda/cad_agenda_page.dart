import 'package:agenda_esp_on/apis/agenda_api.dart';
import 'package:agenda_esp_on/apis/especialidade_api.dart';
import 'package:agenda_esp_on/apis/hora_api.dart';
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

  late int _idHora;
  late String _nomeHr;
  late int _idMedi;
  late String _nomeMedi;
  late int _idMotivo;
  late String _nomeMot;

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
                setState((){
                  _dropEspecialidadeValue = newValue!;
                  _dropMedicoValue = 'Buscar..';
                  EspecialidadeApi.dropEspecialidades(
                      _dropEspecialidadeValue);
                   _recuperaMedico(_dropEspecialidadeValue); // AQUI ESOLHE OS MEDICOS
                });
              },
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
                  click = true;
                  _dropMedicoValue = newValue!;
                });
              },
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
                  // _dropHoraValue = newValue!;
                  // _recuperaTipoConsulta();
                  // _buscaIdMedico(_dropMedicoValue);
                  // _buscaIdHora(_dropHoraValue);
                  _dropHoraValue = newValue!;
                  _buscaIdHora(_dropHoraValue);
                  _recuperaTipoConsulta();
                  _buscaIdMedico(_dropMedicoValue);
                });
              },
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
                  _buscaIdMotivo(_dropTipoConsultaValue);
                });
              },
              items:
                  _tipoConsulta.map<DropdownMenuItem<String>>((String value) {
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
    Navigator.pop(context);
  }

  _onClickCadastrar(context) async {

    DateTime dataAgenda = currentDate;

    var listEsp = await Especial.get(); // Id da ESPECIALIDADE
    int _idEspe = listEsp!.id;
    String _nomeEspe = listEsp.nome;

    if (_dropEspecialidadeValue == 'Buscar..') {
      alert(context, 'Qual a Especialidade?');
    } else if (_dropMedicoValue == 'Buscar..') {
      alert(context, 'Qual o Médico?');
    } else if (_dropHoraValue == 'Buscar..') {
      alert(context, 'Qual a Hora?');
    } else if (_dropTipoConsultaValue == 'Buscar..') {
      alert(context, 'Qual o Motivo?');
    } else {
      var response = await AgendaApi.salvaAgenda(0,
          DateFormat("yyyy-MM-dd").format(dataAgenda),
          _idEspe,
          _nomeEspe,
          _idMotivo,
          _nomeMot,
          _idMedi,
          _nomeMedi,
          _idHora,
          _nomeHr,
          '=>');
      switch (response) {
        case 204:
          Navigator.pop(context);
          alert(context, 'Alterado com sucesso!');
          break;
        case 201:
          Navigator.pop(context);
          alert(context,
              'Agendado com sucesso!\nClick no Botão Atualizar\ncanto superior direito.');
          break;
        case 403:
          Navigator.pop(context);
          alert(context,
              'Assinatura de conexão vencida!\nFaça Login Novamente..');
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
    setState(() {
      _listaEspecial = lista!;
    });
  }

  _recuperaMedico(String dropEspecialidadeValue) async {
    var lista = await MedicoApi.dropMedicosPorEspe(dropEspecialidadeValue);
    setState(() {
     _listaMedicos = lista!;
    });
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

  _buscaIdMedico(String dropMedicoValue) async {
    var medico = await MedicoApi.buscaIdMedico(dropMedicoValue);
    if(medico!= null){
      setState(() {
        _idMedi = medico.id;
        _nomeMedi = medico.nome;
      });
    }
  }

  _buscaIdHora(String dropHoraValue) async {
    var hora = await HoraApi.buscaIdHora(dropHoraValue);
    if(hora != null){
      setState(() {
        _idHora = hora.id;
        _nomeHr = hora.hora;
      });
    }
  }

  _buscaIdMotivo(String dropTipoConsultaValue) async {
    var motivo = await MotivoApi.buscaIdMotivo(dropTipoConsultaValue);
    if (motivo != null){
      setState(() {
        _idMotivo = motivo.id;
        _nomeMot = motivo.tipoConsulta;
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
