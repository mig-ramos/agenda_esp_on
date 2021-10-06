import 'dart:convert';
import 'package:agenda_esp_on/apis/login_api.dart';
import 'package:agenda_esp_on/apis/usuario_api.dart';
import 'package:agenda_esp_on/components/alert.dart';
import 'package:agenda_esp_on/components/styles_buttons.dart';
import 'package:agenda_esp_on/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

 Future<String> _buscarToken() async {
  var setup = await Prefs.getString('user.prefs');
  Map<String, dynamic> mapResponse = json.decode(setup);
 return (mapResponse['token']);
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _resetarPageLogin();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 160,
                  height: 160,
                  child: (Icon(
                    Icons.account_circle_outlined,
                    size: 150,
                    color: Colors.green,
                  )),
                ),
              ),
              Container(
                margin: EdgeInsets.all(18),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _txtFormFieldEmail(),
                    _txtFormFieldSenha(),
                  ],
                ),
              ),
              Container(
                height: 60,
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(8, 28, 8, 28),
                child: _btnButtonElevated(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _txtFormFieldEmail() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          icon: Icon(
            Icons.email_outlined,
            color: Colors.pink,
            size: 36,
          ),
          labelText: "Digite seu Email",
          labelStyle: TextStyle(color: Colors.black, fontSize: 22.0),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          contentPadding:
              EdgeInsets.only(left: 5, right: 30, bottom: 20, top: 20)),
      style: TextStyle(color: Colors.black, fontSize: 20),
      controller: _emailController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Informe seu Email';
        }
        return null;
      },
      obscureText: false,
    );
  }

  _txtFormFieldSenha() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      decoration: const InputDecoration(
          icon: Icon(
            Icons.lock_outline,
            color: Colors.pink,
            size: 36,
          ),
          labelText: "Digite sua Senha",
          labelStyle: TextStyle(color: Colors.black, fontSize: 22.0),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          contentPadding:
              EdgeInsets.only(left: 5, right: 30, bottom: 20, top: 20)),
      style: TextStyle(color: Colors.black, fontSize: 26),
      controller: _senhaController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Informe sua Senha';
        }
        return null;
      },
      obscureText: true,
    );
  }

  _btnButtonElevated(BuildContext context) {
    return Container(
        child: (ElevatedButton(
      style: elevatedButtonStyle,
      child: Text('Confirmar'),
      onPressed: () async {
        String email = _emailController.text;
        String senha = _senhaController.text;
        if (_formKey.currentState!.validate()) {
          var resposta = await LoginApi.login(email, senha);
          if (resposta == 200) {
            var token =await _buscarToken();
                var usuario = await UsuarioApi.bucarUsuEmail(email, senha, token);
            if (usuario != null) {
              var perfil = await Prefs.getString('perfil') as String;
               switch (perfil) {
                case 'PACIENTE':
                  ////////////           print(await Prefs.getString('user.prefs'));
                  Navigator.of(context).pushReplacementNamed('/menuPageUsuario');
                  break;
                case 'MEDICO':
                  Navigator.of(context).pushReplacementNamed('/menuPageMedico');
                  break;
                case 'ADMIN':
                  Navigator.of(context).pushReplacementNamed('/menuPageAdmin');
                  break;
                default:
                  alert(context, "Perfil não encontrado..");
                  break;
              }
            } else {
              alert(context, "Falha no Cadastro Usuário..");
            }
            //   Navigator.of(context).pushReplacementNamed('/menuPageUsuario');
          } else if(resposta == 401) {
            alert(context, "Login INVÁLIDO");
          } else{
            alert(context, "Servidor não encontrado..");
          }
        } else {
          // FocusScope.of(context).requestFocus(new FocusNode());
        }
      },
    )));
  }

  _resetarPageLogin() {
    _emailController.text = "";
    _senhaController.text = "";
  }
}
