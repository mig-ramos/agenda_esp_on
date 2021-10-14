import 'package:agenda_esp_on/apis/usuario_api.dart';
import 'package:agenda_esp_on/components/alert.dart';
import 'package:agenda_esp_on/models/usuario_lista.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListaUsuPage extends StatefulWidget {
  const ListaUsuPage({Key? key, required String this.title}) : super(key: key);

  final String title;

  @override
  _ListaUsuPageState createState() => _ListaUsuPageState();
}

class _ListaUsuPageState extends State<ListaUsuPage> {
  late Future<List<UsuarioLista>> _usuario;

  @override
  void initState() {
    super.initState();
    _usuario = UsuarioApi.listaUsuarios();
  }

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'PACIENTES'),
    Tab(text: 'MÉDICOS'),
    Tab(text: 'ÚLTIMOS'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          // actions: [
          //   IconButton(
          //     icon: Icon(
          //       Icons.refresh,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       setState(() {
          //         _usuario = UsuarioApi.listaUsuarios();
          //       });
          //     },
          //   ),
          // ],
          bottom: TabBar(
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          children: [
            buildFutureBuilderPacientes(),
            buildFutureBuilderMedicos(),
            buildFutureBuilderUsuarios()
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<UsuarioLista>> buildFutureBuilderPacientes() {

    setState(() {
      _usuario = UsuarioApi.listaPacientes();
    });

    return FutureBuilder(
        future: _usuario,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: _listUsuarios(snapshot.data),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'O Administrador não tem\n   Usuario..',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      '\nPara adicionar: \nBasta clicar no botão (+)',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\nPara Excluir Usuario: \nBasta manter clicado\no Cartão de Especialidade..',
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
      );
  }

  FutureBuilder<List<UsuarioLista>> buildFutureBuilderMedicos() {

    setState(() {
      _usuario = UsuarioApi.listaMedicos();
    });

    return FutureBuilder(
      future: _usuario,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: _listUsuarios(snapshot.data),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'O Administrador não tem\n   Usuario..',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    '\nPara adicionar: \nBasta clicar no botão (+)',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\nPara Excluir Usuario: \nBasta manter clicado\no Cartão de Especialidade..',
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
    );
  }

  FutureBuilder<List<UsuarioLista>> buildFutureBuilderUsuarios() {

    setState(() {
      _usuario = UsuarioApi.listaUsuarios();
    });

    return FutureBuilder(
      future: _usuario,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: _listUsuarios(snapshot.data),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'O Administrador não tem\n   Usuario..',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    '\nPara adicionar: \nBasta clicar no botão (+)',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\nPara Excluir Usuario: \nBasta manter clicado\no Cartão de Especialidade..',
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
    );
  }


  List<Widget> _listUsuarios(data) {
    List<Widget> usuarios = [];
    for (var usu in data) {
      usuarios.add(Card(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                onLongPress: () {
                  _deletarUsuario(context, usu);
                },
                title:
                    Text('Id: ' + (usu.id).toString() + '\nNome: ' + usu.nome),
                subtitle: Text('Email: ' + usu.email),
                leading: CircleAvatar(
                  child: Text(usu.nome.substring(0, 1)),
                ),
                trailing: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
      ));
    }
    return usuarios;
  }

  _deletarUsuario(context, usu) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Deletar Usuário?"),
              content: Text(usu.nome),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar')),
                TextButton(
                    onPressed: () {
                      this.setState(() {
                        this._deleteUsuario(usu.id);
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

  _deleteUsuario(id) async {
    int response = await UsuarioApi.delUsuario(id);
    if (response == 204) {
      setState(() {
        alert(context, 'Ok. Solicitação atendida \nDeletado o usuário.');
        _usuario = UsuarioApi.listaUsuarios();
      });
    } else if (response == 400) {
      alert(context,
          ':- (  Solicitação não atendida \n   Usuário tem relacionamento\n      de Agendamento..');
    } else if (response == 403) {
      alert(context,
          ':- (  Solicitação não atendida \n      Usuário sem permissão\n      para DELETAR-SE..');
    }
  }
}
