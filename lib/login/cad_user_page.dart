import 'package:agenda_esp_on/components/alert.dart';
import 'package:agenda_esp_on/utils/string_capitalize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';


class CadUserPage extends StatefulWidget {
  const CadUserPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _CadUserPageState createState() => _CadUserPageState();
}

class _CadUserPageState extends State<CadUserPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _txtNome = TextEditingController();
  TextEditingController _txtEmail = TextEditingController();
  TextEditingController _txtSenha = TextEditingController();

  var _progress = false;

  TextStyle _styleCampo = TextStyle(fontSize: 22);

  TextStyle _styleValor = const TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 22,
      color: Colors.white,
  decoration: TextDecoration.underline, decorationColor: Colors.blue );

  TextStyle _styleValor1 = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 22,
    color: Colors.blue,
  );

  DateTime currentDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1920),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        click = false;
      });
  }

  void initState() {
    super.initState();
  }

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
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            height: 100,
            child: Row(
              children: [
              SizedBox(
              width: 200,
             child: Text(
                'Data nascimento: ',
                style: _styleCampo,
              ),
            ),

            TextButton(

              onPressed: () => _selectDate(context),

              child: Text(
                  DateFormat("dd/MM/yyyy").format(currentDate),
                  style: (click == true ? _styleValor : _styleValor1)),),

        ],
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
    ),)
    ,
    )
    ,
    );
  }

  _onClickCancelar(context) {
    // Navigator.of(context).pushReplacementNamed('/');
    Navigator.pop(context);
  }

  _onClickCadastrar(context) async {
    print("Cadastrar!");
    int id = 0;
    String nome = (_txtNome.text).capitalizeFirstofEach;
    String email = _txtEmail.text;
    String senha = _txtSenha.text;
    DateTime dataNascimento = currentDate;

    print(
        "Id $id, Nome $nome, Email $email, Senha $senha, Data nascimento: $dataNascimento");

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _progress = true;
    });

    // var usuario = await UsuarioApi.saveUsu(id, nome, email, senha, dataNascimento);
    //
    // switch(usuario.statusCode){
    //   case 200:
    //     Navigator.pop(context);
    //     alert(context,'Usuário Alterado \ncom sussesso!!');
    //     break;
    //   case 201:
    //     Navigator.pop(context);
    //     alert(context,'Usuário Cadastrado \ncom sussesso!!');
    //     break;
    //   case 500:
    //     alert(context,'Email: $email \njá Cadastrado..');
    //     break;
    //   default:
    // }
    setState(() {
      _progress = false;
    });
  }

}
