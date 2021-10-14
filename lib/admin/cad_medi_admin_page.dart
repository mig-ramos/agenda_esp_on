import 'package:agenda_esp_on/apis/especialidade_api.dart';
import 'package:agenda_esp_on/apis/medico_api.dart';
import 'package:agenda_esp_on/components/alert.dart';
import 'package:agenda_esp_on/models/especialidade_lista.dart';
import 'package:agenda_esp_on/utils/string_capitalize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CadMediAdminPage extends StatefulWidget {
  const CadMediAdminPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _CadMediAdminPageState createState() => _CadMediAdminPageState();
}

class _CadMediAdminPageState extends State<CadMediAdminPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _txtNome = TextEditingController();
  TextEditingController _txtEmail = TextEditingController();
  TextEditingController _txtSenha = TextEditingController();
  TextEditingController _txtCrm = TextEditingController();

  String _dropEspecialidadeValue = 'Buscar..';

  var _progress = false;

  TextStyle _styleCampo = TextStyle(fontSize: 22);
  TextStyle _styleValor = const TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 22,
      color: Colors.white,
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1960),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        click = false;
      });
  }

  void initState() {
    super.initState();
    _recuperaDados();
  }

  List<EspecialidadeLista> espe = [];
  List<String> _listaEspecial = ['Buscar..'];

  late int _idEspe = 0;

  bool click = true;

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
                controller: _txtNome,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe seu Email';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  labelText: "Nome",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  hintText: "Digite o seu nome",
                  hintStyle: TextStyle(
                    color: Colors.black38,
                    fontSize: 18,
                  ),
                ),
              ),
              TextFormField(
                controller: _txtEmail,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe seu Email';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                  hintText: "Digite o seu email",
                  hintStyle: TextStyle(
                    color: Colors.black38,
                    fontSize: 18,
                  ),
                ),
              ),
              TextFormField(
                controller: _txtSenha,
                validator: (value) {
                  if (value!.length < 2) {
                    return "Senha precisa ter mais de 2 caracteres";
                  }
                  return null;
                },
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  labelText: "Senha",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                  hintText: "Digite a sua Senha",
                  hintStyle: TextStyle(
                    color: Colors.black38,
                    fontSize: 18,
                  ),
                ),
              ),
              TextFormField(
                controller: _txtCrm,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o CRM';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  labelText: "CRM:",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  hintText: "Digite o código do CRM",
                  hintStyle: TextStyle(
                    color: Colors.black38,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                height: 80,
                child: Row(
                  children: [
                    SizedBox(
                      width: 170,
                      child: Text(
                        'Data Inscrição:',
                        style: _styleCampo,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text(DateFormat("dd/MM/yyyy").format(currentDate),
                          style: (click == true ? _styleValor : _styleValor1)),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black38,
                height: 20,
              ),
              Container(
                child: Row(children: [
                  Text(
                    'Espec:  ',
                    style: styleCampo,
                  ),
                  DropdownButton<String>(
                    value: _dropEspecialidadeValue,
                    dropdownColor: Colors.white,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 22,
                        color: Colors.blue),
                    onChanged: (String? newValue) {
                      setState(() {
                        _dropEspecialidadeValue = newValue!;
                        _recuperaIdEspe(_dropEspecialidadeValue);
                      });
                    },
                    items: _listaEspecial
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ]),
              ),
              Divider(
                color: Colors.black38,
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
                          "Cadastrar",
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
    // Navigator.of(context).pushReplacementNamed('/');
    Navigator.pop(context);
  }

  _onClickCadastrar(context) async {
    int id = 0;
    String nome = (_txtNome.text).capitalizeFirstofEach;
    String email = _txtEmail.text;
    String senha = _txtSenha.text;
    String codigo = '';
    String crm = _txtCrm.text;
    String dataInscricao = DateFormat("dd/MM/yyyy").format(currentDate);
    int idEspecialidade = _idEspe;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _progress = true;
    });

    var response = await MedicoApi.saveMedi(id, nome, email, senha, codigo, crm, dataInscricao, idEspecialidade);

    switch (response) {
      case 200:
        Navigator.pop(context);
        alert(context, 'Médico Alterado \ncom sucesso!!');
        break;
      case 201:
        Navigator.pop(context);
        alert(context, 'Médico Cadastrado \ncom sucesso!!');
        break;
      case 400:
        Navigator.pop(context);
        alert(context, 'FALHA \nna transmissão de dados..');
        break;
      case 500:
        alert(context, 'Email: $email \njá Cadastrado..');
        break;
      default:
    }
    setState(() {
      _progress = false;
    });
  }

  _recuperaIdEspe(String nome){
    for (int i = 0; i < espe.length; i++) {
      if (nome == espe[i].nome) {
        _idEspe = espe[i].id;
      }
    }
    setState(() {});
  }

  _recuperaDados() async {
    espe = await EspecialidadeApi.listEspecialidades();
    for (int i = 0; i < espe.length; i++) {
          _listaEspecial.add(espe[i].nome);
      }
    setState(() {
      _listaEspecial;
    });
  }
}
