import 'dart:convert';

import 'package:agenda_esp_on/apis/usuario_api.dart';
import 'package:agenda_esp_on/components/alert.dart';
import 'package:agenda_esp_on/utils/function_utils.dart';
import 'package:agenda_esp_on/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditarSenhaUsuario extends StatefulWidget {
  const EditarSenhaUsuario({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _EditarSenhaUsuarioState createState() => _EditarSenhaUsuarioState();
}

class _EditarSenhaUsuarioState extends State<EditarSenhaUsuario> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _txtSenhaAtual = TextEditingController();
  TextEditingController _txtNovaSenha = TextEditingController();
  TextEditingController _txtRepetirSenha = TextEditingController();
  int _id = 0;
  String _txtNome= '';
  String _txtEmail = '';
  late DateTime _dataNascimento;
  String _senhaAtual = '';

  var _progress = false;

  TextStyle styleCampo = TextStyle(fontSize: 22);
  TextStyle styleValor = TextStyle(
      fontWeight: FontWeight.normal, fontSize: 22, color: Colors.blue);

  void initState() {
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
            controller: _txtSenhaAtual,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Informe sua Senha Atual';
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
              labelText: "Senha Atual",
              labelStyle: TextStyle(
                color: Colors.black,
                // fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              hintText: "Digite a Senha Atual",
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          TextFormField(
            controller: _txtNovaSenha,
            validator: (value) {
              if(value!.isEmpty){
                return 'Informe a Nova Senha';
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
              labelText: "Nova Senha",
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
              hintText: "Digite a nova senha",
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          TextFormField(
            controller: _txtRepetirSenha,
            validator: (value) {
              if(value! != _txtNovaSenha.text) {
                return "Diferença ao Repetir a Senha!";
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
              labelText: "Repetir a Nova Senha",
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
              hintText: "Repetir a Nova Senha",
              hintStyle: TextStyle(
                color: Colors.black,
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

  _onClickCancelar(context) {
    Navigator.pop(context);
  }

  _onClickEditar(context) async {
    print("Confirmar!");
    int id = _id;
    String nome = _txtNome;
    String email = _txtEmail;
    DateTime dataNascimento = _dataNascimento;
    String senhaAtual = _txtSenhaAtual.text;
    String novaSenha = _txtNovaSenha.text;
    String repetirSenha = _txtRepetirSenha.text;
    // if (novaSenha == repetirSenha){
    //   senhaAtual = novaSenha;
    // }

    // print("Nome: $nome Email: $email Senha atual: $senhaAtual, Nova senha: $novaSenha, Repetir senha: $repetirSenha");

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _progress = true;
    });
    // print('Aseguir o token');
    // print(await Prefs.getString('tokenjwt'));
    print('$senhaAtual \nDo Bnaco $_senhaAtual');
    if(_senhaAtual != senhaAtual){
      alert(context,'Senha Atual \nnão é a mesma!!');
    } else if (novaSenha == repetirSenha && _senhaAtual == senhaAtual){
      senhaAtual = novaSenha;
      var usuario = await UsuarioApi.mudaSenhaUsu(id, senhaAtual,nome, email, dataNascimento);
      switch(usuario.statusCode){
        case 204:
          Navigator.pop(context);
          alert(context,'Senha Alterada \ncom sussesso!!');
          break;
        default:
          alert(context,'Alteração de Senha \nfalhou!!');
      }
    } else {
      alert(context,'Repetir senha \nnão é igual!!');
    }


        setState(() {
          _progress = false;
        });
      }
      _recuperaDados() async{
        Map mapResponse = json.decode(await Prefs.getString('usuario.prefs'));
        setState((){
          _id = mapResponse["id"] as int;
          _txtNome = mapResponse["nome"];
          _txtEmail = mapResponse["email"];
          _senhaAtual = mapResponse["senha"];
          _txtSenhaAtual.text = '';
          _dataNascimento = stringToDate(mapResponse["data_nascimento"]);
        });
      }
}