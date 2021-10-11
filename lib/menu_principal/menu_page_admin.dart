import 'package:agenda_esp_on/apis/especialidade_api.dart';
import 'package:agenda_esp_on/components/alert.dart';
import 'package:agenda_esp_on/components/navigation_drawer_admin.dart';
import 'package:agenda_esp_on/models/especialidade.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuPageAdmin extends StatefulWidget {
  const MenuPageAdmin({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MenuPageAdminState createState() => _MenuPageAdminState();
}

class _MenuPageAdminState extends State<MenuPageAdmin> {

  late Future<List<Especialidade>> _especialidade;

  @override
  initState() {
    super.initState();
    _especialidade = EspecialidadeApi.listaEspecialidades();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerAdmin(),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh,color: Colors.white,),
            onPressed: () {
              setState(() {
                _especialidade = EspecialidadeApi.listaEspecialidades();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _especialidade,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return ListView(
              children: _listEspecialidades(snapshot.data),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'O Administrador não tem\n   Especialidade..',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      '\nPara adicionar: \nbasta clicar no botão (+)',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\nPara Excluir Especialidade: \nbasta manter clicado\no Cartão de Especialidade..',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                      ),
                    )
                  ]),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,),
        backgroundColor: Colors.amber,
        onPressed: () async {
          ///PROGRAMAR CADASTRO NAVIGATOR
        },
      ),
    );

  }

  List<Widget> _listEspecialidades(data) {
    List<Widget> especialidades = [];
    for (var espe in data) {
      especialidades.add(Card(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                onLongPress: () {
                  _deletarEspecialidade(context, espe);
                },
                title: Text('ID: '+(espe.id).toString() +
                    '\nNome: ' +
                    espe.nome),
                subtitle: Text('DESCRIÇÃO: ' + espe.descricao),
                leading: CircleAvatar(
                  child: Text(espe.nome.substring(0, 1)),
                ),
                trailing: Icon(Icons.delete,color: Colors.red,),
              )
            ],
          ),
        ),
      ));
    }
    return especialidades;
  }

  _deletarEspecialidade(context, espe) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Deletar Especialidade?"),
          content: Text(espe.nome),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancelar')),
            TextButton(
                onPressed: () {
                  this.setState(() {
                    this._deleteEspecialidade(espe.id);
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  'Deletar',
                  style: TextStyle(color: Colors.red),
                ))
          ],
        ));
  }

  _deleteEspecialidade(id) async {
    int response = await EspecialidadeApi.delEspecialidade(id);
    if (response == 204) {
      setState(() {
        alert(context, 'Ok. Solicitação atendida \nDeletado o agendamento.');
        _especialidade = EspecialidadeApi.listaEspecialidades();
      });
    } else if (response == 400){
      alert(context, ':-(  Solicitação não atendida \n      Especialidade em uso.');
    }
  }


}