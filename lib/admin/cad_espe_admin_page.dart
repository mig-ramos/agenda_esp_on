import 'package:agenda_esp_on/apis/especialidade_api.dart';
import 'package:agenda_esp_on/components/alert.dart';
import 'package:agenda_esp_on/utils/string_capitalize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CadEspeAdminPage extends StatefulWidget {
  const CadEspeAdminPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _CadEspeAdminPageState createState() => _CadEspeAdminPageState();
}

class _CadEspeAdminPageState extends State<CadEspeAdminPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _txtNome = TextEditingController();
  TextEditingController _txtDescricao = TextEditingController();

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

  void initState() {
    super.initState();
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _txtNome,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe a Especialidade';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  labelText: "Especialidade:",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  hintText: "Digite o nome",
                  hintStyle: TextStyle(
                    color: Colors.black38,
                    fontSize: 18,
                  ),
                ),
              ),
              TextFormField(
                controller: _txtDescricao,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe a Descrição';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  labelText: "Descrição:",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                  hintText: "Digite a descrição",
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

  _onClickCancelar(context) {
    Navigator.pop(context);
  }

  _onClickCadastrar(context) async {
    int id = 0;
    String nome = (_txtNome.text).capitalizeFirstofEach;
    String descricao = _txtDescricao.text;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _progress = true;
    });

    var especialidade =
        await EspecialidadeApi.saveEspe(id, nome, descricao);

    switch (especialidade.statusCode) {
      case 200:
        Navigator.pop(context);
        alert(context, 'Especialidade alterada \ncom sucesso!!');
        break;
      case 201:
        Navigator.pop(context);
        alert(context, 'Especialidade cadastrada \ncom sucesso!!');
        break;
      case 500:
        alert(context, 'Falha no servidor..');
        break;
      default:
    }
    setState(() {
      _progress = false;
    });
  }
}
