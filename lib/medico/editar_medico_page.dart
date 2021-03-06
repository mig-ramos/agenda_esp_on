import 'dart:convert';
import 'package:agenda_esp_on/apis/usuario_api.dart';
import 'package:agenda_esp_on/components/alert.dart';
import 'package:agenda_esp_on/utils/function_utils.dart';
import 'package:agenda_esp_on/utils/prefs.dart';
import 'package:agenda_esp_on/utils/string_capitalize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditarMedicoPage extends StatefulWidget {
  EditarMedicoPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _EditarMedicoPageState createState() => _EditarMedicoPageState();
}

class _EditarMedicoPageState extends State<EditarMedicoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _txtNome = TextEditingController();
  TextEditingController _txtEmail = TextEditingController();
  TextEditingController _txtSenha = TextEditingController();
  TextEditingController _txtCrm = TextEditingController();

  int _id = 0;

  var _progress = false;

  TextStyle styleCampo = TextStyle(fontSize: 22);
  TextStyle styleValor = TextStyle(
      fontWeight: FontWeight.normal, fontSize: 22, color: Colors.blue);
  DateTime currentDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1940),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = currentDate;
      });
  }

  initState() {
    super.initState();
    _recuperaDados();
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
              labelText: "Nome:",
              labelStyle: TextStyle(
                color: Colors.black,
                // fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              hintText: "Digite o seu nome",
              hintStyle: TextStyle(
                color: Colors.black,
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
            enabled: false,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 22,
            ),
            decoration: InputDecoration(
              labelText: "Email:",
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
              hintText: "Digite o seu email",
              hintStyle: TextStyle(
                color: Colors.black,
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
            enabled: false,
            keyboardType: TextInputType.visiblePassword,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 22,
            ),
            decoration: InputDecoration(
              labelText: "Senha:",
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
              hintText: "Digite a sua Senha",
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          TextFormField(
            controller: _txtCrm,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Informe seu CRM';
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
              labelText: "CRM:",
              labelStyle: TextStyle(
                color: Colors.black,
                // fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              hintText: "Digite o seu CRM",
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  'Data inscri????o: ',
                  style: styleCampo,
                ),
              ),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text(DateFormat("dd/MM/yyyy").format(currentDate),
                    style: styleValor),
              ),
            ],
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
                      "Confirmar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
              onPressed: () {
                _onClickEditar(context);
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

  _onClickCancelar(context) async {
    Navigator.pop(context);
  }

  _onClickEditar(context) async {
    int id = _id;
    String nome = (_txtNome.text).capitalizeFirstofEach;
    String email = _txtEmail.text;
    String senha = _txtSenha.text;
    String crm = _txtCrm.text;
    DateTime dataInscricao = currentDate;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _progress = true;
    });

    var usuario =
        await UsuarioApi.saveUsu(id, nome, email, senha, dataInscricao, crm);

    switch (usuario.statusCode) {
      case 204:
        Navigator.pop(context);
        alert(context, 'Dados alterados \ncom sucesso!!');
        break;
      case 201:
        Navigator.pop(context);
        alert(context, 'M??dico cadastrado \ncom sucesso!!');
        break;
      case 500:
        alert(context, 'Email: $email \nj?? Cadastrado..');
        break;
      default:
    }

    setState(() {
      _progress = false;
    });
  }

  _recuperaDados() async {
    Map mapResponse = json.decode(await Prefs.getString('usuario.prefs'));
    print(mapResponse);
    _txtNome.text = mapResponse["nome"];
    _txtEmail.text = mapResponse["email"];
    _txtSenha.text = mapResponse["senha"];
    _txtCrm.text = mapResponse['crm'].toString();
    setState(() {
      currentDate = stringToDate(mapResponse["data_inscricao"]);
      _id = mapResponse["id"];
    });
  }
}
